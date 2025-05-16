//
//
//
// Created by: Patrik Drab on 16/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools

class StationSearchViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let searchTextField = UITextField()
    
    private var stations = ["New York", "London", "Paris", "Tokyo", "Berlin", "Rome"]
    private var filteredStations: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        let v = UIView(color: Colors.primary)
        v.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v)
        
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: view.topAnchor),
            v.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        setupSearchTextField()
    }
    
    private func setupSearchTextField() {
        searchTextField.placeholder = "Hľadať station"
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
        
        // Setup xmark view
        let xmarkView = UIView()
        let xmarkIcon = IconImageView(systemName: SFSymbols.xmark, config: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold, scale: .medium))
        
        xmarkView.setDimensions(width: 56, height: 56)
        xmarkView.addSubview(xmarkIcon)
        xmarkIcon.center()
        
        rightView.addSubview(xmarkView)
        xmarkView.leading(offset: .init(x: 5, y: 0))
        
        searchTextField.rightViewMode = .always
        searchTextField.rightView = rightView
        
        view.addSubview(searchTextField)
        
        // Setup layout
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 56)
        ])
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
        presentSearchController()
    }
    
    @objc private func handleToTap() {
        print("Handle to tap")
        presentSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func presentSearchController() {
        let searchController = StationSearchViewController()
        
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
