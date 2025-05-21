//
//
//
// Created by: Patrik Drab on 16/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

extension UIView {
    func asButton(action: @escaping () -> Void) {
        self.isUserInteractionEnabled = true
        let tapRecognizer = TapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.action = action
        tapRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func handleTap(_ sender: TapGestureRecognizer) {
        sender.action?()
    }
}

private class TapGestureRecognizer: UITapGestureRecognizer {
    var action: (() -> Void)?
}


extension UIView {
    public func pinInTopSafeArea() {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
}



extension UIView {
    /// Function for finding UIViewController
    /// View A (self)
    /// └─ next responder → View B (superview)
    ///     └─ next responder → ViewController (found!)
    ///
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
