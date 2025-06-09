//
//
//
// Created by: Patrik Drab on 29/04/2025
// Copyright (c) 2025 MHD 
//
//         


import UIKit
import UIKitPro

class TransportLineCell: UICollectionViewCell {
    static let reuseIdentifier = "TransportLineCell"
    
    var transportLineIdentificator = UILabel(
        font: .interSemibold(size: 16),
        textColor: .black,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    var isWarning: Bool = false {
        didSet {
            if oldValue != isWarning {
                warningIcon.isHidden = !isWarning
            }
        }
    }
    
    var warningIcon = IconImageView(
        systemName: "exclamationmark.triangle.fill",
        color: .systemRed,
        pointSize: 14,
        weight: .regular,
        scale: .medium
    )
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear

        addSubview(transportLineIdentificator)
        transportLineIdentificator.center()
        
        transportLineIdentificator.addSubview(warningIcon)
        warningIcon.topTrailing(offset: .init(x: 14, y: -14))
        warningIcon.isHidden = !isWarning
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with line: MHD_TransportLine, shouldShowBorder: Bool = false) {
        transportLineIdentificator.text = line.name
        //isWarning = line.alerts == nil
        
        if shouldShowBorder {
            addBorder(for: .bottom, in: UIColor.neutral30, width: 1)
        }
    }
}
