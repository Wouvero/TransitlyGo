//
//
//
// Created by: Patrik Drab on 16/04/2025
// Copyright (c) 2025 MHD
//
//
import UIKit

//extension UIViewController {
//    func addDefaultBackButton(tintColor: UIColor = .white) {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "chevron.left"),
//            style: .plain,
//            target: self,
//            action: #selector(backButtonTapped)
//        )
//        navigationItem.leftBarButtonItem?.tintColor = tintColor
//    }
//    
//    @objc func backButtonTapped() {
//        print("<<")
//        // Handle both navigation stack and modal presentation
//        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
//            navigationController.popViewController(animated: true)
//        } else {
//            dismiss(animated: true)
//        }
//    }
//}



extension UIViewController {
    func navigate(to viewController: UIViewController, animation: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animation)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
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

