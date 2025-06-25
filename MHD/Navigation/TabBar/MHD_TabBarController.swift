//
//
//
// Created by: Patrik Drab on 29/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit



class MHD_TabBarController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate, MHD_TabBarDelegate {
    
    // MARK: - Properties
    private let tabBarItems = TabBarItem.tabBarItems
    
    private let tabBarContentHeight: CGFloat = 72
    
    private let customTabBarBackground = UIView(color: .neutral)
    
    private let customTabBar = UIView()
    private var customTabBarContent: MHD_TabBarContent!
    private var isCustomTabBarHidden = false
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        self.delegate = self
        setupViewControllers()
        
        setupTabBarBackground()
        setupTabBar()
        setupTabBarContent()
        setupTabBarBorder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateContentInset()
    }
    
}


extension MHD_TabBarController {
    
    private func setupTabBarBackground() {
        customTabBarBackground.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(customTabBarBackground)
        
        NSLayoutConstraint.activate([
            customTabBarBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBarBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTabBar() {
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        customTabBarBackground.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            customTabBar.bottomAnchor.constraint(equalTo: customTabBarBackground.bottomAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: customTabBarBackground.trailingAnchor),
            customTabBar.leadingAnchor.constraint(equalTo: customTabBarBackground.leadingAnchor),
            customTabBar.topAnchor.constraint(equalTo: customTabBarBackground.topAnchor)
        ])
    }
    
    private func setupTabBarContent() {
        customTabBarContent = MHD_TabBarContent(items: tabBarItems)
        customTabBarContent.delegate = self
        customTabBarContent.translatesAutoresizingMaskIntoConstraints = false
        
        customTabBar.addSubview(customTabBarContent)
        
        NSLayoutConstraint.activate([
            customTabBarContent.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor),
            customTabBarContent.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor),
            customTabBarContent.topAnchor.constraint(equalTo: customTabBar.topAnchor),
            customTabBarContent.heightAnchor.constraint(equalToConstant: tabBarContentHeight)
        ])
    }
    
    private func setupViewControllers() {
        let viewControllers = tabBarItems.enumerated().map { (index, item) in
            let navController = MHD_NavigationBarController(rootViewController: item.viewControllerProvider())
            navController.tabBarItem = UITabBarItem(
                title: item.title,
                image: UIImage(systemName: item.icon),
                tag: index
            )
            return navController
        }
        self.viewControllers = viewControllers
    }
    
    private func updateContentInset() {
        let safeAreaBottom = view.safeAreaInsets.bottom
        let totalHeight = isCustomTabBarHidden ? safeAreaBottom : tabBarContentHeight + safeAreaBottom
        additionalSafeAreaInsets.bottom = totalHeight - safeAreaBottom
    }
    
    private func setupTabBarBorder() {
        let border = UIView(color: .neutral30)
        border.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(border)
        
        NSLayoutConstraint.activate([
            border.heightAnchor.constraint(equalToConstant: 1),
            border.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            border.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}


extension MHD_TabBarController {
    
    func setTabBarHidden(to hide: Bool = true, animated: Bool = true) {
        if isCustomTabBarHidden == hide { return }
        isCustomTabBarHidden = hide
        
        let duration = animated ? 0.3 : 0
        let tabBarHeight = customTabBar.frame.height
        
        let targetY = isCustomTabBarHidden ? view.frame.maxY : view.frame.maxY - tabBarHeight
 
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.customTabBar.frame.origin.y = targetY
            self.customTabBar.alpha = self.isCustomTabBarHidden ? 0 : 1
            self.updateContentInset()
            self.view.layoutIfNeeded()
        }
    }
    
}

extension MHD_TabBarController {
    
    func didTapItem(at index: Int) {
        selectedIndex = index
    }
    
}

extension MHD_TabBarController {
    // Implement the delegate method for custom transitions
    func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return FadeInTransitionAnimator()
    }
}

