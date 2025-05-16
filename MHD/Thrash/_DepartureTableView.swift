//
//
//
// Created by: Patrik Drab on 03/05/2025
// Copyright (c) 2025 MHD
//
//

import UIKit


class DepartureTableView: UIView, UITableViewDelegate{
    static let reuseIdentifier = "DepartureTableView"
    
    typealias DataSource = UITableViewDiffableDataSource<Int, CDHourlyDeparture>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, CDHourlyDeparture>
    
    private var departureTableView = UITableView()
    
    private var data: [CDHourlyDeparture] = [] {
        didSet {
            applySnapshot()
        }
    }
    private var dataSource: UITableViewDiffableDataSource<Int, CDHourlyDeparture>!
    
    
    
    
    private var updateTimer: Timer?
    //private var timeToNextDeparture:
    
    private var lastProcessedHour: Int? {
        didSet {
            print("Last processed hour: \(String(describing: lastProcessedHour))")
        }
    }
    private var lastProcessedMinute: Int? {
        didSet {
            print("Last processed minute: \(String(describing: lastProcessedMinute))")
        }
    }
    
    private var lastActiveHourIndex: Int?
    
    private var activeHourIndex: Int? {
        didSet {
            print("🟢Active hour index: \(String(describing: activeHourIndex))")
        }
    }
    private var activeMinuteIndex: Int? {
        didSet {
            print("🟢Active minute index: \(String(describing: activeMinuteIndex))")
        }
    }
    
    
    init() {
        super.init(frame: .zero)
        setupCollection()
        configureDataSource()
        applySnapshot()
    }
    
    private func setupCollection() {
        departureTableView.register(DepartureTableViewCell.self, forCellReuseIdentifier: DepartureTableViewCell.reuseIdentifier)
        
        departureTableView.delegate = self
        departureTableView.separatorStyle = .none
        departureTableView.showsVerticalScrollIndicator = false
        departureTableView.showsHorizontalScrollIndicator = false
        
        // Enable automatic cell sizing
        departureTableView.rowHeight = UITableView.automaticDimension
        departureTableView.estimatedRowHeight = 60
        
        addSubviews(departureTableView)
        departureTableView.pinInSuperview()
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, CDHourlyDeparture>(tableView: departureTableView) {[weak self] tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
            let row = tableView.dequeueReusableCell(withIdentifier: DepartureTableViewCell.reuseIdentifier, for: indexPath) as! DepartureTableViewCell
            
            row.configure(
                with: item,
                departureCellIndex: indexPath.row,
                activeHourIndex: self.activeHourIndex,
                activeMinuteIndex: self.activeMinuteIndex)
            
            return row
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        
        // Force reload of active hour cell
        if let activeHour = activeHourIndex{
            snapshot.reloadItems([data[activeHour]])
            
            if let lastHour = lastActiveHourIndex {
                snapshot.reloadItems([data[lastHour]])
            }
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
        lastActiveHourIndex = activeHourIndex
    }
  
    
    // Add view hierarchy tracking
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow == nil {
            // View is being removed - stop updates
            stopAutoUpdates()
        } else {
            // View is being added - start updates if we have data
            if !data.isEmpty {
                startAutoUpdates()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func update(with departures: [CDHourlyDeparture]) {
        self.data = departures
        selectNextDeparture()
        
        // Only start updates if we're in the window hierarchy
        if window != nil {
            startAutoUpdates()
        }
    }
}

extension DepartureTableView {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}


private extension DepartureTableView {
    
    func selectNextDeparture() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute], from: now)
        
        let currentHour = components.hour ?? 0
        let currentMinute = components.minute ?? 0
        
        // Early return if no data
        guard !data.isEmpty else {
            setDefaultActiveIndices()
            UIView.performWithoutAnimation {
                applySnapshot()
            }
            return
        }
        
        // Find matching hour
        // If there is no maching hour then its first hour in index and also first index for minute row
        guard var matchingHourIndex = data.firstIndex(where: { $0.hour == currentHour }) else {
            setDefaultActiveIndices()
            UIView.performWithoutAnimation {
                applySnapshot()
            }
            return
        }
        
        
        //var nextHourIndex:
        
        // Find matching minute in current hour
        var matchingMinuteIndex: Int? = nil
        // Get sorted minutes for the hour (matcfhing hour index)
        let minuteInfoData = data[matchingHourIndex].minutes?.allObjects as? [CDMinuteInfo] ?? []
        let minuteInfoDataSorted = minuteInfoData.sorted { $0.minute < $1.minute}
        
        for (index, minuteInfo) in minuteInfoDataSorted.enumerated() {
            if minuteInfo.minute >= currentMinute {
                matchingMinuteIndex = index
                break
            }
        }
        
        lastActiveHourIndex = matchingHourIndex
        
        while (matchingMinuteIndex == nil) {
            matchingHourIndex = (matchingHourIndex + 1) % data.count
            if let minutesCount = data[matchingHourIndex].minutes?.allObjects.count, minutesCount > 0 {
                matchingMinuteIndex = 0
            }
        }
        
        if activeHourIndex != matchingHourIndex || activeMinuteIndex != matchingMinuteIndex {
            activeHourIndex = matchingHourIndex
            activeMinuteIndex = matchingMinuteIndex
            UIView.performWithoutAnimation {
                applySnapshot()
            }
        }
    }
    
    func setDefaultActiveIndices() {
        if !data.isEmpty, let minutesCount = data[0].minutes?.allObjects.count, minutesCount > 0 {
            activeHourIndex = 0
            activeMinuteIndex = 0
        } else {
            activeHourIndex = nil
            activeMinuteIndex = nil
        }
    }
}

extension DepartureTableView {
    
    
    private func startAutoUpdates() {
        stopAutoUpdates() // Stop any existing timer
        //print("START Timer")
        
        // Get current time immediately
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute, .second], from: now)
        //let currentSeconds = components.second ?? 0
        //let delay = 60.0 - Double(currentSeconds)
        
        lastProcessedHour = components.hour
        lastProcessedMinute = components.minute
        
        // Schedule first update exactly at minute change
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
//            self?.checkForTimeUpdate()
//            // Then switch to 60-second intervals
//            self?.updateTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
//                self?.checkForTimeUpdate()
//            }
//        }
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkForTimeUpdate()
        }
        if let timer = updateTimer {
            // Add to RunLoop in `.common` mode to keep it running during UI interactions
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    private func stopAutoUpdates() {
        //print("STOP")
        updateTimer?.invalidate()
        updateTimer = nil
        lastProcessedHour = nil
        lastProcessedMinute = nil
    }
    
    private func checkForTimeUpdate() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute, .second], from: now)
        
        let currentHour = components.hour ?? 0
        let currentMinute = components.minute ?? 0
        let currentSecond = components.second ?? 0
        
        print(currentHour, currentMinute, currentSecond)
        
        // Only proceed if hour or minute changed
        guard currentHour != lastProcessedHour || currentMinute != lastProcessedMinute else {
            return
        }
        
        selectNextDeparture()
        
        // Update last processed time
        lastProcessedHour = currentHour
        lastProcessedMinute = currentMinute
    }
}
