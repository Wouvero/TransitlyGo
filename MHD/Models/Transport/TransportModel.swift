//
//
//
// Created by: Patrik Drab on 26/04/2025
// Copyright (c) 2025 MHD 
//
//         

import Foundation

struct Line: Hashable {
    let name: String
    var warning: Bool = false
}

extension Line {
    static let allLines: [Line] = [
        Line(name: "1"),
        Line(name: "2"),
        Line(name: "4"),
        Line(name: "5"),
        Line(name: "7"),
        Line(name: "8"),
        Line(name: "10"),
        Line(name: "11"),
        Line(name: "12", warning: true),
        Line(name: "13"),
        Line(name: "14"),
        Line(name: "15"),
        Line(name: "17"),
        Line(name: "18"),
        Line(name: "19"),
        Line(name: "21"),
        Line(name: "22"),
        Line(name: "23"),
        Line(name: "24"),
        Line(name: "26"),
        Line(name: "27"),
        Line(name: "28"),
        Line(name: "29"),
        Line(name: "30"),
        Line(name: "32"),
        Line(name: "32A"),
        Line(name: "33"),
        Line(name: "35"),
        Line(name: "36"),
        Line(name: "37"),
        Line(name: "38"),
        Line(name: "39"),
        Line(name: "41"),
        Line(name: "42"),
        Line(name: "43"),
        Line(name: "44"),
        Line(name: "45"),
        Line(name: "46"),
        Line(name: "N1"),
        Line(name: "N2"),
        Line(name: "N3"),
        Line(name: "N4"),
        Line(name: "N5"),
        Line(name: "N6"),
        Line(name: "N7"),
        Line(name: "N8"),
        Line(name: "N9"),
        Line(name: "N10"),
        Line(name: "N11"),
        Line(name: "N12"),
        Line(name: "N13"),
        Line(name: "N14"),
        Line(name: "N16"),
        Line(name: "N17"),
        Line(name: "N18"),
        Line(name: "N19"),
        Line(name: "N20"),
        Line(name: "N21"),
        Line(name: "N22"),
        Line(name: "N23"),
        Line(name: "N24"),
        Line(name: "N25"),
        Line(name: "N26"),
        Line(name: "N27"),
        Line(name: "N28"),
    ]
}



/// Bus number
///   - busNumber: String
///   - destinations [Destination]
///   - isWarningMessage?: Bool
///   - warningMessage?: String
///
///  Destination
///   - destinationStation: String
///   - station: [Station]
///
/// Station
///   - stationName: String
///   - minutesToNextStation: Int
///   - isOnSign: Bool
///   - dayType: [DayType]
///
/// DayType
///  - type (workday, workHolliday, weekday)
///  - timeTable: [TimeTable]
///
/// TimeTable
///  - hour
///  - minutes []
///
///
///
/// StationLocation
///  - longitude
///  - latitude

// Top-level transport entity
struct TransportLine: Identifiable, Encodable, Hashable {
    let id: String
    let name: String
    let directions: [Direction]
    var alert: Alert?
}

struct Alert: Identifiable, Encodable, Hashable {
    let id: String
    let isActive: Bool
    let message: String
    let startTime: Date
    let endTime: Date
}

struct Direction: Identifiable, Encodable, Hashable {
    let id: String
    let destinationStationId: String       // StationInfo
    let stations: [Station]
}








//struct StationLocation: Identifiable, Encodable, Hashable {
//    let id: String
//    let longitude: Double
//    let latitude: Double
//}

struct Station: Identifiable, Encodable, Hashable {
    let id: String                  // Unique ID for this route station instance
    let stationInfoId: String       // Reference to StationInfo
    let directionSpecificInfo: DirectionSpecificInfo?
    let travelTimeToNextStop: Int?
    let isOnSign: Bool
    let transitSchedule: TransitSchedule
}

struct DirectionSpecificInfo: Encodable, Hashable {
    let longitude: Double?
    let latitude: Double?
    let platform: String?
}

struct StationInfo: Identifiable, Encodable, Hashable {
    let id: String
    let stationName: String
//    let longitude: Double?
//    let latitude: Double?
}










struct TransitSchedule: Identifiable, Encodable, Hashable {
    let id: String
    let dayTypeSchedule: [DayTypeSchedule]
}

struct DayTypeSchedule: Encodable, Hashable{
    let dayType: DayType
    let timeTable: [HourlyDeparture]
}

struct HourlyDeparture: Encodable, Hashable {
    let hour: Int
    let minutes: [MinuteInfo]
    
    private func formatMinutes(_ info: MinuteInfo) -> String {
        let formattedMinute = String(format: "%02d", info.minute)
        if let condition = info.condition {
            return "\(formattedMinute) \(condition.uppercased())"
        }
        return formattedMinute
    }
    
    var formatedMinutes: [String] {
        minutes.map { formatMinutes($0) }
    }
}

struct MinuteInfo: Encodable, Hashable {
    let minute: Int
    let condition: String?
}

enum DayType: Int, Encodable, Hashable {
    case workingSchoolDay = 0
    case workingHoliday = 1
    case weekendOrHoliday = 2
    
    var description: String {
        switch self {
        case .workingSchoolDay: return "Pracovný školský deň"
        case .workingHoliday: return "Pracovný prázdninový deň"
        case .weekendOrHoliday: return "Sobota, Nedeľa, Sviatok"
        }
    }
}

