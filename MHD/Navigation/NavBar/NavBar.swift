//
//
//
// Created by: Patrik Drab on 26/04/2025
// Copyright (c) 2025 MHD
//
//

import UIKit

extension UIView {
    public func pinInTopSafeArea() {
        guard let superview = superview else { return }
        
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
}


class NavigationController: UINavigationController {
    let customNavigationBar = UIView(color: Colors.primary)
    let navigationContent = UIView()
    let navigationContentHeight: CGFloat = 44
    
    let titleLabel = UILabel(
        font: UIFont.systemFont(ofSize: navigationBarTitleSize, weight: .semibold),
        textColor: .white,
        textAlignment: .center,
        numberOfLines: 0
    )
    
    
    private let backButton = UIButton(type: .system)
    private let backButtonIcon = IconImageView(
        systemName: "chevron.left",
        tintColor: .white
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        setupNavigationBar()
        setupBackButton()
    }
    
    private func setupNavigationBar() {
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationContent.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(customNavigationBar)
        customNavigationBar.addSubview(navigationContent)
        navigationContent.addSubview(titleLabel)
        
        titleLabel.sizeToFit()
        
        
        customNavigationBar.pinInTopSafeArea()
        
        NSLayoutConstraint.activate([
//            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
//            customNavigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            navigationContent.leadingAnchor.constraint(equalTo: customNavigationBar.leadingAnchor),
            navigationContent.trailingAnchor.constraint(equalTo: customNavigationBar.trailingAnchor),
            navigationContent.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            navigationContent.heightAnchor.constraint(equalToConstant: navigationContentHeight),
//            
//            titleLabel.centerXAnchor.constraint(equalTo: navigationContent.centerXAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: navigationContent.centerYAnchor)
        ])
        
        titleLabel.center()
       
        // Add shadow
        customNavigationBar.layer.shadowColor = UIColor.black.cgColor
        customNavigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        customNavigationBar.layer.shadowRadius = 4
        customNavigationBar.layer.shadowOpacity = 0.1
    }
    
    private func setupBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButtonIcon.translatesAutoresizingMaskIntoConstraints = false
        // Back button
        navigationContent.addSubview(backButton)
        backButton.addSubview(backButtonIcon)
        
        backButton.setDimensions(width: 44, height: 44)
        backButton.leading(offset: .init(x: 16, y: 0))
        backButtonIcon.center()
        //backButton.setBackground(.black)
        
        backButton.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(buttonHighlight), for: [.touchDown, .touchDragEnter])
        backButton.addTarget(self, action: #selector(buttonUnhighlight), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        backButton.accessibilityLabel = "Back"
        backButton.accessibilityTraits = .button
    }
    
    private func updateSafeAreaInsets() {
        let currentTopInset = view.safeAreaInsets.bottom
        let totalTopInset = navigationContentHeight + currentTopInset
        let additionalInset = max(0, totalTopInset - currentTopInset)
        self.additionalSafeAreaInsets.top = additionalInset
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.setWidth(view.frame.width * 0.75)
        updateSafeAreaInsets()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.view.setNeedsLayout()
        })
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        updateBackButtonVisibility()
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        updateBackButtonVisibility()
        return vc
    }
    
    
    
    /// Set title
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setTitle(_ attributedText: NSAttributedString) {
        titleLabel.attributedText = attributedText
    }
    
    private func updateBackButtonVisibility() {
        backButton.isHidden = viewControllers.count <= 1 && presentingViewController == nil
    }
    
    @objc private func handleBackAction() {
        if viewControllers.count > 1 {
            // We're in navigation stack - pop
            _ = popViewController(animated: true)
        } else if presentingViewController != nil {
            // We're presented modally - dismiss
            dismiss(animated: true)
        }
    }
    
    @objc private func buttonHighlight() {
        UIView.animate(withDuration: 0.1) {
            self.backButtonIcon.alpha = 0.5
        }
    }

    @objc private func buttonUnhighlight() {
        UIView.animate(withDuration: 0.1) {
            self.backButtonIcon.alpha = 1.0
        }
    }
}


class NavBarController_1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navController = navigationController as? NavigationController {
            navController.setTitle("My title")
        }
    }
}


import UIKitTools
import SwiftUI

struct NavBarController_1_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            let navController = NavigationController(rootViewController: NavBarController_1())
            return navController
        }
        .ignoresSafeArea()
    }
}



