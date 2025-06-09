//
//
//
// Created by: Patrik Drab on 07/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

class PopupView: UIStackView {
    private weak var dimmingView: UIView?
    
    let closeButton = CustomButton(
        type: .iconOnly(iconName: "xmark", iconColor: .neutral800, iconSize: 24),
        style: .plain(cornerRadius: 0),
        size: .makeAuto()
    )
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        axis = .vertical
        alignment = .center
        distribution = .fill
        spacing = 0
        
        closeButton.onRelease = { [weak self] in
            guard let self else { return }
            self.close()
        }
    }
    
    @objc func close() {
        guard let dimmingView = dimmingView else { return }
        removeFromSuperview()
        dimmingView.removeFromSuperview()
    }
    
    func show(on viewController: UIViewController) {
        guard let window = viewController.view.window else { return }
        
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        dimmingView.alpha = 0
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(dimmingView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        dimmingView.addGestureRecognizer(tapGesture)
             
        // Add constraints for dimming view
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: window.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
         
        window.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        // Center constraints
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: window.centerXAnchor),
            centerYAnchor.constraint(equalTo: window.centerYAnchor)
        ])
        
        self.dimmingView = dimmingView
    }
}
