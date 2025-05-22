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


extension Notification.Name {
    static let didSelectStation = Notification.Name("didSelectStation")
}

struct NotificationKey {
    static let station: String = "Station"
    static let inputFieldType: String = "InputFieldType"
}

class SearchConectionViewController: UIViewController {
    
    private let fromInputLabel = UILabel(
        text: InputFieldType.from.rawValue,
        font: UIFont.systemFont(ofSize: 16, weight: .regular),
        textColor: .black,
        textAlignment: .left,
        numberOfLines: 0
    )
    
    private let toInputLabel = UILabel(
        text: InputFieldType.to.rawValue,
        font: UIFont.systemFont(ofSize: 16, weight: .regular),
        textColor: .black,
        textAlignment: .left,
        numberOfLines: 0
    )
    
    private let searchLabel = UILabel(
        text: "Vyhľadať",
        font: UIFont.systemFont(ofSize: 16, weight: .bold),
        textColor: .white,
        textAlignment: .center,
        numberOfLines: 1
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
    
    private let changeButton: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .black
        return view
    }()
    
    private let changeButtonIcon = IconImageView(
        systemName: SFSymbols.changePosition,config: UIImage.SymbolConfiguration(pointSize: tabBarIconSize, weight: .regular, scale: .default),
        tintColor: .white)
    
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
        setupObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setTabBarHidden(false)
    }
}

extension SearchConectionViewController {
    
    private func setupUI() {
        fromInputButton.setDimensions(height: 50)
        fromInputButton.addSubview(fromInputLabel)
        fromInputLabel.pinInSuperview(padding: .vertical(16))
        
        toInputButton.setDimensions(height: 50)
        toInputButton.addSubview(toInputLabel)
        toInputLabel.pinInSuperview(padding: .vertical(16))
        
        searchButton.setDimensions(height: 50)
        
        changeButton.setDimensions(width: 40, height: 40)
        changeButton.addSubview(changeButtonIcon)
        changeButtonIcon.center()
        
        let inputStackView = UIStackView(
            arrangedSubviews: [fromInputButton, toInputButton],
            spacing: 8
        )
        
        inputStackView.addSubview(changeButton)
        changeButton.trailing(offset: .init(x: -20, y: 0))
        
        
        
        searchButton.addSubview(searchLabel)
        searchLabel.center()
        
        let rootStackView = UIStackView(
            arrangedSubviews: [inputStackView, searchButton],
            spacing: 8
        )
        
        
        view.addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            rootStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            rootStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupGestures() {
        
        let fromTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFromTap))
        fromInputButton.addGestureRecognizer(fromTapGesture)
        
        let toTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleToTap))
        toInputButton.addGestureRecognizer(toTapGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleChangeButtonTap))
        changeButton.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    private func setupNavigationBar() {
        if let navController = navigationController as? NavigationController {
            let attributedText = NSAttributedStringBuilder()
                .add(text: "Vyhľadanie spojenia", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize, weight: .bold)])
                .build()
            
            navController.setTitle(attributedText)
        }
    }
}

extension SearchConectionViewController {
    
    @objc private func handleChangeButtonTap() {
        if fromInputLabel.text != InputFieldType.from.rawValue &&
            toInputLabel.text != InputFieldType.to.rawValue {
            let tempFromInputLabel = fromInputLabel.text
            let tempToInputLabel = toInputLabel.text
            
            fromInputLabel.text = tempToInputLabel
            toInputLabel.text = tempFromInputLabel
        }
        else if fromInputLabel.text != InputFieldType.from.rawValue &&
            toInputLabel.text == InputFieldType.to.rawValue {
            let tempFromInputLabel = fromInputLabel.text
            
            fromInputLabel.text = InputFieldType.from.rawValue
            toInputLabel.text = tempFromInputLabel
        }
        else if fromInputLabel.text == InputFieldType.from.rawValue &&
            toInputLabel.text != InputFieldType.to.rawValue {
            let tempToInputLabel = toInputLabel.text
            
            fromInputLabel.text = tempToInputLabel
            toInputLabel.text = InputFieldType.to.rawValue
        }
    }
    
    @objc private func handleFromTap() {
        presentSearchController(for: .from)
    }
    
    @objc private func handleToTap() {
        presentSearchController(for: .to)
    }
    
    private func presentSearchController(for fieldType: InputFieldType = .from) {
        let searchController = StationSearchViewController()
        searchController.fieldType = fieldType

        navigationController?.pushViewController(searchController, animated: false)
    }
    
}

extension SearchConectionViewController {
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSelectStation),
            name: .didSelectStation,
            object: nil
        )
    }
    
    @objc private func didSelectStation(_ notification: Notification) {
        if let stationInfo = notification.object as? CDStationInfo,
           let userInfo = notification.userInfo,
           let textFieldType = userInfo["fieldType"] as? InputFieldType {
            switch textFieldType {
            case .from:
                fromInputLabel.text = stationInfo.stationName
            case .to:
                toInputLabel.text = stationInfo.stationName
            }
        }
    }
    
}
