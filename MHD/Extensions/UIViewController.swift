//
//
//
// Created by: Patrik Drab on 16/04/2025
// Copyright (c) 2025 MHD
//
//

import UIKit

extension UIViewController {
    func navigate(to viewController: UIViewController, animation: Bool = true) {
        guard let navBarController = self.navigationController as? MHD_NavigationBarController else { return }
        navBarController.pushViewController(viewController, animated: animation)
    }
    
    func pop(animated: Bool = true) {
        guard let navBarController = self.navigationController as? MHD_NavigationBarController else { return }
        _ = navBarController.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        guard let navBarController = self.navigationController as? MHD_NavigationBarController else { return }
        _ = navBarController.popToRootViewController(animated: animated)
    }
    
    
    func presentViewController(
        _ viewController: UIViewController,
        for modalPresentationStyle: UIModalPresentationStyle = .formSheet,
        animation: Bool = true
    ) {
        viewController.modalPresentationStyle = modalPresentationStyle
        present(viewController, animated: animation)
    }
    
    func callSetTabBarHiden(to hide: Bool, animated: Bool = false) {
        guard let tabBarController = self.tabBarController as? MHD_TabBarController else { return }
        tabBarController.setTabBarHidden(to: hide, animated: animated)
    }
    
    func callSetNavBarHidden(to hide: Bool, animated: Bool = false) {
        guard let navBarController = self.navigationController as? MHD_NavigationBarController else { return }
        navBarController.setNavBarHidden(to: hide, animated: animated)
    }
}

extension UIViewController {
    func previousViewController<T: UIViewController>(ofType type: T.Type) -> T? {
        guard let navController = self.navigationController else { return nil }

        let viewControllers = navController.viewControllers
        
        guard viewControllers.count >= 2 else { return nil}
        
        guard let previousController = viewControllers[viewControllers.count - 2] as? T else { return nil }
        
        return previousController
    }
    
    var previousViewController: UIViewController? {
        guard let navController = self.navigationController else { return nil }

        let viewControllers = navController.viewControllers
        
        guard viewControllers.count >= 2 else { return nil}
    
        return viewControllers[viewControllers.count - 2]
    }
}

