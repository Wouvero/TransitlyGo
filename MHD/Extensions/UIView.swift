//
//
//
// Created by: Patrik Drab on 16/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

extension UIView {
    func onTapGesture(animate: Bool = true, action: @escaping () -> Void) {
        isUserInteractionEnabled = true
        accessibilityTraits = .button
       
        // Remove existing gesture if any
        gestureRecognizers?.forEach { UIGestureRecognizer in
            if UIGestureRecognizer is TapGestureRecognizer {
                removeGestureRecognizer(UIGestureRecognizer)
            }
        }
        
        let tapRecognizer = TapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapRecognizer.action = action
        tapRecognizer.shouldAnimate = animate
        tapRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapRecognizer)
    }
    
    private func animateTapFeedback(animate: Bool) {
        guard animate else { return }
        
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.alpha = 0.6
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.alpha = 1.0
            }
        })
    }
    
    @objc private func handleTap(_ sender: TapGestureRecognizer) {
        animateTapFeedback(animate: sender.shouldAnimate)
        sender.action?()
    }
}

private class TapGestureRecognizer: UITapGestureRecognizer {
    var action: (() -> Void)?
    var shouldAnimate: Bool = true
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
}


// MARK: -


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
