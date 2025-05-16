//
//
//
// Created by: Patrik Drab on 16/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools

enum InputFieldType: String {
    case from = "Zo zastávky"
    case to = "Na zastávku"
}

class StationSearchViewController: UIViewController {
    
    private let searchTextField = UITextField()
    private let tableView = UITableView()
    
    private var stations = ["New York", "London", "Paris", "Tokyo", "Berlin", "Rome"]
    private var filteredStations: [String] = []
    
    var fieldType: InputFieldType = .from
    
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        
        

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

}

extension StationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "gg"
        return cell
    }
    
    
}

import SwiftUI

struct StationSearchViewController_previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            StationSearchViewController()
        }.ignoresSafeArea()
    }
}


class SearchBarViewController: UIViewController {
    
    private let fromInputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Začiatok"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let toInputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Koniec"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        setupGestures()
    }
    
    private func setupUI() {
        let inputStack = UIStackView(
            arrangedSubviews: [fromInputField, toInputField],
            spacing: 8
        )
        
        view.addSubview(inputStack)
        inputStack.setWidth(300)
        inputStack.center()
    }
    
    private func setupGestures() {
        let fromTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFromTap))
        fromInputField.addGestureRecognizer(fromTapGesture)
        
        let toTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleToTap))
        toInputField.addGestureRecognizer(toTapGesture)
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
        searchController.fieldType = fieldType
        searchController.modalPresentationStyle = .fullScreen
        
        present(searchController, animated: true)
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
