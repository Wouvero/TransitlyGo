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
        
        let v = UIView(color: .cyan)
        v.setDimensions(width: 50, height: 50)
        view.addSubview(v)
        v.center()
        v.asButton {
            self.view.window?.rootViewController?.dismiss(animated: false)
        }
        
        let a = UIView(color: .systemBlue)
        a.setDimensions(width: 50, height: 50)
        view.addSubview(a)
        a.trailing()
        a.asButton {
            self.dismiss(animated: false)
        }
        
        
        let b = UIView(color: .systemRed)
        b.setDimensions(width: 50, height: 50)
        view.addSubview(b)
        b.leading()
        b.asButton {
            
//            let userInfo: [AnyHashable: Any] = [
//                NotificationKey.inputFieldType: "from"
//            ]
//            
//            NotificationCenter.default.post(
//                name: .selectStation,
//                object: nil,
//                userInfo: userInfo
          //  )
            self.view.window?.rootViewController?.dismiss(animated: false)
        }
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

