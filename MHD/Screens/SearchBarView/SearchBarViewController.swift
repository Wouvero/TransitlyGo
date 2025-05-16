//
//
//
// Created by: Patrik Drab on 16/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools


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
    }
    
    @objc private func handleToTap() {
        print("Handle to tap")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
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
