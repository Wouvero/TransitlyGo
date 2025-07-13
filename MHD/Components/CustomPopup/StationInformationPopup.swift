//
//
//
// Created by: Patrik Drab on 12/07/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

class StationInformationPopup: CustomPopupView {
    let station: MHD_StationInfo
    
    let popupContent = UIStackView()
    let stationNameLabel = UILabel()
    
    let selectdButton = CustomButton(
        type: .textOnly(label: "Zvoliť", textColor: .neutral),
        style: .filled(backgroundColor: .primary500, cornerRadius: 8),
        size: .makeAuto(xAxes: 10, yAxes: 16)
    )
    
    init(station: MHD_StationInfo) {
        self.station = station
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        dismissOnTapOutside = true
        configureStationNameLabel()
        configurePopupContent()
        setupHierarchy()
        configureCloseButton()
    }
    
    private func configureStationNameLabel() {
        stationNameLabel.text = station.stationName
        stationNameLabel.font = UIFont.interSemibold(size: 16)
        stationNameLabel.textColor = UIColor.neutral800
        stationNameLabel.textAlignment = .center
        stationNameLabel.numberOfLines = 0
    }
    
    private func configurePopupContent() {
        popupContent.axis = .vertical
        popupContent.spacing = 16
        popupContent.backgroundColor = .white
        popupContent.isLayoutMarginsRelativeArrangement = true
        popupContent.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        
        addContentView(popupContent)
    }
    
    func configureCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: popupContent.topAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: popupContent.trailingAnchor).isActive = true
        
        closeButton.onRelease = { [weak self] in
            guard let self else { return }
            close()
        }
    }
    
    func setupHierarchy() {
        popupContent.addArrangedSubview(stationNameLabel)
        popupContent.addArrangedSubview(selectdButton)
        
        popupContent.addSubview(closeButton)
        
    }
    
 
    
    override func show(on viewController: UIViewController) {
        super.show(on: viewController)
        
        guard let vc = viewController as? MapViewController else { return }
        
        selectdButton.onRelease = { [weak self] in
            guard let self else { return }
            NotificationCenter.default.post(
                name: .didSelectStation,
                object: station,
                userInfo: ["fieldType": vc.fieldType]
            )
            close()
            vc.popToRoot()
        }
    }
}
