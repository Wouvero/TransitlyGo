//
//
//
// Created by: Patrik Drab on 05/06/2025
// Copyright (c) 2025 MHD 
//
//         

import MapKit


protocol MHD_MapViewDelegate: AnyObject {
    func setupMapConfiguration() -> MKMapConfiguration?
    func setupRegion() -> MKCoordinateRegion?
    func drawAnnotationsRoute() -> Bool
}

extension MHD_MapViewDelegate {
    
    func setupMapConfiguration() -> MKMapConfiguration? {
        return nil
    }
    
    func setupRegion() -> MKCoordinateRegion? {
        return nil
    }
    
    func drawAnnotationsRoute() -> Bool {
        return false
    }
    
}
