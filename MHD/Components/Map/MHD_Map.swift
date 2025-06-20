//
//
//
// Created by: Patrik Drab on 05/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import MapKit

/// 1. Show all stations (when click on station show popup window)
/// 2. Show specific route (with stations)
///     - show route indicator
/// 3. Click on position button
///     - no authorization (icon/slash and show popup with description)
///     - center (after that icon .fill)
///     - leave (after that .fill)

class MHD_MapView: UIView {
    // MARK: - Variables
    // init map
    internal let mapView = MKMapView()
    // init location manager user colection
    let locationManager = CLLocationManager()
    
    let locationButton = CustomButton(
        type: .iconOnly(
            iconName: "location.slash.fill",
            iconColor: .neutral,
            iconSize: 20
        ),
        style: .filled(backgroundColor: .primary500, cornerRadius: 8),
        size: .auto(pTop: 10, pTrailing: 10, pBottom: 10, pLeading: 10)
    )
    
    // MARK: - Delegate
    weak var delegate: MHD_MapViewDelegate?
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupMapView()
        //setupLocationButton()
        setupMapConfiguration()
        setupLocationManager()
        //setupRegion()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        translatesAutoresizingMaskIntoConstraints = false
        setupMapView()
        //setupLocationButton()
        setupMapConfiguration()
        setupLocationManager()
        //setupRegion()
    }
    
    deinit {
        mapView.delegate = nil
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}


// MARK: - Setup
extension MHD_MapView {
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Configure map appearance
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        //mapView.userTrackingMode = .follow  // this should be called after we got authorization
        mapView.delegate = self
    }
    
    private func setupLocationButton() {
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.addSubview(locationButton)
        
        NSLayoutConstraint.activate([
            locationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16),
            locationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupMapConfiguration() {
        let configuration = delegate?.setupMapConfiguration() ?? defaultMapConfiguration()
        mapView.preferredConfiguration = configuration
    }
    
    private func defaultMapConfiguration() -> MKMapConfiguration {
        let configuration = MKStandardMapConfiguration()
        configuration.pointOfInterestFilter = .excludingAll
        configuration.showsTraffic = false
        return configuration
    }
    
    private func setupRegion() {
        let region = delegate?.setupRegion() ?? defaultRegion()
        mapView.regionThatFits(region) // Ensure region is valid
        mapView.setRegion(region, animated: false) // false for non-animated initial setup
    }
    
    private func defaultRegion() -> MKCoordinateRegion {
        let presovCoordinate = CLLocationCoordinate2D(latitude: 48.9978, longitude: 21.2409)
        
        return MKCoordinateRegion(
            center: presovCoordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
    }
    
    private func centerRagionOnUserLocation() {
        guard let userLocation = mapView.userLocation.location else { return }
        let region = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        
        mapView.setRegion(region, animated: true)
    }
    
    private func isUserLocationVisible() -> Bool {
        guard let userLocation = mapView.userLocation.location else { return false }
        
        let userPoint = MKMapPoint(userLocation.coordinate)
        let visibleMapRect = mapView.visibleMapRect
        
        return visibleMapRect.contains(userPoint)
    }
    
}


// MARK: - CLLocationManagerDelegate
extension MHD_MapView: CLLocationManagerDelegate {
    
    private func setupLocationManager() {
        locationManager.delegate = self
        checkLocationAuthorizationStatus()
    }
    
    // .notDetermined
    //  - location
    //  - requestWhenInUseAuthorization
    // .restricted, .denied
    //  - location.slash.fill
    //  - Show modal information that you need allow location
    // .authorized, .authorizedAlways, .authorizedWhenInUse
    //  - isUserLocationVisible ? location.fill : location
    //
    private func updateLocationButton() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationButton.setButtonIcon("location")
            locationButton.onTapGesture { [weak self] in
                guard let self else { return }
                print("Allow location")
                self.locationManager.requestWhenInUseAuthorization()
            }
        case .restricted, .denied:
            locationButton.setButtonIcon("location.slash.fill")
            locationButton.onTapGesture { //[weak self] in
                //guard let self else { return }
                print("Show modal information that you need allow location")
            }
            break
            
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            locationButton.setButtonIcon(
                isUserLocationVisible() ? "location.fill" : "location"
            )
            locationButton.onTapGesture { [weak self] in
                guard let self else { return }
                self.centerRagionOnUserLocation()
            }
            
        @unknown default:
            locationButton.setButtonIcon("location.slash.fill")
            break
        }
    }
    
    func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            updateLocationButton()
            break
            
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            updateLocationButton()
            // Only enable tracking after we have authorization
            mapView.userTrackingMode = .follow
            
        @unknown default:
            updateLocationButton()
            break
        }
    }
    
    // If authorization status change, this method is called
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //print("[CLLocationManagerDelegate] - didChangeAuthorization")
        updateLocationButton()
        checkLocationAuthorizationStatus()
    }
    
}


// MARK: - MKMapViewDelegate
extension MHD_MapView: MKMapViewDelegate {
  
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            renderer.lineCap = .round
            renderer.lineJoin = .round
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("[MKMapViewDelegate] - regionDidChangeAnimated")
        updateLocationButton()
    }
    
}


// MARK: - Public API
extension MHD_MapView {}
