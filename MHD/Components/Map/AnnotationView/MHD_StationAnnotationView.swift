//
//
//
// Created by: Patrik Drab on 04/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import MapKit
import UIKitPro

class MHD_StationAnnotationView: MKAnnotationView {
    // MARK: - Properties
    private let busStopIcon = IconImageView(
        systemName: "mappin",
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


// MARK: - Setup
extension MHD_StationAnnotationView {
    
    private func setupMapAnnotationView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.neutral800
        layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 24),
            heightAnchor.constraint(equalToConstant: 24),
        ])
        
        
        busStopIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(busStopIcon)
        
        NSLayoutConstraint.activate([
            busStopIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            busStopIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        onTapGesture { [weak self] in
            guard let self else { return }
            if let annotation = self.annotation as? MHD_StationAnnotation {
                print(annotation.station.stationName ?? "")
                
                guard let vc = self.findViewController() else { return }
                print("Show popup okno so zastavkou a info (nazov zastavky a tlacidlom zvolit zastavku)")
                
                let popup = StationInformationPopupView(station: annotation.station)
                popup.show(on: vc)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
