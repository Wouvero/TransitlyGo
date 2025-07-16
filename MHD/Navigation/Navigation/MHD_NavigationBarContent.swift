//
//
//
// Created by: Patrik Drab on 29/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit


class MHD_NavigationBarContent: UIView {
    private let contentStack = UIStackView(
        arrangedSubviews: [],
        axis: .horizontal,
        spacing: 4,
        alignment: .center,
        distribution: .fill
    )
    
    private let backButtonView = UIView()
    private let titleView = UIView()
    private let actionButtonView = UIView()
    
    private let titleLabel = UILabel(text: "Hello", font: UIFont.interSemibold(size: 16), textColor: .neutral800, textAlignment: .center, numberOfLines: 0)
    
    private var backButton = CustomButton(
        type: .iconOnly(iconName: SFSymbols.arrow_left_line, iconColor: .neutral800, iconSize: 24),
        style: .plain(cornerRadius: 0),
        size: .custom(width: 44, height: 44)
    )
    
    var onBackButtonTap: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        setupStack()
        setupBackButton()
        setupTitle()
        setupActionButton()
    }
    
    
    private func setupStack() {
        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding)
        ])
    }
    
    private func setupBackButton() {
        backButtonView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(backButtonView)
        
        NSLayoutConstraint.activate([
            backButtonView.widthAnchor.constraint(equalToConstant: 44),
            backButtonView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        backButtonView.addSubview(backButton)
        backButton.center()
        
        backButton.onRelease = { [weak self] in
            self?.onBackButtonTap?()
        }
    }
    
    private func setupTitle() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(titleView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupActionButton() {
        actionButtonView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(actionButtonView)
        
        NSLayoutConstraint.activate([
            actionButtonView.widthAnchor.constraint(equalToConstant: 44),
            actionButtonView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: - Public API
extension MHD_NavigationBarContent {
    
    func setTitle(_ text: NSAttributedString) {
        titleLabel.attributedText = text
    }
    
    func setBackButtonHidden(_ hidden: Bool) {
        backButton.isHidden = hidden
    }

}

