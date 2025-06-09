//
//
//
// Created by: Patrik Drab on 30/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitPro

class StationViewCell: UITableViewCell {
    static let reuseIdentifier = "StationViewCell"
    
    private let rowHeight: CGFloat = 44
    
    var stationName = UILabel(
        text: "Station name",
        font: UIFont.interMedium(size: 16),
        textColor: .neutral800,
        textAlignment: .left,
        numberOfLines: 1
    )
    
    var minutesLabel = UILabel(
        font: UIFont.interSemibold(size: 16),
        textColor: .neutral800,
        textAlignment: .left,
        numberOfLines: 1
    )
    
    var isOnSignIcon = IconImageView(
        systemName: SFSymbols.onSign,
        color: .neutral700
    )
    
    var iconContainer = UIView()
    
    var cellContainer: UIStackView!
    
    var timeContainer = UIView()
    
    private var rowIndex: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    private func setupCell() {
        selectionStyle = .none
        
        cellContainer = UIStackView(
            arrangedSubviews: [
                timeContainer,
                stationName,
                UIView(),
                iconContainer
            ],
            axis: .horizontal,
            spacing: 0,
            alignment: .leading,
            distribution: .fillProportionally
        )
        
        cellContainer.paddingLeft(42)
        cellContainer.paddingRight(16)

        addSubviews(cellContainer)
        cellContainer.pinInSuperview()
        
        stationName.setHeight(rowHeight)
        
        iconContainer.setSize(.equalEdge(rowHeight))
        iconContainer.addSubview(isOnSignIcon)
        isOnSignIcon.centerInSuperview()
        
        timeContainer.setDimensions(width: rowHeight, height: rowHeight)
        timeContainer.addSubview(minutesLabel)
        minutesLabel.center()
        
        minutesLabel.isHidden = true
        
    }
    
    func updateAppearance() {
        if isHighlighted {
            // Highlighted state
            backgroundColor = .neutral800
            stationName.textColor = .white
            minutesLabel.textColor = .white
            isOnSignIcon.setColor(.white)
        } else {
            // Normal state based on index
            backgroundColor = rowIndex.isMultiple(of: 2) ? .neutral30 : .neutral10
            stationName.textColor = .neutral800
            minutesLabel.textColor = .neutral800
            isOnSignIcon.setColor(.neutral700)
        }
    }
    
    func showMinutes(_ minutes: String?) {
        minutesLabel.text = minutes
        minutesLabel.isHidden = (minutes == nil || minutes?.isEmpty == true)
    }
    
    func formatRow(with stationModel: StationTableVM, index: Int) {
        let station = stationModel.station
        let minutesToDisplay = stationModel.minutesToDisplay ?? ""
        
        rowIndex = index
        stationName.text = station.stationInfo?.stationName
        iconContainer.isHidden = station.isOnSign ? false : true
        showMinutes(minutesToDisplay)
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
