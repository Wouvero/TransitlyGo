//
//
//
// Created by: Patrik Drab on 19/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitPro

class DestinationSearchTableCell: UITableViewCell {
    private var section: Int = 0
    private var row: Int = 0
    
    private let alphabetTitle = UILabel(
        text: "A",
        font: UIFont.interRegular(size: 16),
        textColor: .neutral800,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private let alphabetTitleView = UIView()
    
    private let stationName = UILabel(
        text: "Title",
        font: UIFont.interSemibold(size: 16),
        textColor: .neutral800,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private let stationNameView = UIView()
    
    private let rootView = UIStackView(
        arrangedSubviews: [],
        axis: .horizontal,
        spacing: 0
    )
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear
        addSubviews(rootView)
        rootView.pinInSuperview()
        rootView.addBorder(for: [.bottom], in: .neutral30, width: 1)
        
        
        alphabetTitleView.setDimensions(width: 50, height: 50)
        alphabetTitleView.addSubview(alphabetTitle)
        alphabetTitle.center()
        
        stationNameView.setDimensions(height: 50)
        stationNameView.addSubview(stationName)
        stationName.leading()
        
        rootView.addArrangedSubview(alphabetTitleView)
        rootView.addArrangedSubview(stationNameView)
        
        
        let customSelectionView = UIView()
        customSelectionView.backgroundColor = .systemGray6
        selectedBackgroundView = customSelectionView
    }
    
    func configure(indexPath: IndexPath, alphabet: String, stationName: String?) {
        section = indexPath.section
        row = indexPath.row
        
        alphabetTitle.text = alphabet
        alphabetTitle.isHidden = row != 0
        
        self.stationName.text = stationName
    }
}
