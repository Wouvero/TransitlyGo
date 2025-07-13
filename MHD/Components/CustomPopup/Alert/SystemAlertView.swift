//
//
//
// Created by: Patrik Drab on 12/07/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit


class SystemAlertView: CustomPopupView {
    
    // MARK: - Nested Types
    enum ButtonConfiguration {
        case primaryOnly
        case secondaryOnly
        case both
    }
    
    // MARK: - UI Components
    let alertContent = UIStackView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let buttonsContent = UIStackView()
    
    let affirmativeButton = CustomButton(
        type: .textOnly(label: "OK", textColor: .white),
        style: .filled(backgroundColor: .success700, cornerRadius: 8)
    )
    
    let dismissiveButton = CustomButton(
        type: .textOnly(label: "Zatvoriť", textColor: .black),
        style: .filledWithOutline(borderColor: .black, borderWidth: 1, backgroundColor: .clear, cornerRadius: 8)
    )
    
    // MARK: - Properties
    var titleText: String? = "Alert title" {
        didSet {
            guard oldValue != titleText else { return }
            titleLabel.text = titleText
        }
    }
    var messageText: String? = "Alert message" {
        didSet {
            guard oldValue != messageText else { return }
            messageLabel.text = messageText
        }
    }
    
    var buttonConfig: ButtonConfiguration = .both {
        didSet {
            updateButtonVisibility()
        }
    }
    
    var affirmativeAction: (() -> Void)?
    var dismissiveAction: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        dismissOnTapOutside = false
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        configureTitleLabel()
        configureMessageLabel()
        configureAlertContent()
        configureButtonsContent()
        setupHierarchy()
    }
    
    private func configureAlertContent() {
        alertContent.axis = .vertical
        alertContent.spacing = 16
        alertContent.backgroundColor = .white
        alertContent.isLayoutMarginsRelativeArrangement = true
        alertContent.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        
        addContentView(alertContent)
    }
    
    internal func setupHierarchy() {
        alertContent.addArrangedSubview(titleLabel)
        alertContent.addArrangedSubview(messageLabel)
        alertContent.addArrangedSubview(buttonsContent)
    }
    
    private func configureTitleLabel() {
        titleLabel.text = titleText
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.interSemibold(size: 16)
        titleLabel.textAlignment = .center
    }
    
    private func configureMessageLabel() {
        messageLabel.text = messageText
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.interRegular(size: 16)
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
    }
    
    private func configureButtonsContent() {
        buttonsContent.axis = .horizontal
        buttonsContent.distribution = .fillEqually
        buttonsContent.spacing = 16
        
        setupButtonActions()
        updateButtonVisibility()
    }
    
    private func setupButtonActions() {
        affirmativeButton.onRelease = { [weak self] in
            self?.affirmativeAction?()
        }
        
        dismissiveButton.onRelease = { [weak self] in
            self?.dismissiveAction?()
        }
    }
    
    // MARK: - Update Methods
    private func updateButtonVisibility() {
        buttonsContent.arrangedSubviews.forEach {
            buttonsContent.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        switch buttonConfig {
        case .primaryOnly:
            buttonsContent.addArrangedSubview(affirmativeButton)
        case .secondaryOnly:
            buttonsContent.addArrangedSubview(dismissiveButton)
        case .both:
            buttonsContent.addArrangedSubview(affirmativeButton)
            buttonsContent.addArrangedSubview(dismissiveButton)
        }
    }
}
