//
//
//
// Created by: Patrik Drab on 16/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools


class SearchTableView: UIView {
    private var tableView: UITableView!
    private var searchController: UISearchController!
    
    
    private var dataSource: [String] = ["Auto", "Jablko", "Lietadlo", "Porshe", "Tomas", "Presov", "Website", "Swift", "UIKit"] // Example data source
    private var filteredData: [String] = [] // For search results
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        
        setupTable()
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTable() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        addSubview(tableView)
        tableView.pinToSuperviewSafeAreaLayoutGuide()
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Vyhľadať"
        
        tableView.tableHeaderView = searchController.searchBar
    }
}

extension SearchTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredData.count : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        
        let data = searchController.isActive ? filteredData[indexPath.row] : dataSource[indexPath.row]
    
        cell.textLabel?.text = data
        return cell
    }
}

extension SearchTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        filteredData = dataSource.filter { item in
            return item.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}




class SearchBarViewController: UIViewController {
    
    private let searchTableView = SearchTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupSearchTableView() {
        view.addSubview(searchTableView)
        searchTableView.pinInSuperview()
    }
    
    private func setupNavigationBar() {
        if let navController = navigationController as? NavigationController {
            let attributedText = NSAttributedStringBuilder()
                .add(text: "Vyhľadanie spojenia", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize)])
                .build()
            
            navController.setTitle(attributedText)
        }
    }
}
