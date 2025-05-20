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

protocol StationSearchDelegate: AnyObject {
    func didSelectStation(_ station: CDStationInfo, for fieldType: InputFieldType)
}

class StationSearchViewController: UIViewController {
    
    weak var delegate: StationSearchDelegate?
    
    private let searchTextField = UITextField()
    private let tableView = UITableView()
    
    private var alphabeticallyGroupedStations: [String: [CDStationInfo]] = [:] {
        didSet {
            alphabetSectionTitles = alphabeticallyGroupedStations.keys.sorted()
            tableView.reloadData()
        }
    }
    private var alphabetSectionTitles: [String] = []
    
    var fieldType: InputFieldType = .from
    
    private var context: NSManagedObjectContext {
        return CoreDataManager.shared.viewContext
    }
    
    private let optionsView = UIView(color: .systemBackground)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupSafeAreaBackground()
        setupSearchTextField()
        setupTable()
        setupOptionsView()
    }

    private func setupSafeAreaBackground() {
        let safeAreaBackground = UIView(color: Colors.primary)
        safeAreaBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safeAreaBackground)
        
        NSLayoutConstraint.activate([
            safeAreaBackground.topAnchor.constraint(equalTo: view.topAnchor),
            safeAreaBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupSearchTextField() {
        searchTextField.placeholder = fieldType.rawValue
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.backgroundColor = .white
        searchTextField.addBorder(for: [.bottom], in: .systemGray3, width: 1)
        
        // Add text field delegate
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextFieldChanged), for: .editingChanged)
        
        // Setup left view
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 56))
        searchTextField.leftViewMode = .always
        searchTextField.leftView = leftView
        
        // Setup right view
        let rightView = UIView()
        rightView.setDimensions(width: 60, height: 56)
        
        // -> Setup xmark view
        let xmarkView = UIView()
        xmarkView.setDimensions(width: 56, height: 56)
        xmarkView.isUserInteractionEnabled = true
        // -> Setup xmark view tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmissViewController(_:)))
        xmarkView.addGestureRecognizer(tapGesture)
        
        let xmarkIcon = IconImageView(systemName: SFSymbols.xmark, config: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold, scale: .medium))
        xmarkView.addSubview(xmarkIcon)
        xmarkIcon.center()
        
        rightView.addSubview(xmarkView)
        xmarkView.leading(offset: .init(x: 5, y: 0))
        
        searchTextField.rightViewMode = .always
        searchTextField.rightView = rightView
        
        // Setup toolbar
        setupToolBar()
        
        // Setup layout
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        // Activate the text field and show keyboard
        searchTextField.becomeFirstResponder()
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
    
    private func setupOptionsView() {
        
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
        
        let tapGestureRecohnizer = UITapGestureRecognizer(target: self, action: #selector(pushToMapController))
        let tapGestureRecohnizer_1 = UITapGestureRecognizer(target: self, action: #selector(pushToStationController))
        optionStack_3.addGestureRecognizer(tapGestureRecohnizer)
        optionStack_1.addGestureRecognizer(tapGestureRecohnizer_1)
        
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
    
    @objc private func pushToStationController(_ sender: UITapGestureRecognizer) {
        let mapController = StationsListViewController()
        mapController.modalPresentationStyle = .fullScreen
        present(mapController, animated: false, completion: nil)
    }
    
    @objc private func pushToMapController(_ sender: UITapGestureRecognizer) {
        let mapController = MapViewController()
        mapController.modalPresentationStyle = .fullScreen
        present(mapController, animated: false, completion: nil)
    }
    
    @objc private func dissmissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    @objc private func dissmissViewController(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false)
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
        print("did select")
        let key = alphabetSectionTitles[indexPath.section]
        if let stationInfoItem = alphabeticallyGroupedStations[key]?[indexPath.row]{
            delegate?.didSelectStation(stationInfoItem, for: fieldType)
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
