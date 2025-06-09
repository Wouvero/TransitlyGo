//
//
//
// Created by: Patrik Drab on 29/05/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import UIKitPro

class MHD_TabBarContent: UIView {
    private var itemsDataSource: [TabBarItem] = []
    
    private let tabBarContentHeight: CGFloat = 72
    private let defaultColor: UIColor = .neutral600
    private let activeColor: UIColor = .neutral
    
    private let contentView = UIView()
    private var tabItemViews: [UIView] = []
    private var selectedIndex: Int = 0
    
    weak var delegate: MHD_TabBarDelegate?
    
    init(items: [TabBarItem]) {
        self.itemsDataSource = items
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        setupTabBarContent()
    }
    
    private func setupTabBarContent() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        guard !itemsDataSource.isEmpty else { return }
        
        let tabItemsCount = itemsDataSource.count
        let tabBarContentWidth = UIScreen.main.bounds.width - 2 * horizontalPadding
        let tabItemWidth = tabBarContentWidth / CGFloat(tabItemsCount)
        
        
        //print(tabBarContentWidth, tabBarContentHeight, tabItemWidth)
        for (index, item) in itemsDataSource.enumerated() {
            let isActiveTab = index == selectedIndex
            let tabItem = UIView()
            tabItem.clipsToBounds = true
            tabItem.frame = CGRect(
                x: tabItemWidth * CGFloat(index),
                y: 0,
                width: tabItemWidth,
                height: tabBarContentHeight
            )
            
            // Gesture (On tap)
            tabItem.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
            tabItem.addGestureRecognizer(tapGesture)
            
            
            // Icon Image
            let iconImageView = IconImageView(
                systemName: item.icon,
                color: isActiveTab ? activeColor : defaultColor,
                pointSize: tabBarIconSize,
                weight: isActiveTab ? .medium : .regular,
                scale: .medium
            )

            let iconView = UIView(color: isActiveTab ? .primary500 : .clear)
            
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.layer.cornerRadius = 8
            
            NSLayoutConstraint.activate([
                iconView.widthAnchor.constraint(equalToConstant: 40),
                iconView.heightAnchor.constraint(equalToConstant: 40),
            ])
            
            iconView.addSubview(iconImageView)
            iconImageView.center()
            
            let tabItemStack = UIStackView(
                arrangedSubviews: [iconView],
                spacing: 6,
                alignment: .center, distribution: .fill
            )
            
            tabItemStack.translatesAutoresizingMaskIntoConstraints = false
            
            tabItem.addSubview(tabItemStack)
            
            NSLayoutConstraint.activate([
                tabItemStack.centerXAnchor.constraint(equalTo: tabItem.centerXAnchor),
                tabItemStack.centerYAnchor.constraint(equalTo: tabItem.centerYAnchor),
            ])
            
            contentView.addSubview(tabItem)
            tabItemViews.append(tabItem)
        }
    }
}


extension MHD_TabBarContent {
    // MARK: - Actions
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        updateSelectedItem(to: view.tag)
        delegate?.didTapItem(at: view.tag)
    }
}

extension MHD_TabBarContent {
    // MARK: - Update State for default and selected state
    func updateSelectedItem(to newIndex: Int) {
        guard newIndex != selectedIndex else { return }
        selectedIndex = newIndex
        // Update icon colors for old and new items
        updateTabBarsAppearance()
    }
    
    func updateTabBarsAppearance() {
        for (index, tabItemView) in tabItemViews.enumerated() {
            guard
                let stackView = tabItemView.subviews.first(where: { $0 is UIStackView }) as? UIStackView,
                let iconView = stackView.arrangedSubviews.first,
                let iconImageView = iconView.subviews.first(where: { $0 is IconImageView }) as? IconImageView
            else {
                continue
            }
            
            let isActiveTab = selectedIndex == index
            iconView.backgroundColor = isActiveTab ? .primary500 : .clear
            
            iconImageView.setConfig(pointSize: tabBarIconSize, weight: isActiveTab ? .medium : .regular, scale: .medium)
            iconImageView.setColor(isActiveTab ? activeColor : defaultColor)
        }
    }
}


