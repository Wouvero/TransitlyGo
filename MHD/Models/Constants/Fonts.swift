//
//
//
// Created by: Patrik Drab on 09/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

extension UIFont {
    static func interRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Inter24pt-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
    
    static func interMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Inter24pt-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    static func interSemibold(size: CGFloat) -> UIFont {
        return UIFont(name: "Inter24pt-Semibold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }
}
