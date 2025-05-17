//
//
//
// Created by: Patrik Drab on 17/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools
import CoreData

class AllStationsViewController: UIViewController {
    private let tableView = UITableView()
    
    private var alphabeticallyGroupedStations: [String: [CDStationInfo]] = [:] {
        didSet {
            alphabetSectionTitles = alphabeticallyGroupedStations.keys.sorted()
            tableView.reloadData()
        }
    }
    private var alphabetSectionTitles: [String] = []
    
    private var context: NSManagedObjectContext {
        return CoreDataManager.shared.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTable()
        fetchStations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(StationSearchViewCell.self, forCellReuseIdentifier: StationSearchViewCell.reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.pinToSuperviewSafeAreaLayoutGuide()
    }
    
    private func fetchStations() {
        alphabeticallyGroupedStations = CDStationInfo.searchStationInfosGroupedAlphabetically(context: context)
    }
    
    
    private func setupNavigationBar() {
        if let navController = navigationController as? NavigationController {
            let attributedText = NSAttributedStringBuilder()
                .add(text: "Všetky zástavky", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize, weight: .bold)])
                .build()
            
            navController.setTitle(attributedText)
        }
    }
}

extension AllStationsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return alphabetSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = alphabetSectionTitles[section]
        return alphabeticallyGroupedStations[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StationSearchViewCell.reuseIdentifier, for: indexPath) as! StationSearchViewCell

        let key = alphabetSectionTitles[indexPath.section]
        if let stationInfoItem = alphabeticallyGroupedStations[key]?[indexPath.row] {
            cell.configure(indexPath: indexPath, alphabet: key, stationName: stationInfoItem.stationName)
        }
        
        return cell
    }
}
