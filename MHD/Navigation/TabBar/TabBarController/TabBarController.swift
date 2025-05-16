//
//
//
// Created by: Patrik Drab on 09/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit


protocol TabBarDelegate: AnyObject {
    func didTapItem(at index: Int)
}


class TabBarController: UITabBarController, UINavigationControllerDelegate, TabBarDelegate, UITabBarControllerDelegate {
    
    private let tabBarHeight: CGFloat = 70
    private var tabBarView: TabBarView!
    private var tabBarItems: [TabBarItem] = []
    
    init(tabBatItems: [TabBarItem]) {
        self.tabBarItems = tabBatItems
        super.init(nibName: nil, bundle: nil)
        setupViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.isHidden = true
        view.backgroundColor = .systemBlue
        
        tabBarView = TabBarView(items: tabBarItems)
        tabBarView.delegate = self
        view.addSubview(tabBarView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let currentBottomInset = view.safeAreaInsets.bottom
        let totalBottomInset = tabBarHeight + currentBottomInset
        let additionalInset = max(0, totalBottomInset - currentBottomInset)
        self.additionalSafeAreaInsets.bottom = additionalInset
        
        NSLayoutConstraint.activate([
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func didTapItem(at index: Int) {
        selectedIndex = index
    }
    
    private func setupViewControllers() {
        // Extract the view controllers from tabBarItems
        let controllers = tabBarItems.map { item -> NavigationController in
            let navController = NavigationController(rootViewController: item.viewController)
            navController.tabBarItem = UITabBarItem(title: item.title, image: UIImage(systemName: item.icon), tag: 0)
            navController.delegate = self
            return navController
        }
        
        // Assign to the viewControllers property
        self.viewControllers = controllers
    }
}


import UIKitTools
import SwiftUI

struct TabBarController_Preview: PreviewProvider {
    static var previews: some View {
        
        ViewControllerPreview {
            TabBarController(tabBatItems: [])
        }.ignoresSafeArea()
    }
}
