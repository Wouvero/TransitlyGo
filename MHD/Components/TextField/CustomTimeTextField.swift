//
//
//
// Created by: Patrik Drab on 02/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

class CustomTimeTextField: CustomTextField {
    var onTextChanged: ((String) -> Void)?
    
    private var type: TimeType
    init(type: TimeType) {
        self.type = type
        super.init()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setup text field
extension CustomTimeTextField {
    
    private func setupTextField() {
        validationType = .time(type: type)
        textAlignment = .center
        keyboardType = .asciiCapableNumberPad
       
    }
    
    @objc private func textDidChange() {
        onTextChanged?(text ?? "")
    }
    
}
