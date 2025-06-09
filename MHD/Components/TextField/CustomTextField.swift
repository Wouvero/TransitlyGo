//
//
//
// Created by: Patrik Drab on 02/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

enum ValidationType {
    case decimal
    case integer
    case none
}

class CustomTextField: UITextField {
    
    var validationType: ValidationType = .none
    var toolBar: UIToolbar? = nil
    var charactersLimit: Int? = nil
    
    init() {
        super.init(frame: .zero)
        setupTextField()
        setupToolBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
        setupToolBar()
    }

}

// MARK: - Setup text field
extension CustomTextField {
    
    private func setupTextField() {
        delegate = self
        // Setup layer
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.neutral200.cgColor
        
        // Setup cursor color
        tintColor = UIColor.primary500
        
       
        keyboardType = .default
        textAlignment = .left
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}


// MARK: - Setup tool bar
extension CustomTextField {
    
    private func setupToolBar() {
        inputAccessoryView = toolBar != nil ? toolBar : setupDefaultToolBar()
    }
    
    private func setupDefaultToolBar() -> UIToolbar {
        let defaultToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        defaultToolBar.barStyle = .default
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Hotovo", style: .done, target: self, action: #selector(dissmissKeyboard))
        
        defaultToolBar.items = [flexibleSpace, doneButton]
        defaultToolBar.sizeToFit()
        
        return defaultToolBar
    }
    
}


// MARK: - Delegate methods
extension CustomTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        
        let replacementString = string.trimmingCharacters(in: .whitespaces)
        let updatedText = currentText.replacingCharacters(in: range, with: replacementString)
        
        if let charactersLimit = charactersLimit,
           updatedText.count > charactersLimit {
            return false
        }
        
        switch validationType {
        case .decimal:
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            let allowedCharacters = CharacterSet(charactersIn: "0123456789" + decimalSeparator)
            let isValidDecimal = updatedText.rangeOfCharacter(from: allowedCharacters.inverted) == nil
            let hasSingleSeparator = updatedText.components(separatedBy: decimalSeparator).count <= 2
            if isValidDecimal && hasSingleSeparator {
                textField.text = updatedText // Update the text manually
                return false // Prevent default behavior
                /// ⚠️ Always return false when you manually modify textField.text
                /// If you return true after modifying textField.text, the system will also apply the original
                /// change (the one passed to shouldChangeCharactersIn), leading to unexpected behavior
                /// or duplicate changes.
            }
            return false // Invalid input, prevent update
            
        case .integer:
            let integerSet = CharacterSet.decimalDigits
            let isValidInteger = updatedText.rangeOfCharacter(from: integerSet.inverted) == nil
            if isValidInteger {
                textField.text = updatedText // Update the text manually
                return false // Prevent default behavior
            }
            return false // Invalid input, prevent update
            
        case .none:
            textField.text = updatedText
            return false
        }
    }
    
}

// MARK: - Public API
extension CustomTextField {
    
    @objc func dissmissKeyboard() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.resignFirstResponder()
        }
    }
    
    @objc func activateKeyboard() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.becomeFirstResponder()
        }
    }
    
    func setupPlaceholder(_ placeholder: String) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.neutral600,
            ]
        )
    }
    
    func setupText(_ text: String) {
        attributedText = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.neutral800,
            ]
        )
    }

}
