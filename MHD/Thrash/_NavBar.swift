//
//
//
// Created by: Patrik Drab on 25/04/2025
// Copyright (c) 2025 MHD
//
//

import UIKit


class CustomNavBar: UIView {
    private let titleLabel = UILabel(
        text: "This is title",
        font: UIFont.systemFont(ofSize: 18, weight: .semibold),
        textColor: .white,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private let backButtonIcon = IconImageView(
        systemName: "chevron.left",
        tintColor: .white
    )
    
    private let backButton = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.setHeight(44)
        
        // Title Label
        addSubview(titleLabel)
        titleLabel.center()
        
        // Backbutton
        addSubview(backButton)
        backButton.setDimensions(width: 24, height: 24)
        // Backbutton icon
        backButton.addSubview(backButtonIcon)
        backButtonIcon.center()
        
        backButton.leading(offset: .init(x: 16, y: 0))
        
        // Add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
    }
    
    func configure(title: String, rightButtonTitle: String? = nil) {
        titleLabel.text = title
    }
}

class ControllerViewTest: UIViewController {
    
    private let customNavBar = CustomNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let a = UIView(color: .systemBlue)
        //view.addSubview(a)
        //a.pinToSuperviewSafeAreaLayoutGuide()
        
        setupCustomNavigation()
    }
    
    private func setupCustomNavigation() {
        let v = UIView(color: Colors.primary)
        v.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v)
        
        view.addSubview(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            customNavBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 44),
            
            v.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            v.topAnchor.constraint(equalTo: view.topAnchor),
            v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        let currentTopInset = view.safeAreaInsets.bottom
        let totalBottomInset = 44 + currentTopInset
        let additionalInset = max(0, totalBottomInset - currentTopInset)
        self.additionalSafeAreaInsets.top = additionalInset
    }
}

import UIKitTools
import SwiftUI

struct NavBarController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            ControllerViewTest()
        }
        .ignoresSafeArea()
    }
}
