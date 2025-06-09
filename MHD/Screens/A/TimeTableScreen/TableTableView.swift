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
    
    //private var segmentedControl: UISegmentedControl!
    private var segmentedControl: CustomSegmentedControl!

    
    private let tableView = UITableView()
    private var tableViewData: [MHD_TimeTable] = [] {
        didSet { tableView.reloadData() }
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
        
        DispatchQueue.main.async { [weak self] in
            self?.startAutoUpdates()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { stopAutoUpdates() }
    
   
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.register(TimeTableViewCell.self, forCellReuseIdentifier: TimeTableViewCell.reuseIdentifier)
    }
    
    private func setupLayout() {
        let stackView = UIStackView(
            arrangedSubviews: [segmentedControl, tableView],
            axis: .vertical,
            spacing: 0
        )
        
        addSubview(stackView)
        stackView.pinToSuperviewSafeAreaLayoutGuide()
    }
}


// MARK: - Auto refresh methods
private extension TimeTableView {
    
    private func startAutoUpdates() {
        stopAutoUpdates() // Ensure no duplicate timers
        
        let now = Date()
        let components = Calendar.current.dateComponents([.hour, .minute], from: now)
        lastProcessedHour = components.hour
        lastProcessedMinute = components.minute
        
        refreshCurrentDeparture(now: now)
        //timeRemainingToNextDeparture(from: now)
        
        // Schedule periodic updates
        refreshTimer = Timer.scheduledTimer(
            withTimeInterval: 1, // Update every minute
            repeats: true
        ) { [weak self] _ in
            self?.checkForTimeUpdate()
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
        
        if let visiblePaths = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: visiblePaths, with: .none)
        }
        
        
        guard currentHour != lastProcessedHour || currentMinute != lastProcessedMinute else {
            return
        }
        
        // Handle day type change at midnight
        if lastProcessedHour == 23 && currentHour == 0 {
            setCurrentDayType()
        }
        
        refreshCurrentDeparture(now: now)
        
        
        lastProcessedHour = currentHour
        lastProcessedMinute = currentMinute
    }
    
    private func refreshCurrentDeparture(now: Date = Date()) {
        markUpcomingDeparture(now: now)
        tableView.reloadData()
    }

}


// MARK: -
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
        guard currentHour >= firstItem.hour && currentHour <= lastItem.hour else {
            print("We are out of the time range")
            if currentDayTypeIndex == determineCurrentDayType().rawValue {
                print("Same")
                setDefaultIndices()
            } else {
                print("Different")
                setCurrentDayType()
                setDefaultIndices()
            }
            return
        }
        
        
        /// 4. find hour index and minute index
        //print(currentHour)
        let transformedHourInfoData = getTransformedHourInfoData(for: hourInfoData, matchingHour: currentHour)
        
        var matchingHourIndex: Int?
        var matchingMinuteIndex: Int?
        
        
        for (hourInfoIndex, hourInfoItem) in transformedHourInfoData.enumerated() {
            
            let minuteInfoData = getMinuteInfoData(for: hourInfoItem)
            
            guard !minuteInfoData.isEmpty else {
                continue
            }
            
            let matchingHourIdx = hourInfoData.firstIndex(where: { $0.hour == hourInfoItem.hour })
        
            let matchingMinuteIdx = hourInfoIndex == 0
                ? minuteInfoData.firstIndex(where: { $0.minute > currentMinute })
                : 0
            
            
            if let matchingHourIdx = matchingHourIdx,
               let matchingMinuteIdx = matchingMinuteIdx {
                matchingMinuteIndex = matchingMinuteIdx
                matchingHourIndex = matchingHourIdx
                
                currentNextHour = Int(hourInfoItem.hour)
                currentNextMinute = Int(minuteInfoData[matchingMinuteIdx].minute)
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
                
                currentNextHour = Int(hourInfoItem.hour)
                currentNextMinute = Int(minuteInfoData[0].minute)
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
        //print("Curent day type: ",currentDayType)
        if let currentDayTypeIndex = segmentedControl.findFirstSegmentIndex(withTitle: currentDayType.description) {
            //print(currentDayTypeIndex)
            segmentedControl.selectedSegmentIndex = currentDayTypeIndex
            self.currentDayTypeIndex = currentDayTypeIndex
            selectedDayTypeIndex = currentDayTypeIndex
            handleDayTypeSelection(currentDayTypeIndex)
        }
    }
    
    func determineCurrentDayType() -> DayType {
        let calendar = Calendar.current
        let date = Date()
        
        // 1. Check if it's a weekend (Saturday or Sunday)
        let isWeekend = calendar.isDateInWeekend(date)
        if isWeekend {
            return .weekendOrHoliday
        }
        
        // 2. Check if it's a holiday
        if isHoliday(date: date, calendar: calendar) {
            return .weekendOrHoliday
        }
        
        // 3. Check if it's during school holidays
        if isSchoolHoliday(date: date, calendar: calendar) {
            return .workingHoliday
        }
        
        // 4. Default to regular school/work day
        return .workingSchoolDay
    }
    
    func handleDayTypeSelection(_ dayTypeIndex: Int) {
        //print("Handle Day type selection \(dayTypeIndex)")
        selectedDayTypeIndex = dayTypeIndex
        tableViewData = getHourInfoData(for: dayTypeIndex)
    }
    
    // MARK: - Segmented Control Actions (Delegate)
    func didTapSegment(at index: Int) {
        handleDayTypeSelection(index)
    }
}


// MARK: - Schedule Data Access
private extension TimeTableView {
    
    func getMinuteInfoData(for hourEntity: MHD_TimeTable) -> [MHD_MinuteInfo] {
        let minuteInfoData = hourEntity.minuteInfos?.allObjects as? [MHD_MinuteInfo] ?? []
        let minuteInfoDataSorted = minuteInfoData.sorted { $0.minute < $1.minute}
        return minuteInfoDataSorted
    }
    
    func getHourInfoData(for dayTypeIndex: Int) -> [MHD_TimeTable] {
        let hourInfoData = dayTypeSchedules[dayTypeIndex].timeTables?.allObjects as? [MHD_TimeTable] ?? []
        let hourInfoDataSorted = hourInfoData.sorted { $0.hour < $1.hour }
        return hourInfoDataSorted
    }
    
    func getTransformedHourInfoData(for hourInfoData: [MHD_TimeTable], matchingHour: Int) -> [MHD_TimeTable] {
        guard !hourInfoData.isEmpty else { return [] }
        
        guard let index = hourInfoData.firstIndex(where: { $0.hour == matchingHour }) else {
            return []
        }
        
        var transformed = [hourInfoData[index]]     // Matching hour first
        transformed += hourInfoData[(index+1)...]   // Adding Later hours
        transformed += hourInfoData[0..<index]      // Adding Earlier hours
        
        return transformed
    }
    
}


// MARK: - UITableViewDelegate & UITableViewDataSource methods
extension TimeTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.reuseIdentifier, for: indexPath) as! TimeTableViewCell
        
        let isHighlightRow = currentDayTypeIndex == selectedDayTypeIndex && indexPath.row == currentNextHourIndex
        
        cell.configure(
            with: tableViewData[indexPath.row],
            cellIndex: indexPath.row,
            currentTable: currentDayTypeIndex == selectedDayTypeIndex,
            highlightRowIndex: currentNextHourIndex,
            highlightMinuteIndex: currentNextMinuteIndex,
            timeRemaining: isHighlightRow ? timeRemainingToNextDeparture() : nil
        )
        
        return cell
    }
    
}
