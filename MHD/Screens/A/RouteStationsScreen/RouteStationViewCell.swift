//
//
//
// Created by: Patrik Drab on 30/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitPro

class RouteStationViewCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "StationViewCell"

    enum Constants {
        static let leftMargin: CGFloat = 44 + 16
        static let rightMargin: CGFloat = 16
        static let cellHeight: CGFloat = 44
    }
    
    private var cellIndex: Int = 0
    
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
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


// MARK: - Setup UI
extension RouteStationViewCell {
    
    private func setupCell() {
        // Initial
        selectionStyle = .none
        
        setCellContainer()
        setStationNameLabel()
        setIsOnSignIconContainer()
        setTimeContainer()
    }
    
    private func setCellContainer() {
        cellContainer = UIStackView(arrangedSubviews: [
            timeContainer,
            stationName,
            UIView(),
            iconContainer
        ])
        cellContainer.axis = .horizontal
        cellContainer.spacing = 0
        cellContainer.alignment = .leading
        cellContainer.distribution = .fillProportionally
        
        cellContainer.isLayoutMarginsRelativeArrangement = true
        cellContainer.layoutMargins.left = Constants.leftMargin
        cellContainer.layoutMargins.right = Constants.rightMargin


        contentView.addSubview(cellContainer)
        cellContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellContainer.topAnchor.constraint(equalTo: topAnchor),
            cellContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setStationNameLabel() {
        stationName.translatesAutoresizingMaskIntoConstraints = false
        stationName.heightAnchor.constraint(equalToConstant: Constants.cellHeight).isActive = true
    }
    
    private func setIsOnSignIconContainer() {
        iconContainer.addSubview(isOnSignIcon)
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        isOnSignIcon.translatesAutoresizingMaskIntoConstraints  = false
        
        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: Constants.cellHeight),
            iconContainer.heightAnchor.constraint(equalToConstant: Constants.cellHeight),
            isOnSignIcon.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            isOnSignIcon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
        ])
    }
    
    private func setTimeContainer() {
        timeContainer.addSubview(minutesLabel)
        timeContainer.translatesAutoresizingMaskIntoConstraints = false
        minutesLabel.translatesAutoresizingMaskIntoConstraints  = false
        minutesLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            timeContainer.widthAnchor.constraint(equalToConstant: Constants.cellHeight),
            timeContainer.heightAnchor.constraint(equalToConstant: Constants.cellHeight),
            minutesLabel.centerXAnchor.constraint(equalTo: timeContainer.centerXAnchor),
            minutesLabel.centerYAnchor.constraint(equalTo: timeContainer.centerYAnchor)
        ])
    }
    
}

// MARK: - Open API
extension RouteStationViewCell {
    
    func updateAppearance() {
        if isHighlighted {
            // Highlighted state
            backgroundColor = .neutral800
            stationName.textColor = .white
            minutesLabel.textColor = .white
            isOnSignIcon.setColor(.white)
        } else {
            // Normal state based on index
            backgroundColor = cellIndex.isMultiple(of: 2) ? .neutral30 : .neutral10
            stationName.textColor = .neutral800
            minutesLabel.textColor = .neutral800
            isOnSignIcon.setColor(.neutral700)
        }
    }
    
    func showMinutes(_ minutes: String?) {
        minutesLabel.text = minutes
        minutesLabel.isHidden = (minutes == nil || minutes?.isEmpty == true)
    }
    
    func formatRow(with stationModel: StationViewModel, index: Int) {
        let station = stationModel.station
        let minutesToDisplay = stationModel.minutesToDisplay ?? ""
        
        cellIndex = index
        stationName.text = station.stationInfo?.stationName
        iconContainer.isHidden = station.isOnSign ? false : true
        showMinutes(minutesToDisplay)
        updateAppearance()
    }
    
}
