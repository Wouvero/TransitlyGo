//
//
//
// Created by: Patrik Drab on 30/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools

class StationViewCell: UITableViewCell {
    static let reuseIdentifier = "StationViewCell"

    var stationName = UILabel(
        text: "Station name",
        font: UIFont.systemFont(ofSize: 16, weight: .medium),
        textColor: .black,
        textAlignment: .left,
        numberOfLines: 1
    )
    
    var minutesLabel = UILabel(
        text: "",
        font: UIFont.systemFont(ofSize: 16, weight: .bold),
        textColor: .black,
        textAlignment: .left,
        numberOfLines: 1
    )
    
    var isOnSignIcon = IconImageView(
        systemName: "hand.raised.fill",
        tintColor: .gray
    )
    
    var iconContainer = UIView()
    
    var cellContainer: UIStackView!
    
    var timeContainer = UIView()
    
    private var rowIndex: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        //setupTouchHandling()
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
        
        
        stationName.setHeight(50)
        
        iconContainer.setSize(.equalEdge(50))
        iconContainer.addSubview(isOnSignIcon)
        isOnSignIcon.centerInSuperview()
        
        timeContainer.setDimensions(width: 50, height: 50)
        timeContainer.addSubview(minutesLabel)
        minutesLabel.center()
        
        minutesLabel.isHidden = true
        
    }
    
    func updateAppearance() {
        if isHighlighted {
            // Highlighted state
            backgroundColor = .black
            stationName.textColor = .white
            minutesLabel.textColor = .white
            isOnSignIcon.setTintColor(.white)
        } else {
            // Normal state based on index
            backgroundColor = rowIndex.isMultiple(of: 2) ? .systemGray5 : .systemGray6
            stationName.textColor = .black
            minutesLabel.textColor = .black
            isOnSignIcon.setTintColor(.gray)
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
