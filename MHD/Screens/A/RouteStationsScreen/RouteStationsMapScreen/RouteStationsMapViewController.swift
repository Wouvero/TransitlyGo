//
//
//
// Created by: Patrik Drab on 05/06/2025
// Copyright (c) 2025 MHD 
//
//

import UIKit
import CoreLocation
import MapKit


class RouteStationsMapViewController: UIViewController, MHD_NavigationDelegate, MapViewDelegate {
  
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
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingLabel = UILabel()
    private let loadingContainer = UIView()

    private var loadingFallbackTimer: Timer?
    
    private var mapView: MapWithDirection!
    
    private let direction: MHD_Direction
    private var stations: [MHD_DirectionStation] {
        let station = direction.directionStations?.allObjects as? [MHD_DirectionStation] ?? []
        let sortedStation = station.sorted { $0.sortIndex < $1.sortIndex }
        return sortedStation
    }

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
        setupLoadingView()
  
        startLoadingFallbackTimer()
    }
    
    private func setupLoadingView() {
        loadingContainer.backgroundColor = .systemBackground
        loadingContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingContainer)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        loadingContainer.addSubview(loadingIndicator)
        
        loadingLabel.text = "Map is loading, please wait..."
        loadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingContainer.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            loadingContainer.topAnchor.constraint(equalTo: view.topAnchor),
            loadingContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingContainer.centerYAnchor, constant: -20),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 8),
            loadingLabel.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
        ])
    }
    
    private func setupMapView() {
        mapView = MapWithDirection(stations: stations, coordinates: coordinates)
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func mapDidFinishRendering(_ mapView: MKMapView, fullyRendered: Bool) {
        hideLoadingView()
    }

}

extension RouteStationsMapViewController {
    private func startLoadingFallbackTimer() {
        // Fallback in case map rendering never completes
        loadingFallbackTimer = Timer.scheduledTimer(
            withTimeInterval: 3.0,
            repeats: false
        ) { [weak self] _ in
            self?.hideLoadingView()
        }
    }
    
    private func hideLoadingView() {
        // Cancel the fallback timer
        loadingFallbackTimer?.invalidate()
        loadingFallbackTimer = nil
        
        UIView.animate(withDuration: 0.3) {
            self.loadingContainer.alpha = 0
        } completion: { _ in
            self.loadingContainer.removeFromSuperview()
        }
    }
}





//    private func setupRegion() {
//        let coordinates = stations.compactMap { station -> CLLocationCoordinate2D? in
//            guard let location = station.stationInfo?.location else { return nil }
//            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//        }
//
//        guard !coordinates.isEmpty else { return }
//
//        DispatchQueue.main.async { [weak self] in
//            guard let self else { return }
//
//            // Calculate the region that fits all points
//            var minLat = coordinates[0].latitude
//            var maxLat = coordinates[0].latitude
//            var minLon = coordinates[0].longitude
//            var maxLon = coordinates[0].longitude
//
//            for coordinate in coordinates {
//                minLat = min(minLat, coordinate.latitude)
//                maxLat = max(maxLat, coordinate.latitude)
//                minLon = min(minLon, coordinate.longitude)
//                maxLon = max(maxLon, coordinate.longitude)
//            }
//
//            // Calculate center and span
//            let center = CLLocationCoordinate2D(
//                latitude: (minLat + maxLat) / 2,
//                longitude: (minLon + maxLon) / 2
//            )
//
//            let span = MKCoordinateSpan(
//                latitudeDelta: (maxLat - minLat) * 1.5,
//                longitudeDelta: (maxLon - minLon) * 1.5
//            )
//
//            var region = MKCoordinateRegion(center: center, span: span)
//            region = self.mapView.regionThatFits(region)
//
//            // Apply padding
//            let padding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
//            var paddedRegion = self.mapView.regionThatFits(region)
//            paddedRegion.span.latitudeDelta += self.mapView.region.span.latitudeDelta * Double(padding.top + padding.bottom) / Double(self.mapView.bounds.height)
//            paddedRegion.span.longitudeDelta += self.mapView.region.span.longitudeDelta * Double(padding.left + padding.right) / Double(self.mapView.bounds.width)
//
//            // Set the region with animation
//            self.mapView.setRegion(paddedRegion, animated: true)
//        }
//    }
