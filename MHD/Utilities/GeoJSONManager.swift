//
//
//
// Created by: Patrik Drab on 05/06/2025
// Copyright (c) 2025 MHD 
//
//         

import CoreLocation

struct GeoJSONManager {
    
    static func coordinatesToBinaryData(coordinates: [[Double]]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: coordinates, options: [])
    }
    
    static func binaryToCoordinates(data: Data) -> [CLLocationCoordinate2D]? {
        do {
            guard let coordinateArray = try JSONSerialization.jsonObject(with: data) as? [[Double]] else {
                return nil
            }
            
            return coordinateArray.compactMap { pair in
                guard pair.count == 2 else { return nil }
                let longitude = pair[0]
                let latitide = pair[1]
                return CLLocationCoordinate2D(latitude: latitide, longitude: longitude)
            }
        } catch {
            print("❌ Error converting binary data to coordinates: \(error)")
            return nil
        }
    }
}
