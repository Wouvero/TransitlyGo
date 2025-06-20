//
//
//
// Created by: Patrik Drab on 11/05/2025
// Copyright (c) 2025 MHD
//
//


import UIKit
import UIKitPro


class TimeTableView: UIView {
    static let reuseIdentifier = "TableView"
    
    // MARK: - Variables
    private let dayTypeSchedules: [MHD_DaytimeSchedule]
    
    private var segmentedControl: CustomSegmentedControl!

    
    private let tableView = UITableView()
    private var tableViewData: [MHD_Hour] = [] {
        didSet {
            guard window != nil else { return }
            tableView.reloadData()
        }
    }
    
    private var currentDayTypeIndex: Int?
    private var currentNextHourIndex: Int?
    private var currentNextMinuteIndex: Int?
    
    private var currentNextHour: Int?
    private var currentNextMinute: Int?
    
    private var selectedDayTypeIndex: Int?
    
    private var lastProcessedHour: Int?
    private var lastProcessedMinute: Int?
    private var refreshTimer: Timer?
    
    // MARK: - Initialization
    init(dayTypeSchedules: [MHD_DaytimeSchedule]) {
        self.dayTypeSchedules = dayTypeSchedules
        super.init(frame: .zero)
        
        setupSegmentedControl()
        setupTableView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow != nil {
            // View is being added to a window
            DispatchQueue.main.async { [weak self] in
                self?.setCurrentDayType()
                self?.startAutoUpdates()
            }
        } else {
            // View is being removed from a window
            stopAutoUpdates()
        }
    }
    
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
        // As an extra safety measure (though stopAutoUpdates() should handle this)
        refreshTimer?.invalidate()
    }
    
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            segmentedControl, tableView
        ])
        stackView.axis = .vertical
        stackView.spacing = 0
    
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}


// MARK: - Auto refresh methods
private extension TimeTableView {
    
    private func startAutoUpdates() {
        stopAutoUpdates() // Ensure no duplicate timers
        
        //let now = Date()
        //let components = Calendar.current.dateComponents([.hour, .minute], from: now)
        //lastProcessedHour = components.hour
        //lastProcessedMinute = components.minute
        
        refreshCurrentDeparture(now: Date())
        
        // Schedule periodic updates
        refreshTimer = Timer.scheduledTimer(
            withTimeInterval: 1, // Update every minute
            repeats: true
        ) { [weak self] timer in
            // Only proceed if we're in a window
            guard self?.window != nil else {
                timer.invalidate()
                return
            }
            self?.checkForTimeUpdate()
            self?.tableView.reloadData()
        }
        
        // Ensure timer runs during scrolling
        if let refreshTimer = refreshTimer {
            RunLoop.current.add(refreshTimer, forMode: .common)
        }
    }
    
    private func stopAutoUpdates() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private func checkForTimeUpdate() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute, .second], from: now)
        
        let currentHour = components.hour ?? 0
        let currentMinute = components.minute ?? 0
        
//        if let visiblePaths = tableView.indexPathsForVisibleRows {
//            tableView.reloadRows(at: visiblePaths, with: .none)
//        }
        //print(currentHour, currentMinute)
        //print(lastProcessedHour, lastProcessedMinute)
        
        guard currentHour != lastProcessedHour || currentMinute != lastProcessedMinute else { return }
        
        // Handle day type change at midnight
        // If there is day change, it's call setCurrentDayType
        if lastProcessedHour == 23 && currentHour == 0 { setCurrentDayType() }
        
        refreshCurrentDeparture(now: now)
        
        // Set last processed hour and minute
        lastProcessedHour = currentHour
        lastProcessedMinute = currentMinute
    }
    
    private func refreshCurrentDeparture(now: Date = Date()) {
        markUpcomingDeparture(now: now)
        //print("Refresh Current Departure: ", currentNextHourIndex ?? "-")
        
        guard let currentNextHourIndex else { return }
        
        let indexPath = IndexPath(row: currentNextHourIndex, section: 0)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    private func timeRemainingToNextDeparture(from now: Date = Date()) -> String? {
        guard let hour = currentNextHour,
              let minute = currentNextMinute else { return nil}
        
        
        let calendar = Calendar.current
        //print("\n",hour, "-", minute ,"\n")
        var targetComponent = calendar.dateComponents([.year, .month, .day], from: now)
        targetComponent.hour = hour
        targetComponent.minute = minute
        targetComponent.second = 0
        
        guard let targetDate = calendar.date(from: targetComponent) else { return nil}
        
        let adjustedTarget = targetDate > now ? targetDate : calendar.date(byAdding: .day, value: 1, to: targetDate)!
        
        let timeRemainingToNextDeparture = adjustedTarget.timeIntervalSince(now)
        let timeRemainingToNextDepartureFormated = timeRemainingToNextDeparture.formattedTimeRemaining()
        
//        print("Time remaining to next departure: \(timeRemainingToNextDepartureFormated)")
        return timeRemainingToNextDepartureFormated
    }

}


// MARK: - Update UI
private extension TimeTableView {
    
    private func markUpcomingDeparture(now: Date = Date()) {
        /// - get current `hour` and `minute`
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: now)
        
        let currentHour = components.hour ?? 0
        let currentMinute = components.minute ?? 0
        
        /// 1. getCurentHourData -> currentDayTypeIndex from dayTypeSchedules
        guard let currentDayTypeIndex = currentDayTypeIndex else { return }
        let hourInfoData = getHourInfoData(for: currentDayTypeIndex)
        
        /// 2. check if data are not empty (!isEmpty)
        guard !hourInfoData.isEmpty else { return }
        
        
        
        guard let firstItem = hourInfoData.first,
              let lastItem = hourInfoData.last else { return }
        
        /// 3. check if current hour is bettwen interval (first hourInfoData - last hourInfoData)
        ///     - if not check if we current day type didnt change.
        ///              - if currant day type change -> getCurentHourData -> currentDayTypeIndex and set hout and minute index 0, 0
        ///              - if current day is same set  hout and minute index 0, 0
        guard currentHour >= firstItem.hourInfo && currentHour <= lastItem.hourInfo else {
            //print("We are out of the time range")
            if currentDayTypeIndex == determineCurrentDayType().rawValue {
                //print("Day type didn't change")
                setDefaultIndices()
            } else {
                // print("Day type change")
                setCurrentDayType()
                setDefaultIndices()
            }
            return
        }
        
        
        /// 4. find hour index and minute index
        let transformedHourInfoData = getTransformedHourInfoData(for: hourInfoData, matchingHour: currentHour)
        
        var matchingHourIndex: Int?
        var matchingMinuteIndex: Int?
        
        
        for (hourInfoIndex, hourInfoItem) in transformedHourInfoData.enumerated() {
            
            let minuteInfoData = getMinuteInfoData(for: hourInfoItem)
            
            guard !minuteInfoData.isEmpty else {
                continue
            }
            
            let matchingHourIdx = hourInfoData.firstIndex(where: { $0.hourInfo == hourInfoItem.hourInfo })
        
            let matchingMinuteIdx = hourInfoIndex == 0
            ? minuteInfoData.firstIndex(where: { $0.minuteInfo > currentMinute })
                : 0
            
            
            if let matchingHourIdx = matchingHourIdx,
               let matchingMinuteIdx = matchingMinuteIdx {
                matchingMinuteIndex = matchingMinuteIdx
                matchingHourIndex = matchingHourIdx
                
                currentNextHour = Int(hourInfoItem.hourInfo)
                currentNextMinute = Int(minuteInfoData[matchingMinuteIdx].minuteInfo)
                break
            }
        }
        
        /// 5. set hour and minute index
        if let matchingHourIndex = matchingHourIndex,
           let matchingMinuteIndex = matchingMinuteIndex {
            currentNextHourIndex = matchingHourIndex
            currentNextMinuteIndex = matchingMinuteIndex
        }
    }
    
    private func setDefaultIndices() {
        
        var matchingHourIndex: Int? = nil
        var matchingMinuteIndex: Int? = nil
        
        guard let currentDayTypeIndex = currentDayTypeIndex else { return }
        let hourInfoData = getHourInfoData(for: currentDayTypeIndex)
        
        for (index, hourInfoItem) in hourInfoData.enumerated() {
            let minuteInfoData = getMinuteInfoData(for: hourInfoItem)
            
            if !minuteInfoData.isEmpty {
                matchingHourIndex = index
                matchingMinuteIndex = 0
                
                currentNextHour = Int(hourInfoItem.hourInfo)
                currentNextMinute = Int(minuteInfoData[0].minuteInfo)
                break
            }
        }
        
        if let hourIndex = matchingHourIndex, let minuteIndex = matchingMinuteIndex {
            //print("Default: ",hourIndex, minuteIndex)
            currentNextHourIndex = hourIndex
            currentNextMinuteIndex = minuteIndex
        } else {
            //print("Default: nil, nil")
            currentNextHourIndex = nil
            currentNextMinuteIndex = nil
        }
        
    }
    
}


// MARK: - Segmented Control Setup & Handling
extension TimeTableView: CustomSegmentedControlProtocol {
    
    func setupSegmentedControl() {
        let segmentTitles = dayTypeSchedules.compactMap { DayType(rawValue: Int($0.dayType))?.description }
        
        segmentedControl = CustomSegmentedControl(items: segmentTitles)
        segmentedControl.delegate = self
       
        setCurrentDayType()
    }
    
    func setCurrentDayType() {
        let currentDayType = determineCurrentDayType()
        
        if let index = segmentedControl.findFirstSegmentIndex(withTitle: currentDayType.description) {
            segmentedControl.selectedSegmentIndex = index
            currentDayTypeIndex = index
            selectedDayTypeIndex = index
            handleDayTypeSelection(index)
        }
    }
    
    func determineCurrentDayType() -> DayType {
        let calendar = Calendar.current
        let date = Date()
        
        // 1. Check if it's a weekend (Saturday or Sunday)
        let isWeekend = calendar.isDateInWeekend(date)
        if isWeekend { return .weekendOrHoliday }
        
        // 2. Check if it's a holiday
        if isHoliday(date: date, calendar: calendar) { return .weekendOrHoliday }
        
        // 3. Check if it's during school holidays
        if isSchoolHoliday(date: date, calendar: calendar) { return .workingHoliday }
        
        // 4. Default to regular school/work day
        return .workingSchoolDay
    }
    
    func handleDayTypeSelection(_ dayTypeIndex: Int) {
        selectedDayTypeIndex = dayTypeIndex
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            tableViewData = getHourInfoData(for: dayTypeIndex)
        }
    }
    
    // MARK: - Segmented Control Actions (Delegate)
    func didTapSegment(at index: Int) {
        handleDayTypeSelection(index)
    }
    
}


// MARK: - Schedule Data Access
private extension TimeTableView {
    
    func getMinuteInfoData(for hourEntity: MHD_Hour) -> [MHD_Minute] {
        hourEntity.minutes?
            .allObjects
            .compactMap { $0 as? MHD_Minute }
            .sorted { $0.minuteInfo < $1.minuteInfo} ?? []
    }
    
    func getHourInfoData(for dayTypeIndex: Int) -> [MHD_Hour] {
        dayTypeSchedules[dayTypeIndex].hours?
            .allObjects
            .compactMap { $0 as? MHD_Hour }
            .sorted { $0.hourInfo < $1.hourInfo } ?? []
    }
    
    func getTransformedHourInfoData(for hourInfoData: [MHD_Hour], matchingHour: Int) -> [MHD_Hour] {
        guard !hourInfoData.isEmpty,
              let index = hourInfoData.firstIndex(where: { $0.hourInfo == matchingHour }) else { return [] }
        
  
        var transformed = [hourInfoData[index]]     // Matching hour first
        transformed += hourInfoData[(index+1)...]   // Adding Later hours
        transformed += hourInfoData[0..<index]      // Adding Earlier hours
        
        return transformed
    }
    
}


// MARK: - Setup table, UITableViewDelegate & UITableViewDataSource methods
extension TimeTableView: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(
            TimeTableViewCell.self,
            forCellReuseIdentifier: TimeTableViewCell.reuseIdentifier
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TimeTableViewCell.Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.reuseIdentifier, for: indexPath) as! TimeTableViewCell
        
        let isCurrentDayType = currentDayTypeIndex == selectedDayTypeIndex
        let isHighlightRow = isCurrentDayType && indexPath.row == currentNextHourIndex
        
        cell.configure(
            with: tableViewData[indexPath.row],
            index: indexPath.row,
            currentTable: currentDayTypeIndex == selectedDayTypeIndex,
            highlightRowIndex: currentNextHourIndex,
            highlightMinuteIndex: currentNextMinuteIndex,
            timeRemaining: isHighlightRow ? timeRemainingToNextDeparture() : nil
        )
        
        return cell
    }
    
}
