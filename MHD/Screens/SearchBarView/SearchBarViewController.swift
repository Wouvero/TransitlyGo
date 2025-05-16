//
//
//
// Created by: Patrik Drab on 16/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools


class SearchBarViewController: UIViewController {
    
    
    
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
                .add(text: "Vyhľadanie spojenia", attributes: [.font: UIFont.systemFont(ofSize: navigationBarTitleSize)])
                .build()
            
            navController.setTitle(attributedText)
        }
    }
}
