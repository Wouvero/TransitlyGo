//
//
//
// Created by: Patrik Drab on 14/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools


class TimeTableViewController: UIViewController {
    static let reuseIdentifier = "TimeTableViewController"
    
    private let station: CDStation
    private var tableView: TableView!
    
    private var dayTypeSchedules: [CDDayTypeSchedule] {
        let schedules = station.transitSchedule?.dayTypeSchedules?.allObjects as? [CDDayTypeSchedule] ?? []
        return schedules.sorted { $0.dayType < $1.dayType }
    }
    
    init(station: CDStation) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTimetableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupTimetableView() {
        tableView = TableView(dayTypeSchedules: dayTypeSchedules)
        view.addSubview(tableView)
        tableView.pinToSuperviewSafeAreaLayoutGuide()
    }
    
    private func setupNavigationBar() {
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
