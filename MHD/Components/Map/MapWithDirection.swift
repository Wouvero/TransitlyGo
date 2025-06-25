//
//
//
// Created by: Patrik Drab on 24/06/2025
// Copyright (c) 2025 MHD 
//
//         


import UIKit
import CoreData
import MapKit


class MapWithDirection: BaseMapView {
    private var stations: [MHD_DirectionStation] = []
    private var coordinates: [CLLocationCoordinate2D] = []
    private var routeOverlay: MKOverlay?
    
    var routeColor: UIColor = .systemBlue
    var routeLineWidth: CGFloat = 4
    
    
    init(stations: [MHD_DirectionStation], coordinates: [CLLocationCoordinate2D]) {
        self.stations = stations
        self.coordinates = coordinates
        super.init(frame: .zero)
        setupAnnotations()
        drawRoute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupAnnotations() {
        let existingAnnotations = mapView.annotations.filter {
            $0 is MHD_DirectionStationAnnotation
        }
        mapView.removeAnnotations(existingAnnotations)
        
        for station in stations {
            
            let stationLocation = station.stationInfo?.location
            
            guard let latitude = stationLocation?.latitude,
                  let longitude = stationLocation?.longitude else { continue }
           
            let coordinate = CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            )
                            
            let stationPin = MHD_DirectionStationAnnotation(
                station: station,
                coordinate: coordinate)
                
            mapView.addAnnotation(stationPin)
        }
    }
    
    private func drawRoute() {
        guard !coordinates.isEmpty else { return }
        clearRoute()
        setupRegion()
    }
    
    override func setupRegion() {
        guard !coordinates.isEmpty else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let newOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.routeOverlay = newOverlay
            mapView.addOverlay(newOverlay)
            
            let mapRect = newOverlay.boundingMapRect
            let padding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            mapView.setVisibleMapRect(mapRect, edgePadding: padding, animated: true)
        }
    }
    
    private func clearRoute() {
        mapView.removeOverlays(mapView.overlays)
    }
    
}


// MARK: - Public API
extension MapWithDirection {
    
    func updateRoute(with coordinates: [CLLocationCoordinate2D]) {
        self.coordinates = coordinates
        drawRoute()
    }
    
}


extension MapWithDirection {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DirectionStationAnnotation")
        
        if annotationView == nil {
            annotationView = MHD_DirectionStationAnnotationView(annotation: annotation, reuseIdentifier: "DirectionStationAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = routeColor
            renderer.lineWidth = routeLineWidth
            renderer.lineCap = .round
            renderer.lineJoin = .round
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}
