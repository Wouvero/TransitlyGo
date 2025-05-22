//
//
//
// Created by: Patrik Drab on 20/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

enum NavigationControllerState {
    case visible
    case hidden
}


class NavigationController: UINavigationController {

    var navigationControllerState: NavigationControllerState = .visible {
        didSet {
            navigationContent.isHidden = navigationControllerState == .visible ? false : true
            navigationContentHeight = navigationControllerState == .visible ? 44 : 0
        }
    }
    var isTransitionEnabled: Bool = true
        
    private var navigationContentHeightConstraint: NSLayoutConstraint?
    private var navigationContentTopConstraint: NSLayoutConstraint?
    
    private let customNavigationBar = UIView(color: Colors.primary)
    private var navigationContent: UIStackView!
    
    let mainBarView = UIView()
    let leftBarView = UIView()
    let rightBarView = UIView()
    
    private var navigationContentHeight: CGFloat = 44
    
    private let titleLabel = UILabel(
        text: "Title label",
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
    
    private let toolButton = UIButton(type: .system)
    private var toolButtonIcon = IconImageView(
        systemName: "gearshape",
        tintColor: .white
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        
        setupNavigationBar()
        setupMainBarViewView()
        setupLeftBarView()
        setupRightBarView()
        setupNavigationContent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSafeAreaInsets()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.view.setNeedsLayout()
        })
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: isTransitionEnabled ? animated : false)
        updateBackButtonVisibility()
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: isTransitionEnabled ? animated : false)
        updateBackButtonVisibility()
        return vc
    }
}

extension NavigationController {
    
    private func setupNavigationBar() {
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavigationBar)
        
        NSLayoutConstraint.activate([
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupNavigationContent() {
        navigationContent = UIStackView(
            arrangedSubviews: [leftBarView, mainBarView, rightBarView],
            axis: .horizontal,
            spacing: 4
        )
        navigationContent.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.addSubview(navigationContent)
        
        NSLayoutConstraint.activate([
            navigationContent.leadingAnchor.constraint(equalTo: customNavigationBar.leadingAnchor),
            navigationContent.trailingAnchor.constraint(equalTo: customNavigationBar.trailingAnchor),
            navigationContent.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
        ])
    }
    
    private func setupMainBarViewView() {
        mainBarView.addSubview(titleLabel)
        titleLabel.pinInSuperview()
    }
    
    private func setupLeftBarView() {
        leftBarView.setDimensions(width: 44, height: 44)
        leftBarView.addSubview(backButton)
        
        // Setup back button
        backButton.pinInSuperview()
        backButton.addSubview(backButtonIcon)
        backButtonIcon.center()
        
        backButton.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(buttonHighlight), for: [.touchDown, .touchDragEnter])
        backButton.addTarget(self, action: #selector(buttonUnhighlight), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    private func setupRightBarView() {
        rightBarView.setDimensions(width: 44, height: 44)
        rightBarView.trailing()
        
        // Setup tool button
//        rightBarView.addSubview(toolButton)
//        toolButton.pinInSuperview()
//        toolButton.addSubview(toolButtonIcon)
//        toolButtonIcon.center()
//        
//        toolButton.addTarget(self, action: #selector(buttonHighlight), for: [.touchDown, .touchDragEnter])
//        toolButton.addTarget(self, action: #selector(buttonUnhighlight), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        
    }
    
    private func updateSafeAreaInsets() {
        let safeAreaTop = view.safeAreaInsets.top
        let totalTopInset = navigationContentHeight + safeAreaTop
        let additionalInset = max(0, totalTopInset - safeAreaTop)
        self.additionalSafeAreaInsets.top = additionalInset
    }
    
}

extension NavigationController {
    
    @objc private func handleBackAction() {
        if viewControllers.count > 1 {
            _ = popViewController(animated: true)       // We're in navigation stack - pop
        } else if presentingViewController != nil {
            dismiss(animated: true)                     // We're presented modally - dismiss
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
    
    private func updateBackButtonVisibility() {
        backButton.isHidden = viewControllers.count <= 1 && presentingViewController == nil
    }
}

extension NavigationController {
    
    func setNavigationContentHeight(_ height: CGFloat) {
        navigationContentHeight = height
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setTitle(_ attributedText: NSAttributedString) {
        titleLabel.attributedText = attributedText
    }
    
}


class NavBarController_2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        if let navController = navigationController as? NavigationController {
            navController.setTitle("Hello")
        }
    }
}


import UIKitTools
import SwiftUI

struct NavBarController_2_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            let navController = NavigationController(rootViewController: NavBarController_2())
            return navController
        }
        .ignoresSafeArea()
    }
}



