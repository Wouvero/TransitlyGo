//
//
//
// Created by: Patrik Drab on 16/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

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


class RouteSelectionViewController: UIViewController, MHD_NavigationDelegate {
    // MARK: - Navigation variables
    var contentLabelText: NSAttributedString {
        return NSAttributedStringBuilder()
            .add(text: "Vyhľadanie spojenia", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    // MARK: - Variables
    private let fromInputLabel = UILabel(
        text: InputFieldType.from.rawValue,
        font: UIFont.interMedium(size: 16),
        textColor: .neutral800,
        textAlignment: .left,
        numberOfLines: 0
    )
    
    private let toInputLabel = UILabel(
        text: InputFieldType.to.rawValue,
        font: UIFont.interMedium(size: 16),
        textColor: .neutral800,
        textAlignment: .left,
        numberOfLines: 0
    )
    
    private let fromInputButton: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.neutral200.cgColor
        return view
    }()
    
    private let toInputButton: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.neutral200.cgColor
        return view
    }()
    
    private let changeButton = CustomButton(
        type: .iconOnly(
            iconName: SFSymbols.changePosition,
            iconColor: .neutral,
            iconSize: 24
        ),
        style: .filled(
            backgroundColor: .neutral800,
            cornerRadius: 8
        ),
        size: .custom(width: 44, height: 44)
    )
    
    private let searchButton = CustomButton(
        type: .textOnly(
            label: "Vyhľadať",
            textColor: .neutral
        ),
        style: .filled(
            backgroundColor: .primary500,
            cornerRadius: 8
        ),
        size: .auto(pTop: 16, pTrailing: 16, pBottom: 16, pLeading: 16)
    )
    
    private let expandButton = CustomButton(
        type: .textOnly(
            label: "Viac",
            textColor: .neutral800
        ),
        style: .plain(cornerRadius: 8),
        size: .auto(pTop: 16, pTrailing: 16, pBottom: 16, pLeading: 16)
    )
    
    private var expandButtonState: Bool = false {
        didSet {
            expandContentView.isHidden = !expandButtonState
            expandButton.setButtonLabelText(expandButtonState ? "Menej" : "Viac")
            if expandButtonState == false {
                view.endEditing(true)
            }
        }
    }
    
    private let expandContentView = UIStackView(
        axis: .vertical,
        spacing: 8
    )
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10

        setupFromInputView()
        setupToIntoView()
        setupSearchButton()
        setupChangeButton()
        setupExpandButton()
        setupContent()

        setupObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(false)
    }
}


// MARK: - Setup UI
extension RouteSelectionViewController {
    
    private func setupFromInputView() {
        fromInputButton.setDimensions(height: 50)
        fromInputButton.addSubview(fromInputLabel)
        fromInputLabel.pinInSuperview(padding: .vertical(16))
        fromInputButton.onTapGesture { [weak self] in
            guard let self = self else { return }
            self.handleFromTap()
        }
    }
    
    private func setupToIntoView() {
        toInputButton.setDimensions(height: 50)
        toInputButton.addSubview(toInputLabel)
        toInputLabel.pinInSuperview(padding: .vertical(16))
        toInputButton.onTapGesture {[weak self] in
            guard let self = self else { return }
            self.handleToTap()
        }
    }
    
    private func setupSearchButton() {
        searchButton.onRelease = { [weak self] in
            guard let self = self else { return }
            self.search()
        }
    }
    
    private func setupChangeButton() {
        changeButton.onTapGesture { [weak self] in
            guard let self = self else { return }
            self.handleChangeButtonTap()
        }
    }
    
    private func setupExpandButton() {
        expandButton.onTapGesture { [weak self] in
            guard let self = self else { return }
            self.expandButtonState.toggle()
        }
    }
    
    private func setupContent() {
        
        // Setup search inputs stack
        let searchInputsStack = UIStackView(
            arrangedSubviews: [
                fromInputButton,
                toInputButton
            ],
            spacing: 8
        )
        
        searchInputsStack.addSubview(changeButton)
        changeButton.trailing(offset: .init(x: -20, y: 0))
        
       
        // Setup expand contet stack
        // Setup time and day stack
        let hourView = CustomTimeTextField()
        hourView.setDimensions(width: 60, height: 50)
        hourView.setupPlaceholder("Hod.") 
        
        let minuteView = CustomTimeTextField()
        minuteView.setDimensions(width: 60, height: 50)
        minuteView.setupPlaceholder("Min.")
        
        
        
        let dayView = UIView()
        dayView.setDimensions(width: 150, height: 50)
        dayView.layer.cornerRadius = 8
        dayView.layer.borderWidth = 1
        dayView.layer.borderColor = UIColor.neutral200.cgColor
        
        let doubleDotLabel = UILabel(
            text: ":",
            font: UIFont.interRegular(size: 16),
            textColor: .neutral800,
            textAlignment: .center,
            numberOfLines: 1
        )
        
        let timeStackView = UIStackView(
            arrangedSubviews: [
                hourView,
                doubleDotLabel,
                minuteView,
                UIView()
            ],
            axis: .horizontal,
            spacing: 4,
            alignment: .center,
            distribution: .fill
            
        )
    
        expandContentView.addArrangedSubview(timeStackView)
        expandContentView.isHidden = true
        
        // Setup root stack
        let rootStackView = UIStackView(
            arrangedSubviews: [
                searchInputsStack,
                expandContentView,
                searchButton,
                expandButton
            ],
            spacing: 8
        )
        rootStackView.setCustomSpacing(16, after: searchInputsStack)
        rootStackView.setCustomSpacing(16, after: expandContentView)
        
        view.addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            rootStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            rootStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            rootStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension RouteSelectionViewController {
    
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
    
    private func search() {}
    
    private func presentSearchController(for fieldType: InputFieldType = .from) {
        let searchController = DestinationSearchViewController()
        searchController.fieldType = fieldType

        navigationController?.pushViewController(searchController, animated: false)
    }
    
}

extension RouteSelectionViewController {
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSelectStation),
            name: .didSelectStation,
            object: nil
        )
    }
    
    @objc private func didSelectStation(_ notification: Notification) {
        if let stationInfo = notification.object as? MHD_StationInfo,
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
