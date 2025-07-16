//
//
//
// Created by: Patrik Drab on 24/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import MapKit

protocol MapViewDelegate: AnyObject {
    func mapDidFinishRendering(_ mapView: MKMapView, fullyRendered: Bool)
}

class BaseMapView: UIView {
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    weak var delegate: MapViewDelegate?
    
    // Common initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Common setup methods
    private func setupMap() {
        setupMapView()
        setupMapConfiguration()
        setupLocationManager()
        checkLocationAuthorizationStatus()
    }
    
    private func setupMapView() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    private func setupMapConfiguration() {
        let configuration = MKStandardMapConfiguration()
        configuration.pointOfInterestFilter = .excludingAll
        configuration.showsTraffic = false
        mapView.preferredConfiguration = configuration
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
    }
    
    func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            break
            
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.userTrackingMode = .follow
            
        @unknown default:
            break
        }
    }
    
    // Methods to be overridden by subclasses
    func setupAnnotations() {
        // To be implemented by subclasses
    }
    
    func setupRegion() {
        // To be implemented by subclasses
    }
}

// MARK: - Common Delegate Extensions
extension BaseMapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationStatus()
    }
}

extension BaseMapView: MKMapViewDelegate {
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        delegate?.mapDidFinishRendering(mapView, fullyRendered: fullyRendered)
    }
}
