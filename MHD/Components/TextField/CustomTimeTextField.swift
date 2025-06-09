//
//
//
// Created by: Patrik Drab on 02/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

class CustomTimeTextField: CustomTextField {
    
    override init() {
        super.init()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
}

// MARK: - Setup text field
extension CustomTimeTextField {
    
    private func setupTextField() {
        charactersLimit = 2
        validationType = .integer
        textAlignment = .center
        keyboardType = .asciiCapableNumberPad
    }
    
}
