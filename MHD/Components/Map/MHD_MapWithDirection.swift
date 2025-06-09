//
//
//
// Created by: Patrik Drab on 07/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import MapKit

class MHD_MapWithDirection: MHD_MapView {
    // MARK: Properties
    private var stations: [MHD_DirectionStation] = [] {
        didSet {
            setupStationPins()
            //setupRegion()
        }
    }
    
    private var coordinates: [CLLocationCoordinate2D] = []
    
    private var routeOverlay: MKOverlay?
    
    
    override init() {
        super.init()
    }
    
    init(coordinates: [CLLocationCoordinate2D], routeOverlay: MKOverlay? = nil) {
        self.coordinates = coordinates
        self.routeOverlay = routeOverlay
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension MHD_MapWithDirection {
    
    private func setupStationPins() {
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
    
    private func setupRegion() {
        guard !stations.isEmpty else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let cordinates = stations.compactMap { station -> CLLocationCoordinate2D? in
                guard let location = station.stationInfo?.location else { return nil }

                return CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
            }
            
            // Calculate the region that fits all points
            var minLat = cordinates[0].latitude
            var maxLat = cordinates[0].latitude
            var minLon = cordinates[0].longitude
            var maxLon = cordinates[0].longitude
            
            for cordinate in cordinates {
                minLat = min(minLat, cordinate.latitude)
                maxLat = max(maxLat, cordinate.latitude)
                minLon = min(minLon, cordinate.longitude)
                maxLon = max(maxLon, cordinate.longitude)
            }
            
            // Calculate center and span
            let center = CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLon + maxLon) / 2
            )
            
            let span = MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) * 1.5,
                longitudeDelta: (maxLon - minLon) * 1.5
            )
            
            var region = MKCoordinateRegion(center: center, span: span)
            region = self.mapView.regionThatFits(region)
            
            // Apply padding
            let padding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            var paddedRegion = self.mapView.regionThatFits(region)
            paddedRegion.span.latitudeDelta += self.mapView.region.span.latitudeDelta * Double(padding.top + padding.bottom) / Double(self.mapView.bounds.height)
            paddedRegion.span.longitudeDelta += self.mapView.region.span.longitudeDelta * Double(padding.left + padding.right) / Double(self.mapView.bounds.width)
            
            // Set the region with animation
            self.mapView.setRegion(paddedRegion, animated: true)
        }
    }
    
    private func clearRoute() {
        mapView.removeOverlays(mapView.overlays)
    }
    
}


// MARK: - MKMapViewDelegate
extension MHD_MapWithDirection {
    
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
    
}


// MARK: OPEN API
extension MHD_MapWithDirection {

    func setStations(_ stations: [MHD_DirectionStation]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.stations = stations
        }
    }
    
    func setCordinates(_ cordinates: [CLLocationCoordinate2D]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.coordinates = cordinates
        }
    }
    
    func drawRoute() {
        // Clear previous overlays if exists
        clearRoute()
        
        // Create new overlay
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let newOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.routeOverlay = newOverlay
            mapView.addOverlay(newOverlay)
            
            // Get the bounding rect that includes both the route and current visible area
            let mapRect = newOverlay.boundingMapRect
//            if let userLocation = mapView.userLocation.location {
//                let userPoint = MKMapPoint(userLocation.coordinate)
//                mapRect = mapRect.union(MKMapRect(origin: userPoint, size: MKMapSize(width: 0, height: 0)))
//            }
            
            let padding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            mapView.setVisibleMapRect(mapRect, edgePadding: padding, animated: true)
        }
    }

}
