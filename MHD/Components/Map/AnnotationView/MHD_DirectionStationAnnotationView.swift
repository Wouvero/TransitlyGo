//
//
//
// Created by: Patrik Drab on 07/06/2025
// Copyright (c) 2025 MHD 
//
//

import UIKit
import MapKit
import UIKitPro

class MHD_DirectionStationAnnotationView: MKAnnotationView {
    
    private let contentView = UIStackView()
    
    // MARK: - Properties
    private let busStopIcon = IconImageView(
        systemName: "mappin",
        color: UIColor.neutral,
        pointSize: 12,
        weight: .semibold,
        scale: .default
    )
    
    private let onSignIcon = IconImageView(
        systemName: "hand.raised.fill",
        color: UIColor.neutral,
        pointSize: 12,
        weight: .semibold,
        scale: .default
    )
    
    
    // MARK: - INIT
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupMapAnnotationView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MHD_DirectionStationAnnotationView {
    private func setupMapAnnotationView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.neutral800
        layer.cornerRadius = 8
        clipsToBounds = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .horizontal
        contentView.spacing = 2
        contentView.alignment = .center
        contentView.distribution = .fill
        addSubviews(contentView)
        
    
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            
        ])
        
        let busIconContent = UIView()
        busIconContent.setDimensions(width: 24, height: 24)
        busIconContent.addSubview(busStopIcon)
        busStopIcon.center()
    
        contentView.addArrangedSubview(busIconContent)
        
        
        if let annotation = self.annotation as? MHD_DirectionStationAnnotation {
            if annotation.station.isOnSign {
                let isOnSignIconContent = UIView()
                isOnSignIconContent.setDimensions(width: 24, height: 24)
                isOnSignIconContent.addSubview(onSignIcon)
                onSignIcon.center()
                
                contentView.addArrangedSubview(isOnSignIconContent)
            }
            
            onTapGesture {
                print(annotation.station.stationInfo?.stationName ?? "")
                print("Show popup okno so zastavkou")
            }
        }
    }
}
