//
//
//
// Created by: Patrik Drab on 31/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import CoreData


protocol StationSearchDelagate: AnyObject {
    func didSelectStation(_ stationInfo: MHD_StationInfo)
}

class StationSearchResultList: UIView {
    private let tableView = UITableView()
    
    var fieldType: InputFieldType = .from
    weak var viewModel: RouteFinderViewModel?
    
    private var alphabeticallyGroupedStations: [String: [MHD_StationInfo]] = [:] {
        didSet {
            alphabetSectionTitles = alphabeticallyGroupedStations.keys.sorted()
            tableView.reloadData()
        }
    }
    private var alphabetSectionTitles: [String] = []
    
    private lazy var context: NSManagedObjectContext = {
        return MHD_CoreDataManager.shared.viewContext
    }()
    
    weak var delegate: StationSearchDelagate?
    
    init() {
        super.init(frame: .zero)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    private func setupTableView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(SearchStationCell.self, forCellReuseIdentifier: SearchStationCell.reuseIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension StationSearchResultList {
    func searchFor(_ searchText: String) {
        alphabeticallyGroupedStations = MHD_StationInfo.searchStationInfosGroupedAlphabetically(context: context, contains: searchText)
    }
    
    func clearSearch() {
        alphabeticallyGroupedStations = [:]
    }
}

extension StationSearchResultList: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return alphabetSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = alphabetSectionTitles[section]
        return alphabeticallyGroupedStations[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchStationCell.reuseIdentifier, for: indexPath) as! SearchStationCell

        let key = alphabetSectionTitles[indexPath.section]
        if let stationInfoItem = alphabeticallyGroupedStations[key]?[indexPath.row] {
            cell.configure(indexPath: indexPath, alphabet: key, stationName: stationInfoItem.stationName)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        if let stationInfoItem = alphabeticallyGroupedStations[alphabetSectionTitles[indexPath.section]]?[indexPath.row] as? MHD_StationInfo {
//            if fieldType == .from && stationInfoItem != viewModel?.toStationInfo {
//                return true
//            } else if fieldType == .to && stationInfoItem != viewModel?.fromStationInfo {
//                return true
//            } else {
//                return false
//            }
//        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = alphabetSectionTitles[indexPath.section]
        if let stationInfoItem = alphabeticallyGroupedStations[key]?[indexPath.row] {
            delegate?.didSelectStation(stationInfoItem)
        }
    }
}

///
/// - RouteFinderViewController
/// - StationSearchViewController
///     - AllStationsList (Table)
///     - StationSearchResultList (Table)
///     - StationsMapViewController


