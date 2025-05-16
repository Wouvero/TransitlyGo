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
    // MARK: - Update State for default and selected state
    func updateSelectedItem(to newIndex: Int) {
        guard newIndex != selectedIndex else { return }
        
        // Update icon colors for old and new items
        updateTabAppearance(for: selectedIndex, isActive: false)
        updateTabAppearance(for: newIndex, isActive: true)
        
        selectedIndex = newIndex
    }
    
    func updateTabAppearance(for index: Int, isActive: Bool) {
        let buttonView = tabItemViews[index]
        let stackView = buttonView.subviews.compactMap { $0 as? UIStackView }.first
        let iconImageView = stackView?.arrangedSubviews[0] as? IconImageView
        
        
        
        iconImageView?.setTintColor(isActive ? activeColor : defaultColor)
        iconImageView?.setConfig(config: isActive ? UIImage.SymbolConfiguration(pointSize: tabBarIconSize, weight: .bold, scale: .medium) : UIImage.SymbolConfiguration(pointSize: tabBarIconSize, weight: .regular, scale: .medium))
    }
    
    func updateDefaultTabAppearance() {
        for (index, tabItemView) in tabItemViews.enumerated() {
            let stackView = tabItemView.subviews.compactMap { $0 as? UIStackView }.first
            let iconImageView = stackView?.arrangedSubviews[0] as? IconImageView
          
            if index != selectedIndex {
                iconImageView?.setTintColor(defaultColor)
                iconImageView?.setConfig(config: UIImage.SymbolConfiguration(pointSize: tabBarIconSize, weight: .regular, scale: .medium))
            }
        }
    }
    
    func updateActiveTabAppearance() {
        let activeTabItem = tabItemViews[selectedIndex]
        let stackView = activeTabItem.subviews.compactMap { $0 as? UIStackView }.first
        let iconImageView = stackView?.arrangedSubviews[0] as? IconImageView
        
        iconImageView?.setTintColor(activeColor)
        iconImageView?.setConfig(config: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .medium))
    }
}

