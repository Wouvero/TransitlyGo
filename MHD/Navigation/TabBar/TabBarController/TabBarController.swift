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


class TabBarController: UITabBarController, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
    private var tabBarHeight: CGFloat = 70
    private var tabBarView: TabBarView!
    private var tabBarItems: [TabBarItem] = []
    private var isTabBarContentHidden: Bool = false {
        didSet {
            tabBarHeight = isTabBarContentHidden ? 0 : 70
            tabBarView.isHidden = isTabBarContentHidden ? true : false
        }
    }
    
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
        setupTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSafeAreaInsets()
    }
    
}

// MARK: - TabBarDelegate
extension TabBarController: TabBarDelegate {
    
    func didTapItem(at index: Int) {
        selectedIndex = index
    }
}

extension TabBarController {
    
    private func setupTabBar() {
        self.delegate = self
        tabBar.isHidden = true
        view.backgroundColor = .systemBlue
        
        tabBarView = TabBarView(items: tabBarItems)
        tabBarView.delegate = self
        view.addSubview(tabBarView)
    }
    
    private func updateSafeAreaInsets() {
        let safeAreaBottom = view.safeAreaInsets.bottom
        let totalBottomInset = tabBarHeight + safeAreaBottom
        let additionalInset = max(0, totalBottomInset - safeAreaBottom)
        self.additionalSafeAreaInsets.bottom = additionalInset
        
        NSLayoutConstraint.activate([
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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

extension TabBarController {
    
    func setTabBarContentHidden(_ hidden: Bool) {
        isTabBarContentHidden = hidden
    }
}

extension UIViewController {
    var tabBarController: TabBarController? {
        var parentVC = self.parent
        while parentVC != nil {
            if let tabBarController = parentVC as? TabBarController {
                return tabBarController
            }
            parentVC = parentVC?.parent
        }
        return nil
    }
    
    func setTabBarHidden(_ hidden: Bool) {
        tabBarController?.setTabBarContentHidden(hidden)
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
