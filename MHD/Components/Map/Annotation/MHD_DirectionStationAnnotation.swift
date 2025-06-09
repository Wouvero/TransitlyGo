//
//
//
// Created by: Patrik Drab on 07/06/2025
// Copyright (c) 2025 MHD 
//
//         

import MapKit

class MHD_DirectionStationAnnotation: MKPointAnnotation {
    var station: MHD_DirectionStation
    
    init(station: MHD_DirectionStation, coordinate: CLLocationCoordinate2D) {
        self.station = station
        super.init()
        self.coordinate = coordinate
    }
}
