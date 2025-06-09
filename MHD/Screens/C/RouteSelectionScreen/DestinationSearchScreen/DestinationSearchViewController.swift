//
//
//
// Created by: Patrik Drab on 19/05/2025
// Copyright (c) 2025 MHD 
//
//         


import UIKit
import UIKitPro


class DestinationSearchViewController: UIViewController, MHD_NavigationDelegate {
    
    var fieldType: InputFieldType = .from
    
    // MARK: - Properties
    var contentLabelText: NSAttributedString {
        return NSAttributedStringBuilder()
            .add(text: fieldType.rawValue, attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    func shouldHideTabBar() -> Bool { true }
    
    private let destinationSearchTextField = CustomSearchTextField()

    private let tableView = DestinationSearchTable()

    private let searchOptionsView = SearchOptionsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10
        
        setupDestinationSearchTextField()
        setupTableView()
        setupSearchOptionsView()
        setupDismissKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        destinationSearchTextField.activateKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destinationSearchTextField.dissmissKeyboard()
    }
}

extension DestinationSearchViewController {
    
    private func setupDestinationSearchTextField() {
        destinationSearchTextField.translatesAutoresizingMaskIntoConstraints = false
        destinationSearchTextField.searchDelegate = self
        
        view.addSubview(destinationSearchTextField)
        
        NSLayoutConstraint.activate([
            destinationSearchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            destinationSearchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            destinationSearchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: destinationSearchTextField.bottomAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.isHidden = true
    }
    
    private func setupSearchOptionsView() {
        searchOptionsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchOptionsView)
        
        NSLayoutConstraint.activate([
            searchOptionsView.topAnchor.constraint(equalTo: destinationSearchTextField.bottomAnchor, constant: 20),
            searchOptionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchOptionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchOptionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        searchOptionsView.isHidden = false
    }
    
}

// MARK: - SearchTextFieldDelegate
extension DestinationSearchViewController: SearchTextFieldDelegate {
    
    func clearTableSearch() {
        tableView.isHidden = true
        searchOptionsView.isHidden = false
        tableView.clearSearch()
    }
    
    func searchTextFieldDidChange(_ text: String?) {
        guard let searchText = text, !searchText.isEmpty else {
            searchOptionsView.isHidden = false
            destinationSearchTextField.clearTextSearch()
            return
        }
        searchOptionsView.isHidden = true
        tableView.isHidden = false
        destinationSearchTextField.setClearTextButtonHidden(false)
        tableView.searchFor(searchText)
    }
    
}

extension DestinationSearchViewController {
    
    private func setupDismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapOutsideKeyboard)
        )
        tapGesture.cancelsTouchesInView = false // Allows other controls to still receive touch events

        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapOutsideKeyboard(_ sender: UITapGestureRecognizer) {
        destinationSearchTextField.dissmissKeyboard()
    }
    
}

extension DestinationSearchViewController: DestinationSearchTableDelagate {
    
    func didSelectStation(_ stationInfo: MHD_StationInfo) {
        NotificationCenter.default.post(
            name: .didSelectStation,
            object: stationInfo,
            userInfo: ["fieldType": fieldType]
        )
        
        destinationSearchTextField.dissmissKeyboard()
        pop()
    }
    
}
