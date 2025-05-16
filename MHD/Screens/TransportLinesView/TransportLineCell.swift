//
//
//
// Created by: Patrik Drab on 29/04/2025
// Copyright (c) 2025 MHD 
//
//         


import UIKit
import UIKitTools

class TransportLineCell: UICollectionViewCell {
    static let reuseIdentifier = "TransportLineCell"
    
    var transportLineIdentificator = UILabel(
        font: UIFont.systemFont(ofSize: 16, weight: .bold),
        textColor: .black,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    var isWarning: Bool = false {
        didSet {
            if oldValue != isWarning {
                waringIcon.isHidden = !isWarning
            }
        }
    }
    
    var waringIcon = IconImageView(
        systemName: "exclamationmark.triangle.fill",
        config: UIImage.SymbolConfiguration(pointSize: 14, weight: .regular),
        tintColor: .systemRed
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear

        addSubview(transportLineIdentificator)
        transportLineIdentificator.center()
        
        transportLineIdentificator.addSubview(waringIcon)
        waringIcon.topTrailing(offset: .init(x: 14, y: -14))
        waringIcon.isHidden = !isWarning
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with line: CDTransportLine) {
        transportLineIdentificator.text = line.name
        isWarning = line.alerts == nil
    }
}
