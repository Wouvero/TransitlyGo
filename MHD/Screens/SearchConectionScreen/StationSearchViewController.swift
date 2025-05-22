//
//
//
// Created by: Patrik Drab on 19/05/2025
// Copyright (c) 2025 MHD 
//
//         


import UIKit
import CoreData
import UIKitTools


class StationSearchViewController: UIViewController {
    
    //weak var delegate: StationSearchDelegate?
    
    var fieldType: InputFieldType = .from
    
    private let searchTextField = UITextField()
    
    private let tableView = UITableView()
    
    private var alphabeticallyGroupedStations: [String: [CDStationInfo]] = [:] {
        didSet {
            alphabetSectionTitles = alphabeticallyGroupedStations.keys.sorted()
            tableView.reloadData()
        }
    }
    
    private var alphabetSectionTitles: [String] = []
    
    private lazy var context: NSManagedObjectContext = {
        return CoreDataManager.shared.viewContext
    }()
    
    private let optionsView = UIView(color: .systemBackground)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupSearchTextField()
        setupTable()
        //setupSearchOptionsView()
        
        let v = UIView(color: .systemBlue)
        v.setDimensions(width: 100, height: 100)
        view.addSubview(v)
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushToMapController)))
        v.center()
        
//        let button = UIButton()
//        button.titleLabel?.textColor = .black
//        button.titleLabel?.text = "test"
//        button.addTarget(self, action: #selector(pushToStationController), for: .touchUpInside)
//        
//        view.addSubview(button)
//        button.center()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
        tabBarController?.setTabBarContentHidden(true)
        searchTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTextField.resignFirstResponder()
    }
}

extension StationSearchViewController {
    
    private func setupSearchTextField() {
        // Setup placeholder
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: fieldType.rawValue,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray,
            ]
        )
        // Setup text
        searchTextField.attributedText = NSAttributedString(
            string: "",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
            ]
        )
        // Setup cursor color
        searchTextField.tintColor = Colors.primary
        searchTextField.layer.backgroundColor = UIColor.systemBackground.cgColor
                
        // Setup left view
        let leftView = UIView()
        leftView.setDimensions(width: 16, height: 50)
        searchTextField.leftViewMode = .always
        searchTextField.leftView = leftView
        
        // Setup right view
        let rightView = UIView()
        rightView.setDimensions(width: 60, height: 50)
        searchTextField.rightViewMode = .always
        searchTextField.rightView = rightView
        
        let clearTextButton = UIButton()
        clearTextButton.setDimensions(width: 50, height: 50)
        let xmarkCircleIcon = IconImageView(systemName: "xmark.circle", config: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold, scale: .medium), tintColor: UIColor.systemGray)
        
        rightView.addSubview(clearTextButton)
        clearTextButton.trailing()
        
        clearTextButton.addSubview(xmarkCircleIcon)
        xmarkCircleIcon.center()
        
        clearTextButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        
        // Setup toolbar
        searchTextField.keyboardType = .default
        setupToolBar()
        
        // Add bottom border
        searchTextField.addBorder(for: .bottom, in: .systemGray3, width: 1)
        
        view.addSubview(searchTextField)
        
        // Setup constrains
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add target
        searchTextField.addTarget(self, action: #selector(searchTextFieldChanged), for: .editingChanged)
    }
    
    private func setupToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dissmissKeyboard))
        
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        
        searchTextField.inputAccessoryView = toolBar
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(StationSearchViewCell.self, forCellReuseIdentifier: StationSearchViewCell.reuseIdentifier)
        

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchOptionsView() {
        
        optionsView.isHidden = false
        optionsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(optionsView)
        NSLayoutConstraint.activate([
            optionsView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            optionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            optionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            optionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let option_icon_1 = IconImageView(systemName: "flag.fill")
        let option_icon_2 = IconImageView(systemName: "location.fill")
        let option_icon_3 = IconImageView(systemName: "map.fill")
        
        let option_label = UILabel(
            text: "alebo vyber",
            font: UIFont.systemFont(ofSize: 14, weight: .regular),
            textColor: .black,
            textAlignment: .left,
            numberOfLines: 1
        )
        let option_label_1 = UILabel(
            text: "Zo zoznamu všetkých",
            font: UIFont.systemFont(ofSize: 16, weight: .medium),
            textColor: .black,
            textAlignment: .left,
            numberOfLines: 1
        )
        let option_label_2 = UILabel(
            text: "Z najbližších podľa polohy",
            font: UIFont.systemFont(ofSize: 16, weight: .medium),
            textColor: .black,
            textAlignment: .left,
            numberOfLines: 1
        )
        let option_label_3 = UILabel(
            text: "Na mape",
            font: UIFont.systemFont(ofSize: 16, weight: .medium),
            textColor: .black,
            textAlignment: .left,
            numberOfLines: 1
        )
        
        let optionStack_1 = UIStackView(
            arrangedSubviews: [option_icon_1, option_label_1, UIView()],
            axis: .horizontal,
            spacing: 8
        )
        let optionStack_2 = UIStackView(
            arrangedSubviews: [option_icon_2, option_label_2, UIView()],
            axis: .horizontal,
            spacing: 8
        )
        let optionStack_3 = UIStackView(
            arrangedSubviews: [option_icon_3, option_label_3, UIView()],
            axis: .horizontal,
            spacing: 8
        )
        
        optionStack_1.isUserInteractionEnabled = true
        optionStack_3.isUserInteractionEnabled = true
        
        optionStack_1.backgroundColor = .red.withAlphaComponent(0.3)
        optionStack_3.backgroundColor = .blue.withAlphaComponent(0.3)
        
        let tapGestureRecohnizer_1 = UITapGestureRecognizer(target: self, action: #selector(pushToStationController))
        let tapGestureRecohnizer_3 = UITapGestureRecognizer(target: self, action: #selector(pushToMapController))
      
        
        optionStack_1.addGestureRecognizer(tapGestureRecohnizer_1)
        optionStack_3.addGestureRecognizer(tapGestureRecohnizer_3)
        
        let optionsStack = UIStackView(
            arrangedSubviews: [optionStack_1, optionStack_2, optionStack_3],
            axis: .vertical,
            spacing: 32
        )
        
        optionsStack.addSubview(option_label)
        option_label.topLeading(offset: .init(x: -16, y: -48))
        
        optionsView.addSubview(optionsStack)
        optionsStack.top(offset: .init(x: 0, y: 64))
    }
    
}

extension StationSearchViewController {
    
    @objc private func pushToStationController(_ sender: UITapGestureRecognizer) {
        print("Station")
        let stationsListViewController = StationsListViewController()
        navigationController?.pushViewController(stationsListViewController, animated: false)
    }
    
    @objc private func pushToMapController(_ sender: UITapGestureRecognizer) {
        print("Map")

        let mapViewController = MapViewController()
        navigationController?.pushViewController(mapViewController, animated: false)
    }
    
    @objc private func dissmissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    @objc private func clearTextField() {
        searchTextField.text = ""
        alphabeticallyGroupedStations = [:]
    }
    
    @objc private func searchTextFieldChanged(_ sender: UITextField) {
        guard let searchText = sender.text, !searchText.isEmpty else {
            optionsView.isHidden = false
            alphabeticallyGroupedStations = [:]
            tableView.reloadData()
            return
        }
        
        optionsView.isHidden = true
        
        alphabeticallyGroupedStations = CDStationInfo.searchStationInfosGroupedAlphabetically(context: context, contains: searchText)
    }
    
}

extension StationSearchViewController: UITextFieldDelegate {
    
}

extension StationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return alphabetSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = alphabetSectionTitles[section]
        return alphabeticallyGroupedStations[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = alphabetSectionTitles[indexPath.section]
        if let stationInfoItem = alphabeticallyGroupedStations[key]?[indexPath.row]{
            
            NotificationCenter.default.post(
                name: .didSelectStation,
                object: stationInfoItem,
                userInfo: ["fieldType": fieldType]
            )
            
            dissmissKeyboard()
            dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StationSearchViewCell.reuseIdentifier, for: indexPath) as! StationSearchViewCell

        let key = alphabetSectionTitles[indexPath.section]
        if let stationInfoItem = alphabeticallyGroupedStations[key]?[indexPath.row] {
            cell.configure(indexPath: indexPath, alphabet: key, stationName: stationInfoItem.stationName)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
}

extension StationSearchViewController {
    
    private func setupNavigationBar() {
        if let navController = navigationController as? NavigationController {
            let attributedText = NSAttributedStringBuilder()
                .add(text: "Vyhľadavanie", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize, weight: .bold)])
                .build()
            
            navController.setTitle(attributedText)
            navController.isTransitionEnabled = false
        }
    }
}
