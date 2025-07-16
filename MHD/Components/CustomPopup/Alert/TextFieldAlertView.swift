//
//
//
// Created by: Patrik Drab on 12/07/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

class TextFieldAlertView: SystemAlertView {
    let textField = CustomTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupHierarchy() {
        alertContent.addArrangedSubview(titleLabel)
        alertContent.addArrangedSubview(messageLabel)
        alertContent.addArrangedSubview(textField)
        alertContent.addArrangedSubview(buttonsContent)
    }
}
