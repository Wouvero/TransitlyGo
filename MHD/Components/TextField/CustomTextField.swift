//
//
//
// Created by: Patrik Drab on 18/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

class CustomTextField: BaseTextField {
    
    private var heightConstraint: NSLayoutConstraint?
    
    var height: CGFloat = 50 {
        didSet {
            guard oldValue != height else { return }
            heightConstraint?.constant = height
            layoutIfNeeded()
        }
    }
    
    init(active: Bool = true) {
        super.init()
        isUserInteractionEnabled = active
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.isActive = true
    
        setupLeftView()
        setupRightView()
    }
    
    private func setupLeftView() {

        let leftViewContent = UIView()
        leftViewContent.translatesAutoresizingMaskIntoConstraints = false
        leftViewContent.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        leftViewMode = .always
        leftView = leftViewContent
    }
    
    private func setupRightView() {

        let rightViewContent = UIView()
        rightViewContent.translatesAutoresizingMaskIntoConstraints = false
        rightViewContent.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        leftViewMode = .always
        leftView = rightViewContent
    }
}
