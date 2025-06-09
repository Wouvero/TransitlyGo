//
//
//
// Created by: Patrik Drab on 07/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

class StationInformationPopupView: PopupView {
    
    let station: MHD_StationInfo
    
    init(station: MHD_StationInfo) {
        self.station = station
        super.init()
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let content = UIView(color: .white)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            content.widthAnchor.constraint(equalToConstant: 250),
            content.heightAnchor.constraint(equalToConstant: 250),
        ])
        
        
        let label = UILabel(
            text: station.stationName,
            font: UIFont.interSemibold(size: 16),
            textColor: UIColor.neutral800,
            textAlignment: .center,
            numberOfLines: 1
        )
        
        let selectButton = CustomButton(
            type: .textOnly(label: "Zvoliť", textColor: .neutral),
            style: .filled(backgroundColor: .primary500, cornerRadius: 8),
            size: .makeAuto(xAxes: 10, yAxes: 16)
        )
        onTapGesture { [weak self] in
            guard let self else { return }
            
            
            
            
    
            
            print("Select station")
        }

        content.addSubview(label)
        label.center()
        
        content.addSubview(closeButton)
        closeButton.topTrailing()
        
        content.addSubview(selectButton)
        selectButton.bottom(offset: .init(x: 0, y: 10))
        
        addArrangedSubview(content)
    }
}
