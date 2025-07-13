//
//
//
// Created by: Patrik Drab on 05/07/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

// MARK: - POPUP VIEW

class CustomPopupView: UIView {
    let closeButton = CustomButton(
        type: .iconOnly(iconName: SFSymbols.close_large_line, iconColor: .neutral800, iconSize: 24),
        style: .plain(cornerRadius: 0),
        size: .makeAuto()
    )
    
    var dismissOnTapOutside: Bool = true
    
    var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
 
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(on viewController: UIViewController) {
        guard let window = viewController.view.window else { return }
        
        window.addSubview(self)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           topAnchor.constraint(equalTo: window.topAnchor),
           bottomAnchor.constraint(equalTo: window.bottomAnchor),
           leadingAnchor.constraint(equalTo: window.leadingAnchor),
           trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
        
        setupViewConstrains()
        setupDismissOnTapOutside()
    }
    
    func show(on window: UIWindow?) {
        guard let window else { return }
        
        window.addSubview(self)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           topAnchor.constraint(equalTo: window.topAnchor),
           bottomAnchor.constraint(equalTo: window.bottomAnchor),
           leadingAnchor.constraint(equalTo: window.leadingAnchor),
           trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
        
        setupViewConstrains()
        setupDismissOnTapOutside()
    }
    
    @objc func close() {
        removeFromSuperview()
        containerView.removeFromSuperview()
    }
    
    func addContentView(_ view: UIView) {
        containerView.addArrangedSubview(view)
    }
    
    func removeContentView(_ view: UIView) {
        guard containerView.arrangedSubviews.contains(view) else { return }
        containerView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    private func setupViewConstrains() {
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    private func setupDismissOnTapOutside() {
        guard dismissOnTapOutside else { return }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
}

extension CustomPopupView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        return !containerView.frame.contains(location)
    }
}

