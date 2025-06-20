//
//
//
// Created by: Patrik Drab on 14/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitPro


class TimeTableViewController: UIViewController, MHD_NavigationDelegate {
    var contentLabelText: NSAttributedString {
        let transportLineName = station.direction?.transportLine?.name ?? ""
        let destinationStationName = station.direction?.endDestination?.stationName ?? ""
        let selectedStation = station.stationInfo?.stationName ?? ""
        
        return NSAttributedStringBuilder()
            .add(text: "Linka č. ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(transportLineName) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .add(text: "smer ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(destinationStationName) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .add(text: "zo zastavky ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(selectedStation)", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    static let reuseIdentifier = "TimeTableViewController"
    
    private let station: MHD_DirectionStation
    private var tableView: TimeTableView!
    
    private var dayTypeSchedules: [MHD_DaytimeSchedule] {
        let schedules = station.schedules?.allObjects as? [MHD_DaytimeSchedule] ?? []
        return schedules.sorted { $0.dayType < $1.dayType }
    }
    
    init(station: MHD_DirectionStation) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10
        setupTimetableView()
    }
    
    private func setupTimetableView() {
        tableView = TimeTableView(dayTypeSchedules: dayTypeSchedules)
        view.addSubview(tableView)
        tableView.pinToSuperviewSafeAreaLayoutGuide()
    }
    
}
