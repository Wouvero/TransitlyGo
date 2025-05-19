//
//
//
// Created by: Patrik Drab on 19/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

class MapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        if let navController = navigationController as? NavigationController {
            let attributedText = NSAttributedStringBuilder()
                .add(text: "Mapa všetkých zastávok", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize, weight: .bold)])
                .build()
            
            navController.setTitle(attributedText)
        }
    }
}

