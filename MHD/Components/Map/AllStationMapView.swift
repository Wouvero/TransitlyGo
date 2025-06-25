//
//
//
// Created by: Patrik Drab on 24/06/2025
// Copyright (c) 2025 MHD 
//
//         


import UIKit
import MapKit
import CoreLocation


class AllStationMapView: BaseMapView {
    private var stations: [MHD_StationInfo] = [] {
        didSet {
            setupAnnotations()
            setupRegion()
        }
    }
    
    override func setupAnnotations() {
        // Removing existing anotation first
        let existingAnnotations = mapView.annotations.filter {
            $0 is MHD_StationAnnotation
        }
        mapView.removeAnnotations(existingAnnotations)
        
        for station in stations {
            
            let stationLocation = station.location
            
            guard let latitude = stationLocation?.latitude,
                  let longitude = stationLocation?.longitude else { continue }
            
            let coordinate = CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            )
            
            let stationPin = MHD_StationAnnotation(
                station: station,
                coordinate: coordinate)
            
            mapView.addAnnotation(stationPin)
        }
    }
    
    override func setupRegion() {
        guard !stations.isEmpty else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let cordinates = stations.compactMap { station -> CLLocationCoordinate2D? in
                guard let location = station.location else { return nil }
                
                return CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
            }
            
            guard !cordinates.isEmpty else { return }
            
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
            
            //self.defaultRegion = paddedRegion
            
            // Set the region with animation
            self.mapView.setRegion(paddedRegion, animated: true)
        }
    }

}


extension AllStationMapView {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "StationAnnotation"
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MHD_StationAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        annotationView.annotation = annotation
        annotationView.canShowCallout = false
        return annotationView
    }
    
    func setStations(_ stations: [MHD_StationInfo]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.stations = stations
        }
    }
    
}

