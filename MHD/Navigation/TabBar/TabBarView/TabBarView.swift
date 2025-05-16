//
//
//
// Created by: Patrik Drab on 09/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools

class TabBarView: UIView {
    
    let defaultColor: UIColor = Colors.secondary
    let activeColor: UIColor = .white
    let backgroundViewColor: UIColor = Colors.primary
    
    let tabBarViewHeight: CGFloat = 70
    
    var itemsDataSource: [TabBarItem] = []
    
    var backgroundView = UIView()
    var contentView = UIView()
    var tabItemViews: [UIView] = []
    var selectedIndex: Int = 0
    
    // MARK: - Delegates
    weak var delegate: TabBarDelegate?
    
    // MARK: - Initialization
    init(items: [TabBarItem]) {
        self.itemsDataSource = items
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let safeAreaBottomInsets = safeAreaInsets.bottom
        let bottomPadding = safeAreaBottomInsets - tabBarViewHeight
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: safeAreaBottomInsets),
            
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding),
        ])
    }
}
