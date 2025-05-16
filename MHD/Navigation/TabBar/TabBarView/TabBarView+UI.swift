//
//
//
// Created by: Patrik Drab on 09/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools

extension TabBarView {
    // MARK: - UI
    func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.backgroundColor = backgroundViewColor
        contentView.backgroundColor = .clear
        
        addSubview(backgroundView)
        backgroundView.addSubview(contentView)
        
        guard !itemsDataSource.isEmpty else { return }
        
        let tabItemsCount = itemsDataSource.count
        let tabItemWidth = UIScreen.main.bounds.width / CGFloat(tabItemsCount)
        
        for (index, item) in itemsDataSource.enumerated() {
            let tabItem = UIView(padding: .equalSides(0))
            tabItem.clipsToBounds = true
            tabItem.frame = CGRect(
                x: tabItemWidth * CGFloat(index),
                y: 0,
                width: tabItemWidth,
                height: tabBarViewHeight
            )
            
            // Gesture (On tap)
            tabItem.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
            tabItem.addGestureRecognizer(tapGesture)
            
            // Icon Image
            let iconImageView = IconImageView(
                systemName: item.icon,
                config: index == selectedIndex
                ? UIImage.SymbolConfiguration(pointSize: tabBarIconSize, weight: .bold, scale: .medium)
                : UIImage.SymbolConfiguration(pointSize: tabBarIconSize, weight: .regular, scale: .medium),
                tintColor: index == selectedIndex ? activeColor : defaultColor
            )
            
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
     
            // StackView for Icon + Label
            let stackView = UIStackView(
                arrangedSubviews: [iconImageView],
                spacing: 6,
                alignment: .center, distribution: .fill
            )
            
            tabItem.addSubview(stackView)
            contentView.addSubview(tabItem)
            tabItemViews.append(tabItem)
            
            stackView.center()
        }
    }
    
}
