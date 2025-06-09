//
//
//
// Created by: Patrik Drab on 05/06/2025
// Copyright (c) 2025 MHD 
//
//

import UIKit
import CoreLocation

class RouteStationsMapViewController: UIViewController, MHD_NavigationDelegate, MHD_MapViewDelegate {
    var contentLabelText: NSAttributedString {
        let transportLineName = direction.transportLine?.name ?? ""
        let destinationStationName = direction.endDestination?.stationName ?? ""
        
        return NSAttributedStringBuilder()
            .add(text: "Trasa zastávok na linke č.", attributes: [.font: UIFont.interSemibold(size: 16)])
            .add(text: "\(transportLineName) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .add(text: "smer ", attributes: [.font: UIFont.interRegular(size: 16)])
            .add(text: "\(destinationStationName) ", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    private let mapView = MHD_MapWithDirection()
    
    private let direction: MHD_Direction
    private var stations: [MHD_DirectionStation] {
        let station = direction.directionStations?.allObjects as? [MHD_DirectionStation] ?? []
        let sortedStation = station.sorted { $0.sortIndex < $1.sortIndex }
        return sortedStation
    }
//    private var stationInfos: [MHD_StationInfo] {
//        let stationInfo = stations.compactMap { $0.stationInfo }
//        return stationInfo
//    }
    private var coordinates: [CLLocationCoordinate2D] {
        if let data = direction.routeGeoJSONData {
            return GeoJSONManager.binaryToCoordinates(data: data) ?? []
        } else {
            return []
        }
    }
    
    init(direction: MHD_Direction) {
        self.direction = direction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupStations()
    }
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupStations() {
        mapView.setStations(stations)
        mapView.setCordinates(coordinates)
        mapView.drawRoute()
    }
}


