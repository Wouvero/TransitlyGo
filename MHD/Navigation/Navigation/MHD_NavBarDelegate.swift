//
//
//
// Created by: Patrik Drab on 29/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

// MARK: - NavBarDelegate protocol
protocol MHD_NavigationDelegate: AnyObject {
    var navBarContentHeight: CGFloat { get }
    var contentLabelText: NSAttributedString { get }
    
    func shouldHideTabBar() -> Bool
    func shouldHideNavBar() -> Bool
}

extension MHD_NavigationDelegate {
    
    
    var navBarContentHeight: CGFloat {
        return 44
    }
    
    func shouldHideTabBar() -> Bool {
        return false
    }
    
    func shouldHideNavBar() -> Bool {
        return false
    }
}
