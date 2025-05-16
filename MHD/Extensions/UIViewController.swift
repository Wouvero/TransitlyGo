//
//
//
// Created by: Patrik Drab on 16/04/2025
// Copyright (c) 2025 MHD
//
//
import UIKit

extension UIViewController {
    func addDefaultBackButton(tintColor: UIColor = .white) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = tintColor
    }
    
    @objc func backButtonTapped() {
        print("<<")
        // Handle both navigation stack and modal presentation
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

