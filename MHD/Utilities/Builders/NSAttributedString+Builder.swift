//
//
//
// Created by: Patrik Drab on 02/05/2025
// Copyright (c) 2025 MHD 
//
//         


import UIKit

struct NSAttributedStringBuilder {
    private let string = NSMutableAttributedString()
    
    func add(text: String, attributes: [NSAttributedString.Key: Any]) -> Self {
        string.append(NSAttributedString(string: text, attributes: attributes))
        return self
    }
    
    func addLineBreak() -> Self {
        string.append(NSAttributedString(string: "\n"))
        return self
    }
    
    func build() -> NSAttributedString {
        return string
    }
}
