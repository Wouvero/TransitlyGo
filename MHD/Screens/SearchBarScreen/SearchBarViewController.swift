//
//
//
// Created by: Patrik Drab on 16/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools
import CoreData

enum InputFieldType: String {
    case from = "Zo zastávky"
    case to = "Na zastávku"
}

class StationSearchViewCell: UITableViewCell {
    private var section: Int = 0
    private var row: Int = 0
    
    private let alphabetTitle = UILabel(
        text: "A",
        font: UIFont.systemFont(ofSize: 16, weight: .regular),
        textColor: .black,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private let alphabetTitleView = UIView()
    
    private let stationName = UILabel(
        text: "Title",
        font: UIFont.systemFont(ofSize: 16, weight: .bold),
        textColor: .black,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private let stationNameView = UIView()
    
    private let rootView = UIStackView(
        arrangedSubviews: [],
        axis: .horizontal,
        spacing: 0
    )
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        addSubviews(rootView)
        rootView.pinInSuperview()
        rootView.addBorder(for: [.bottom], in: .systemGray5, width: 1)
        
        
        alphabetTitleView.setDimensions(width: 50, height: 50)
        alphabetTitleView.addSubview(alphabetTitle)
        alphabetTitle.center()
        
        stationNameView.setDimensions(height: 50)
        stationNameView.addSubview(stationName)
        stationName.leading()
        
        rootView.addArrangedSubview(alphabetTitleView)
        rootView.addArrangedSubview(stationNameView)
        
        
        let customSelectionView = UIView()
        customSelectionView.backgroundColor = .systemGray6
        selectedBackgroundView = customSelectionView
    }
    
    func configure(indexPath: IndexPath, alphabet: String, stationName: String?) {
        section = indexPath.section
        row = indexPath.row
        
        alphabetTitle.text = alphabet
        alphabetTitle.isHidden = row != 0
        
        self.stationName.text = stationName
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        setupSafeAreaBackground()
        setupSearchTextField()
        setupTable()
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
        searchTextField.addBorder(for: [.bottom], in: .black, width: 1)
        
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
    
    @objc private func dissmissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    @objc private func dissmissViewController(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @objc private func searchTextFieldChanged(_ sender: UITextField) {
        guard let searchText = sender.text, !searchText.isEmpty else {
            alphabeticallyGroupedStations = [:]
            tableView.reloadData()
            return
        }
        
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

//import SwiftUI
//import CoreData
//
//struct StationSearchViewController_previews: PreviewProvider {
//    static var previews: some View {
//        ViewControllerPreview {
//            StationSearchViewController()
//        }.ignoresSafeArea()
//    }
//}


class SearchBarViewController: UIViewController, StationSearchDelegate {
    
    private let fromInputLabel = UILabel(
        text: "Začiatok",
        font: UIFont.systemFont(ofSize: 16, weight: .regular),
        textColor: .black,
        textAlignment: .left,
        numberOfLines: 0
    )
    private let toInputLabel = UILabel(
        text: "Koniec",
        font: UIFont.systemFont(ofSize: 16, weight: .regular),
        textColor: .black,
        textAlignment: .left,
        numberOfLines: 0
    )
    
    private let fromInputButton: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray3.cgColor
        return view
    }()
    
    private let toInputButton: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray3.cgColor
        return view
    }()
    
    private let searchButton: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.primary
        view.layer.cornerRadius = 8
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        setupGestures()
    }
    
    private func setupUI() {
        fromInputButton.setDimensions(height: 50)
        fromInputButton.addSubview(fromInputLabel)
        fromInputLabel.pinInSuperview(padding: .vertical(16))
        
        toInputButton.setDimensions(height: 50)
        toInputButton.addSubview(toInputLabel)
        toInputLabel.pinInSuperview(padding: .vertical(16))
        
        searchButton.setDimensions(height: 50)
        
        let s = UILabel(
            text: "Vyhľadať",
            font: UIFont.systemFont(ofSize: 16, weight: .bold),
            textColor: .white,
            textAlignment: .center,
            numberOfLines: 1
        )
        
        searchButton.addSubview(s)
        s.center()
        
        let inputStack = UIStackView(
            arrangedSubviews: [fromInputButton, toInputButton, searchButton],
            spacing: 8
        )
        
        
        view.addSubview(inputStack)
        
        NSLayoutConstraint.activate([
            inputStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupGestures() {
        let fromTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFromTap))
        fromInputButton.addGestureRecognizer(fromTapGesture)
        
        let toTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleToTap))
        toInputButton.addGestureRecognizer(toTapGesture)
    }
    
    @objc private func handleFromTap() {
        print("Handle from tap")
        presentSearchController(for: .from)
    }
    
    @objc private func handleToTap() {
        print("Handle to tap")
        presentSearchController(for: .to)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func presentSearchController(for fieldType: InputFieldType = .from) {
        let searchController = StationSearchViewController()
        searchController.delegate = self
        searchController.fieldType = fieldType
        searchController.modalPresentationStyle = .fullScreen
        
        present(searchController, animated: true)
    }
    
    func didSelectStation(_ station: CDStationInfo, for fieldType: InputFieldType) {
        switch fieldType {
        case .from:
            fromInputLabel.text = station.stationName
        case .to:
            toInputLabel.text = station.stationName
        }
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
