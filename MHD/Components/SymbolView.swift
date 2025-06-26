//
//
//
// Created by: Patrik Drab on 26/06/2025
// Copyright (c) 2025 MHD 
//
//         



import UIKit
//
//class SymbolView: UIImageView {
//    
//    // MARK: - Properties
//    private var symbolName: String
//    private var pointSize: CGFloat
//    private var weight: UIImage.SymbolWeight
//    private var scale: UIImage.SymbolScale
//    private var color: UIColor
//    
//    // MARK: - Initializers
//    
//    init(
//        symbolName: String,
//        pointSize: CGFloat = 20,
//        weight: UIImage.SymbolWeight = .semibold,
//        scale: UIImage.SymbolScale = .default,
//        tintColor: UIColor = .systemBlue
//    ) {
//        self.symbolName = symbolName
//        self.pointSize = pointSize
//        self.weight = weight
//        self.scale = scale
//        self.color = tintColor
//        
//        super.init(frame: .zero)
//        
//        configureView()
//        configureSymbol()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Private Methods
//    
//    private func configureView() {
//        contentMode = .scaleAspectFit
//        tintColor = color
//        //accessibilityIgnoresInvertColors = true
//        //translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    private func configureSymbol() {
//        let configuration = UIImage.SymbolConfiguration(
//            pointSize: pointSize,
//            weight: weight,
//            scale: scale
//        )
//        self.image = UIImage(named: symbolName)?
//            .withConfiguration(configuration)
//            .withRenderingMode(.alwaysTemplate)
//    }
//    
//    // MARK: - Public Methods
//    
//    func updateSymbol(
//        _ symbolName: String? = nil,
//        pointSize: CGFloat? = nil,
//        weight: UIImage.SymbolWeight? = nil,
//        scale: UIImage.SymbolScale? = nil,
//        tintColor: UIColor? = nil
//    ) {
//        self.symbolName = symbolName ?? self.symbolName
//        self.pointSize = pointSize ?? self.pointSize
//        self.weight = weight ?? self.weight
//        self.scale = scale ?? self.scale
//        
//        configureSymbol()
//        
//        if let tintColor = tintColor {
//            self.tintColor = tintColor
//        }
//    }
//    
//    func setSymbol(_ symbolName: String) {
//        updateSymbol(symbolName)
//    }
//    
//    func setColor(_ color: UIColor) {
//        tintColor = color
//    }
//    
//    func setSize(_ size: CGFloat) {
//        updateSymbol(pointSize: size)
//    }
//    
//    func setScale(_ scale: UIImage.SymbolScale) {
//        updateSymbol(scale: scale)
//    }
//    
//    func setWeight(_ weight: UIImage.SymbolWeight) {
//        updateSymbol(weight: weight)
//    }
//}


import UIKit

class SymbolView: UIImageView {
    
    // MARK: - Properties
    private var symbolName: String
    private var iconSize: CGFloat
    private var color: UIColor
    
    // MARK: - Initializer
    
    init(
        symbolName: String,
        size: CGFloat = 20,
        tintColor: UIColor = .systemBlue
    ) {
        self.symbolName = symbolName
        self.iconSize = size
        self.color = tintColor
        
        super.init(frame: .zero)
        
        configureView()
        updateImage()
        applySizeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        contentMode = .scaleAspectFit
        tintColor = color
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateImage() {
        self.image = UIImage(named: symbolName)?
            .withRenderingMode(.alwaysTemplate)
    }
    
    private func applySizeConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: iconSize),
            heightAnchor.constraint(equalToConstant: iconSize)
        ])
    }
    
    // MARK: - Public Methods
    
    func setSymbol(_ name: String) {
        self.symbolName = name
        updateImage()
    }
    
    func setColor(_ color: UIColor) {
        self.color = color
        self.tintColor = color
    }
    
    func setSize(_ size: CGFloat) {
        self.iconSize = size
        removeSizeConstraints()
        applySizeConstraints()
    }
    
    func updateSymbol(symbolName: String, tintColor: UIColor) {
        self.symbolName = symbolName
        self.color = tintColor
        self.tintColor = tintColor
        updateImage()
    }
    
    private func removeSizeConstraints() {
        constraints.forEach { constraint in
            if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                removeConstraint(constraint)
            }
        }
    }
}
