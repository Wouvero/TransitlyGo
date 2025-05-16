//
//
//
// Created by: Patrik Drab on 29/03/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import SwiftUI
import UIKitTools


class DepartureTableViewController: UIViewController {
    static let reuseIdentifier = "DepartureTableViewController"
    
    private let station: CDStation
    
    private var dayTypeSchedules: [CDDayTypeSchedule] {
        let schedules = station.transitSchedule?.dayTypeSchedules?.allObjects as? [CDDayTypeSchedule] ?? []
        return schedules.sorted { $0.dayType < $1.dayType }
    }
    
    private var segmentedControl: UISegmentedControl!
    
    private let timetableView = DepartureTableView()
    
    init(station: CDStation) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(station:) instead. This controller doesn't support Storyboards.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

private extension DepartureTableViewController {
    
    func initialSetup() {
        view.backgroundColor = .systemBackground
        setupSegmentedControll()
        setupTimeTableCollection()
    }
    
    func setupTimeTableCollection() {
        view.addSubview(timetableView)
        timetableView.pinInSuperview()
    }
    
    func setupSegmentedControll() {
        let segmentTitles = dayTypeSchedules.compactMap { DayType(rawValue: Int($0.dayType))?.description }
        
        guard !segmentTitles.isEmpty else {
            print("No valid day types available")
            return
        }
        
        segmentedControl = UISegmentedControl(items: segmentTitles)
        view.addSubview(segmentedControl)
        segmentedControl.pinToSuperview(edges: [.topSafeArea, .leading, .trailing])
        
        if let currentDayType = determineCurrentDayType(),
           let dayTypeIndex = dayTypeSchedules.firstIndex(where: {
               DayType(rawValue: Int($0.dayType)) == currentDayType
           }) {
            segmentedControl.selectedSegmentIndex = dayTypeIndex
            handleDayTypeSelection(dayTypeIndex)
        }
        
        // Add target for value changes
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        // Ensure the selected index is valid
        guard sender.selectedSegmentIndex < dayTypeSchedules.count else { return }
        handleDayTypeSelection(sender.selectedSegmentIndex)
    }
    
    func determineCurrentDayType() -> DayType? {
        let calendar = Calendar.current
        let date = Date()
        
        if calendar.isDateInWeekend(date) {
            return .weekendOrHoliday
        }
        // 2. Check for holidays (you'll need to implement your holiday check)
        //if isHoliday(date) {
        //    return .weekendOrHoliday
        //}
        
        // 3. Check for school holidays (implement your logic)
        //if isSchoolHoliday(date) {
        //    return .workingHoliday
        //}
        
        return .workingSchoolDay
    }
    
    
    func handleDayTypeSelection(_ dayTypeIndex: Int) {
        let selectedSchedule = dayTypeSchedules[dayTypeIndex]
        let departures = selectedSchedule.timeTables?.allObjects as? [CDHourlyDeparture] ?? []
        let sortedDepartures = departures.sorted { $0.hour < $1.hour }
        timetableView.update(with: sortedDepartures)
    }
    
    func setupNavigationBar() {
        if let navController = navigationController as? NavigationController {
            
            let transportLineName = station.direction?.line?.name ?? ""
            let destinationStationName = station.direction?.destinationStation?.stationName ?? ""
            let selectedStation = station.stationInfo?.stationName ?? ""
            
            
            let attributedText = NSAttributedStringBuilder()
                .add(text: "Linka č. ", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize)])
                .add(text: "\(transportLineName) ", attributes: [.font: UIFont.boldSystemFont(ofSize: navigationBarTitleSize)])
                .add(text: "smer ", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize)])
                .add(text: "\(destinationStationName) ", attributes: [.font: UIFont.boldSystemFont(ofSize: navigationBarTitleSize)])
                .add(text: "zo zastavky ", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize)])
                .add(text: "\(selectedStation)", attributes: [.font: UIFont.boldSystemFont(ofSize: navigationBarTitleSize)])
                .build()
            
            navController.setTitle(attributedText)
        }
    }
}
//
//struct TimetableViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        ViewControllerPreview{TimetableViewController()}
//            .ignoresSafeArea(.all)
//    }
//}
