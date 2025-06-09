//
//
//
// Created by: Patrik Drab on 08/06/2025
// Copyright (c) 2025 MHD 
//
//         



import UIKit
import CoreData

struct TransportLine: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    var directions: [Direction]
}

struct Direction: Identifiable, Codable, Equatable {
    let id: String
    var routeGeoJSONData: Data?
    var directionStations: [DirectionStation] = []
}

struct DirectionStation: Identifiable, Codable, Equatable {
    let id: String
    var isOnSign: Bool
    var travelTimeToNextStation: Int32? // Minutes
    var stationInfoId: String
}

// MARK: - Station Models
struct StationInfo: Identifiable, Codable, Equatable {
    let id: String
    var stationName: String
    var location: StationLocation
}

struct StationLocation: Codable, Equatable {
    var latitude: Double
    var longitude: Double
    var platform: String?
}


//// MARK: - Schedule Models
//struct DaytimeSchedule: Codable, Equatable {
//    var dayType: Int16
//    var timeTables: [TimeTable] = []
//}
//
//struct TimeTable: Codable, Equatable {
//    var hour: Int16 // 0-23
//    var minuteInfos: [MinuteInfo] = []
//}
//
//struct MinuteInfo: Codable, Equatable {
//    var minute: Int16 // 0-59
//    var condition: String? // "peak", "low-demand"
//}

