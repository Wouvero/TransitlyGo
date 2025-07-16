//
//
//
// Created by: Patrik Drab on 02/06/2025
// Copyright (c) 2025 MHD
//
//

import UIKit


protocol SearchTextFieldDelegate: AnyObject {
    func clearTableSearch()
}


class CustomSearchTextField: BaseTextField {
    
    weak var searchDelegate: SearchTextFieldDelegate?
    
    private let clearTextButton = CustomButton(
        type: .iconOnly(
            iconName: SFSymbols.close_circle_line,
            iconColor: .neutral200,
            iconSize: 16
        ),
        style: .plain(cornerRadius: 0),
        size: .custom(width: 50, height: 50)
    )
    
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
extension CustomSearchTextField {
    
    private func setupTextField() {
        
        // Setup placeholder
        setupPlaceholder("Vyhľadať zastávku")
        
        // Setup text
        setupText("")
        
        // Setup left and right view
        setupLeftView()
        setupRightView()
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupLeftView() {

        let leftViewContent = UIView()
        leftViewContent.translatesAutoresizingMaskIntoConstraints = false
        leftViewContent.heightAnchor.constraint(equalToConstant: 50).isActive = true
        leftViewContent.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        leftViewMode = .always
        leftView = leftViewContent
        
    }
    
    private func setupRightView() {
        
        let rightViewContent = UIView()
        rightViewContent.translatesAutoresizingMaskIntoConstraints = false
        rightViewContent.heightAnchor.constraint(equalToConstant: 50).isActive = true
        rightViewContent.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        // Add clearTextButton into right view add position it at right side and set
        // it as hidden
        clearTextButton.translatesAutoresizingMaskIntoConstraints = false
        rightViewContent.addSubview(clearTextButton)
        
        clearTextButton.trailingAnchor.constraint(equalTo: rightViewContent.trailingAnchor).isActive = true
        clearTextButton.topAnchor.constraint(equalTo: rightViewContent.topAnchor).isActive = true
        clearTextButton.bottomAnchor.constraint(equalTo: rightViewContent.bottomAnchor).isActive = true
        
        clearTextButton.isHidden = true
        clearTextButton.onRelease = { [weak self] in
            guard let self = self else { return }
            self.clearTextSearch()
        }
        
        rightViewMode = .always
        rightView = rightViewContent

    }
    
}


// MARK: - Features
extension CustomSearchTextField {

    @objc func clearTextSearch() {
        text = ""
        setClearTextButtonHidden(true)
        searchDelegate?.clearTableSearch()
    }
    
    func setClearTextButtonHidden(_ hidden: Bool) {
        clearTextButton.isHidden = hidden
    }
    
    

    
}
