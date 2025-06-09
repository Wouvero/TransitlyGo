//
//
//
// Created by: Patrik Drab on 09/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit


class FadeInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 0.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let container = transitionContext.containerView
        toView.alpha = 0
        container.addSubview(toView)
        
        UIView.animate(withDuration: duration, animations: {
            toView.alpha = 1
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}

//class FadeInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    // Duration of the animation
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0
//    }
//    
//    // Perform the animation
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let toVC = transitionContext.viewController(forKey: .to) else {
//            return
//        }
//        
//        let containerView = transitionContext.containerView
//        let toView = toVC.view!
//        
//        // Set up the initial state of the toView
//        toView.alpha = 0 // Start fully transparent
//        containerView.addSubview(toView)
//        
//        // Perform the fade-in animation
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//            toView.alpha = 1 // Fade in to fully opaque
//        }) { _ in
//            // Complete the transition
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//    }
//}

