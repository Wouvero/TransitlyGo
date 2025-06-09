//
//
//
// Created by: Patrik Drab on 26/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitPro


/// Creates a custom button with text + icon configuration
///
/// # Example Usage
/// ```
/// let button = CustomButton_2(
///     type: .textIcon(
///         label: "Label",
///         textColor: .white,
///         imageName: "heart",
///         imageColor: .white,
///         spacing: 0
///     ),
///     style: .filled(
///         backgroundColor: .systemBlue,
///         cornerRadius: 0
///     ),
///     size: .auto(
///         pTop: 10,
///         pTrailing: 10,
///         pBottom: 10,
///         pLeading: 10
///     )
/// )
///

class CustomButton: UIView {
    // MARK: - Properties
    private var buttonIcon = IconImageView(
        systemName: "heart",
        color: .black,
        pointSize: 20,
        weight: .regular,
        scale: .default
    )

    private var buttonLabel = UILabel(font: UIFont.interSemibold(size: 16))
    private var content: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private var bgColor: UIColor = .clear
    
    private var isPressed: Bool = false {
        didSet {
            animateTo()
        }
    }
    
    private var type: CButtonType
    private var style: CButtonStyle
    private var size: CButtonSize
    private var shadow: CButtonShadow?
    
    var onRelease: (() -> Void)?
    
    // MARK: - Init
    init(
        type: CButtonType,
        style: CButtonStyle,
        size: CButtonSize = .auto(pTop: 12, pTrailing: 16, pBottom: 12, pLeading: 16),
        shadow: CButtonShadow? = nil
    ) {
        self.type = type
        self.style = style
        self.size = size
        self.shadow = shadow
        super.init(frame: .zero)
        setupCustomButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Initial configurations
extension CustomButton {
    
    private func setupCustomButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        configureButtonType()
        configureButtonStyle()
        configureButtonSize()
        
        configureButtonShadow()
    }
    
    private func configureButtonType() {
        switch type {
        case .textIcon(let label, let textColor, let iconName, let iconColor, let iconSize, let spacing):
            buttonIcon.setIcon(systemName: iconName)
            buttonIcon.setColor(iconColor ?? .black)
            buttonIcon.setSize(iconSize)
    
            buttonIcon.translatesAutoresizingMaskIntoConstraints = false
            
            buttonLabel.text = label
            buttonLabel.textColor = textColor
            buttonLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let textIconContent = UIStackView()
            textIconContent.translatesAutoresizingMaskIntoConstraints = false
            textIconContent.axis = .horizontal
            textIconContent.distribution = .fill
            
            
            textIconContent.addArrangedSubview(buttonIcon)
            textIconContent.addArrangedSubview(buttonLabel)
            textIconContent.setCustomSpacing(spacing, after: buttonIcon)
            
            content.axis = .vertical
            content.alignment = .center
            
            content.addArrangedSubview(textIconContent)
            
            
            addSubviews(content)
            
            NSLayoutConstraint.activate([
                //buttonIcon.widthAnchor.constraint(equalToConstant: 24),
                //buttonIcon.heightAnchor.constraint(equalToConstant: 24),
                
                content.centerXAnchor.constraint(equalTo: centerXAnchor),
                content.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
            
        case .textOnly(let label, let textColor):
            buttonLabel.text = label
            buttonLabel.textColor = textColor
            buttonLabel.translatesAutoresizingMaskIntoConstraints = false
            
            content.distribution = .equalCentering
            
            content.addArrangedSubview(UIView())
            content.addArrangedSubview(buttonLabel)
            content.addArrangedSubview(UIView())
            
            addSubviews(content)
            
        case .iconOnly(let iconName, let iconColor, let iconSize):
            buttonIcon.setIcon(systemName: iconName)
            buttonIcon.setColor(iconColor ?? .black)
            buttonIcon.setSize(iconSize)
            
            buttonIcon.translatesAutoresizingMaskIntoConstraints = false
            
            content.distribution = .equalCentering
    
            content.addArrangedSubview(UIView())
            content.addArrangedSubview(buttonIcon)
            content.addArrangedSubview(UIView())
            
            addSubview(content)
            
            NSLayoutConstraint.activate([
                //buttonIcon.widthAnchor.constraint(equalToConstant: 24),
                //buttonIcon.heightAnchor.constraint(equalToConstant: 24),
            ])
        }
    }
    
    private func configureButtonStyle() {
        switch style {
        case .plain(let cornerRadius):
            bgColor = .clear
            backgroundColor = .clear
            layer.cornerRadius = cornerRadius
            layer.borderWidth = 0
            
        case .filled(let backgroundColor, let cornerRadius):
            bgColor = backgroundColor
            self.backgroundColor = backgroundColor
            layer.cornerRadius = cornerRadius
            layer.borderWidth = 0
            
        case .filledWithOutline(let borderColor, let borderWidth, let backgroundColor, let cornerRadius):
            bgColor = backgroundColor
            self.backgroundColor = backgroundColor
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
            layer.cornerRadius = cornerRadius
        case .outlined(let borderColor, let borderWidth, let cornerRadius):
            bgColor = .clear
            backgroundColor = .clear
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
            layer.cornerRadius = cornerRadius
        }
    }
    
    private func configureButtonSize() {
        switch size {
        case .auto(let pTop, let pTrailing, let pBottom, let pLeading):
            NSLayoutConstraint.activate([
                content.topAnchor.constraint(equalTo: self.topAnchor, constant: pTop),
                content.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -pBottom),
                content.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: pLeading),
                content.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -pTrailing)
            ])
        case .custom(let width, let height):
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: width),
                self.heightAnchor.constraint(equalToConstant: height),
                content.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                content.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
    }
    
    private func configureButtonShadow() {
        guard let shadow = self.shadow else { return }
        
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOpacity = shadow.opacity
        layer.shadowOffset = shadow.offset
        layer.shadowRadius = shadow.radius
        layer.masksToBounds = false
    }

}

// MARK: - Public methods for future button configuration start with (set...)
extension CustomButton {
    func setButtonIcon(_ systemName: String) {
        buttonIcon.setIcon(systemName: systemName)
    }
    
    func setButtonIconColor(_ color: UIColor) {
        buttonIcon.setColor(color)
    }
    
    func setButtonLabelText(_ text: String) {
        buttonLabel.text = text
    }
    
    func setButtonLabelText(_ text: NSAttributedString) {
        buttonLabel.attributedText = text
    }
    
    func setButtonLabelTextColor(_ textColor: UIColor) {
        buttonLabel.textColor = textColor
    }
    
    func setButtonLabelFont(_ font: UIFont) {
        buttonLabel.font = font
    }
    
    func setCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func setShadow(shadow: CButtonShadow) {
        self.shadow = shadow
        configureButtonShadow()
    }
    
}

// MARK: - Animations
extension CustomButton {
    
    func animateToDefaultState() {
        self.isPressed = false
    }
    
    func animateToActiveState() {
        self.isPressed = true
    }
    
    private func animateTo() {

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.15) {
                if self.bgColor == .clear {
                    self.backgroundColor =  self.isPressed
                    ? .lightGray.withAlphaComponent(0.1)
                    : self.bgColor
                } else {
                    self.backgroundColor =  self.isPressed
                    ? self.bgColor.withAlphaComponent(0.9)
                    : self.bgColor
                }
                
            }
        }
    }
}

// MARK: - Touches
extension CustomButton {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateToActiveState()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleTouch(touches, touchEnded: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateToDefaultState()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleTouch(touches, touchEnded: true)
    }
    
    private func handleTouch(_ touches: Set<UITouch>, touchEnded: Bool) {
        guard let touchLocationInSuperview: CGPoint = touches.first?.location(in: self.superview) else {

            animateToDefaultState()
            return
        }
        
        let touchLocation: CGPoint = self.convert(touchLocationInSuperview, to: self)
        
        guard self.frame.contains(touchLocation) else {
            animateToDefaultState()
            return
        }

        if touchEnded {
            self.animateToDefaultState()
            self.onRelease?()
        } else {
            self.animateToActiveState()
        }
    }
}


extension CustomButton {
    static func makeCircleBtn(
        iconName: String = "heart",
        iconColor: UIColor = .white,
        iconSize: CGFloat = 24,
        backgroundColor: UIColor = .systemBlue,
        size: CGFloat = 50
    ) -> CustomButton {
        let circleButton = CustomButton(
            type: .makeIconOnly(iconName: iconName, iconColor: iconColor, iconSize: iconSize),
            style: .makeFilled(backgroundColor: backgroundColor, cornerRadius: size/2),
            size: .custom(width: size, height: size)
        )
        
        return circleButton
    }
    
    static func makeOutlineCircleBtn(
        iconName: String = "heart",
        iconColor: UIColor = .white,
        iconSize: CGFloat = 24,
        borderWidth: CGFloat = 1,
        borderColor: UIColor = .black,
        backgroundColor: UIColor = .systemBlue,
        size: CGFloat = 50
    ) -> CustomButton {
        let circleButton = CustomButton(
            type: .makeIconOnly(iconName: iconName, iconColor: iconColor, iconSize: iconSize),
            style: .makeFilledWithOutline(
                borderColor: borderColor,
                borderWidth: borderWidth,
                backgroundColor: backgroundColor,
                cornerRadius: size/2
            ),
            size: .custom(width: size, height: size)
        )
        
        return circleButton
    }
}
