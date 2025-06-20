//
//
//
// Created by: Patrik Drab on 17/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import CoreData
import UIKitPro

class StationsListViewController: UIViewController, MHD_NavigationDelegate, FieldTypeHandling {
    var contentLabelText: NSAttributedString {
        return NSAttributedStringBuilder()
            .add(text: "Všetky zastávky", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    func shouldHideTabBar() -> Bool { true }
    
    var fieldType: InputFieldType = .from
    
    private let tableView = UITableView()
    
    private var alphabeticallyGroupedStations: [String: [MHD_StationInfo]] = [:] {
        didSet {
            alphabetSectionTitles = alphabeticallyGroupedStations.keys.sorted()
            tableView.reloadData()
        }
    }
    private var alphabetSectionTitles: [String] = []
    
    private var context: NSManagedObjectContext {
        return MHD_CoreDataManager.shared.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTable()
        fetchStations()
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(DestinationSearchTableCell.self, forCellReuseIdentifier: DestinationSearchTableCell.reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.pinToSuperviewSafeAreaLayoutGuide()
    }
    
    private func fetchStations() {
        alphabeticallyGroupedStations = MHD_StationInfo.searchStationInfosGroupedAlphabetically(context: context)
    }
    
}

extension StationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return alphabetSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = alphabetSectionTitles[section]
        return alphabeticallyGroupedStations[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let stationInfoItem = alphabeticallyGroupedStations[alphabetSectionTitles[indexPath.section]]?[indexPath.row] {
            NotificationCenter.default.post(
                name: .didSelectStation,
                object: stationInfoItem,
                userInfo: ["fieldType": fieldType]
            )
            popToRoot()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DestinationSearchTableCell.reuseIdentifier, for: indexPath) as! DestinationSearchTableCell

        let key = alphabetSectionTitles[indexPath.section]
        if let stationInfoItem = alphabeticallyGroupedStations[key]?[indexPath.row] {
            cell.configure(indexPath: indexPath, alphabet: key, stationName: stationInfoItem.stationName)
        }
        
        return cell
    }
}
