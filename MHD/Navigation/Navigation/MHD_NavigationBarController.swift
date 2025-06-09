//
//
//
// Created by: Patrik Drab on 29/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit


class MHD_NavigationBarController: UINavigationController {
    
    private let customNavBarBackground = UIView(color: .neutral)
    private let customNavBar = UIView()
    private let customNavBarContent = MHD_NavigationBarContent()
    
    private var customNavBarContentHeightConstraint: NSLayoutConstraint!
    private var isCustomNavBarHidden: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        delegate = self
        
        setupNavBarController()
        setupNavBar()
        setupNavBarContent()
        setupNavBarBorder()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateContentInset()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        updateBackButton()
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        updateBackButton()
        return vc
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let viewControllers = super.popToViewController(viewController, animated: animated)
        updateBackButton()
        return viewControllers
    }
    
    private func updateBackButton() {
        let hidden  = viewControllers.count <= 1 && presentingViewController == nil
        customNavBarContent.setBackButtonHidden(hidden)
    }
    
}

extension MHD_NavigationBarController {
    
    private func updateContentInset() {
        //print("updateContentInset")
        let safeAreaTop = view.safeAreaInsets.top
        let totalHeight = isCustomNavBarHidden ? safeAreaTop : (customNavBarContentHeightConstraint.constant) + safeAreaTop
        
        //print("total: \(totalHeight), safe: \(safeAreaTop), customNavBar height:  \(customNavBarContentHeightConstraint.constant)")
        additionalSafeAreaInsets.top = totalHeight - safeAreaTop
    }
    
    private func setupNavBarController() {
        customNavBarBackground.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(customNavBarBackground)
        
        NSLayoutConstraint.activate([
            customNavBarBackground.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBarBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupNavBar() {
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        
        customNavBarBackground.addSubview(customNavBar)
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: customNavBarBackground.topAnchor),
            customNavBar.bottomAnchor.constraint(equalTo: customNavBarBackground.bottomAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: customNavBarBackground.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: customNavBarBackground.trailingAnchor),
        ])
    }
    
    private func setupNavBarContent() {
        customNavBarContent.translatesAutoresizingMaskIntoConstraints = false
        customNavBarContent.onBackButtonTap = {
            [weak self] in
            self?.handleBackButtonTap()
        }
        customNavBar.addSubview(customNavBarContent)
        
        customNavBarContentHeightConstraint = customNavBarContent.heightAnchor.constraint(equalToConstant: 50)
        customNavBarContentHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            customNavBarContent.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor),
            customNavBarContent.trailingAnchor.constraint(equalTo: customNavBar.trailingAnchor),
            customNavBarContent.bottomAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            customNavBarContentHeightConstraint
        ])
    }
    
    private func setupNavBarBorder() {
        let border = UIView(color: .neutral30)
        border.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(border)
        
        NSLayoutConstraint.activate([
            border.heightAnchor.constraint(equalToConstant: 1),
            border.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            border.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

}

extension MHD_NavigationBarController {
    
    @objc private func handleBackButtonTap() {
        if viewControllers.count > 1 {
            _ = popViewController(animated: true)       // We're in navigation stack - pop
        } else if presentingViewController != nil {
            dismiss(animated: true)                     // We're presented modally - dismiss
        }
    }
    
}

extension MHD_NavigationBarController {

    func setNavBarHidden(to hide: Bool, animated: Bool = true) {
        if isCustomNavBarHidden == hide { return }
        isCustomNavBarHidden = hide
        
        let duration = animated ? 0.3 : 0
        let navBarHeight = customNavBar.frame.height
        let targetY = isCustomNavBarHidden ? view.frame.minY : view.frame.minY - navBarHeight
        
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.customNavBar.alpha = self.isCustomNavBarHidden ? 0 : 1
            self.customNavBar.frame.origin.y = targetY
            self.updateContentInset()
            self.view.layoutIfNeeded()
        }
    }
    
}


extension MHD_NavigationBarController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if let delegate = viewController as? MHD_NavigationDelegate {
            // 1. set atributed text into titleLabel
            customNavBarContent.setTitle(delegate.contentLabelText)
            
            // 2. set default navBarContnetheight into customNavBarContentHeightConstraint.constant
            customNavBarContentHeightConstraint.constant = delegate.navBarContentHeight
            
            // -> refresh layout
            customNavBarContent.setNeedsLayout()
            customNavBarContent.layoutIfNeeded() // this helps layout settle BEFORE measuring
            
            // 3. calculate current customNavBarContent height - it can be diffrent that default one (content inside takes more space)
            let computedCustomNavBarHeight = customNavBarContent.systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize
            ).height
            
            // 4. we pick max value (default height or computedCustomNavBarHeight if value is bigger then defaulf one)
            let finalHeight = max(computedCustomNavBarHeight, delegate.navBarContentHeight)
          
            // 5. we set final height
            customNavBarContentHeightConstraint.constant = finalHeight
            
            // ----------
            let shouldHideNavBar = delegate.shouldHideNavBar()
            setNavBarHidden(to: shouldHideNavBar, animated: false)
            // ----------
            let shouldHideTabBar = delegate.shouldHideTabBar()
            (tabBarController as? MHD_TabBarController)?.setTabBarHidden(to: shouldHideTabBar, animated: false)
            // ----------
            
            // 6. refresh layout and update content inset
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.updateContentInset()
        }
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return FadeInTransitionAnimator()
    }
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        return FadeInTransitionAnimator()
    }
    
}
