//
//
//
// Created by: Patrik Drab on 04/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import MapKit

class MHD_StationAnnotation: MKPointAnnotation {
    var station: MHD_StationInfo
    
    init(station: MHD_StationInfo, coordinate: CLLocationCoordinate2D) {
        self.station = station
        super.init()
        self.coordinate = coordinate
    }
}

