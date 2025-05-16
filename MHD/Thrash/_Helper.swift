////
////
////
//// Created by: Patrik Drab on 27/04/2025
//// Copyright (c) 2025 MHD
////
////
//
//
//private func highlightCurrentHourCell() {
////        let formatter = DateFormatter()
////        formatter.dateStyle = .none
////        formatter.timeStyle = .medium
////
////        let currentDate = Date()
//    let calendar = Calendar.current
//    let components = calendar.dateComponents([.hour, .minute, .second], from: Date())
//    
//    
//    let hour = components.hour ?? 0
//    let minute = components.minute ?? 0
//    let second = components.second ?? 0
//    
//    print("Hour: \(hour), Minute: \(minute), Second: \(second)")
//    
//    guard let matchingIndex = data.firstIndex(where: { $0.hour == hour }) else {
//        print("No matching hour found in data")
//        return
//    }
//    
//    activeHourIndex = matchingIndex
//    
//        let indexPath = IndexPath(row: matchingIndex, section: 0)
//
//        //departureTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
//
//        let cell = departureTableView.cellForRow(at: indexPath) as? DepartureTableViewCell
//        print(cell ?? "No cell")
//        if let matchingIndex = data.firstIndex(where: { $0.hour == hour }) {
//
//            let indexPath = IndexPath(row: matchingIndex, section: 0)
////
////            print("Found matching hour at index: \(matchingIndex)")
////            print(data[matchingIndex])
//
//            // 1. Get the cell and update its appearance
//                if let cell = departureTableView.cellForRow(at: indexPath) as? DepartureTableViewCell {
//                    // Update to "active" appearance
//                    //cell.updateCell()
//                    //cell.setActiveAppearance(true)
//
//                    // Reset previous active cell if needed
//                    //resetPreviousActiveCell(currentIndex: matchingIndex)
//                }
//
//                // 2. Scroll to make it visible
////                departureTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
//
//                // 3. (Optional) Highlight in data source
//                // You might want to add this to your cell configuration
////                dataSource.tableView(departureTableView, willDisplay: cell, forRowAt: indexPath)
//        } else {
//            print("No matching hour found in data")
//        }
    
    
    
    
    //print("curent time: \(timeString)")
    
    // Update every second
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.activateDepartureCell()
//        }
//}




//import Foundation
//import CoreLocation
//
//func generateAlertMessage(for transportLineName: String) -> Alert {
//    let messages = [
//        "Delay due to technical issues",
//        "Route diversion in effect",
//        "Reduced service today",
//        "Last stop changed temporarily"
//    ]
//    
//    return Alert(
//        id: "alert_for_bus-\(transportLineName)",
//        isActive: true,
//        message: messages.randomElement()!,
//        startTime: Date(),
//        endTime: Calendar.current.date(byAdding: .hour, value: Int.random(in: 1...6), to: Date())!
//    )
//}
//
//func generateStationLocation(for stationName: String, cityCenter: (latitude: Double, longitude: Double)? = nil) -> StationLocation {
//    
//    if let center = cityCenter {
//        // Generate locations within 20km of city center
//        let radius = Double.random(in: 0...20_000) // meters
//        let angle = Double.random(in: 0..<2 * .pi)
//        
//        let earthRadius = 6_371_000.0 // meters
//        let lat = center.latitude + (radius / earthRadius) * (180 / .pi) * cos(angle)
//        let lon = center.longitude + (radius / earthRadius) * (180 / .pi) * sin(angle) / cos(center.latitude * .pi/180)
//        
//        return StationLocation(id: "geographic_location_for_\(stationName)", longitude: lon, latitude: lat)
//    } else {
//        // Fallback to worldwide random
//        return StationLocation(
//            id: "geographic_location_for_\(stationName)",
//            longitude: Double.random(in: -180...180),
//            latitude: Double.random(in: -90...90)
//        )
//    }
//}
//
//func generateTransportLine(for transportLineName: String) -> TransportLine {
//    let generatedAlert = Double.random(in: 0...1) < 0.1 ? generateAlertMessage(for: transportLineName) : nil
//    let numberOfStations = Int.random(in: 8...15)
//    let destinations = ["North", "South", "East", "West", "Central"].shuffled()
//    
//    let generatedDirection: [Direction] = [
//        generateDirection(
//            for: transportLineName,
//            destination: "\(destinations[0]) station",
//            numberOfStations: numberOfStations
//        ),
//        generateDirection(
//            for: transportLineName,
//            destination: "\(destinations[1]) station",
//            numberOfStations: numberOfStations
//        )
//    ]
//    
//    return TransportLine(
//        id: "transport_line_for_bus-\(transportLineName)",
//        name: transportLineName,
//        directions: generatedDirection,
//        alert: generatedAlert
//    )
//}
//
//func generateDirection(for transportLineName: String, destination: String, numberOfStations: Int) -> Direction {
//    
//    var generatedStations: [Station] = []
//    
//    for index in 1...numberOfStations {
//        generatedStations.append(generateStation(indexOfStation: index, numberOfStations: numberOfStations, for: transportLineName))
//    }
//    
//    return Direction(
//        id: "direction_\(destination)_for_bus-\(transportLineName)",
//        stationName: destination,
//        stations: generatedStations
//    )
//}
//
//func generateStation(indexOfStation: Int, numberOfStations: Int, for transportLineName: String) -> Station {
//    let cityCenter = (latitude: 48.148, longitude: 17.107)
//    
//    return Station(
//        id: "station_\(indexOfStation)_for_bus-\(transportLineName)",
//        stationName: "Station \(indexOfStation)",
//        travelTimeToNextStop: indexOfStation == numberOfStations ? nil : Int.random(in: 1...10),
//        isOnSign:  Double.random(in: 0...1) < 0.05,
//        transitSchedule: generateTransitSchedule(for: transportLineName, indexOfStation: indexOfStation),
//        location: generateStationLocation(for: "Station \(indexOfStation)", cityCenter: cityCenter)
//    )
//}
//
//func generateTransitSchedule(for transportLineName: String, indexOfStation: Int) -> TransitSchedule {
//    let workingSchoolDay = generateDayTypeSchedule(for: .workingSchoolDay)
//    let workingHoliday = generateDayTypeSchedule(for: .workingHoliday)
//    let weekendOrHoliday = generateDayTypeSchedule(for: .weekendOrHoliday)
//    
//    return TransitSchedule(
//        id: "transit_schedule_for_bus-\(transportLineName)_and_station\(indexOfStation)",
//        dayTypeSchedule: [
//            workingSchoolDay,
//            workingHoliday,
//            weekendOrHoliday
//        ]
//    )
//}
//
//func generateDayTypeSchedule(for dayType: DayType) -> DayTypeSchedule {
//    var generatedTimeTable: [HourlyDeparture] = []
//    
//    for hour in 5...22 {
//        generatedTimeTable.append(generateTimeTable(hour: hour, dayType: dayType))
//    }
//    
//    return DayTypeSchedule(dayType: dayType, timeTable: generatedTimeTable)
//}
//
//func generateTimeTable(hour: Int, dayType: DayType) -> HourlyDeparture {
//    return HourlyDeparture(hour: hour, minutes: generateMinutesInfo(hour: hour, dayType: dayType))
//}
//
//func generateMinutesInfo(hour: Int, dayType: DayType) -> [MinuteInfo] {
//    var generatedMinuteInfo: [MinuteInfo] = []
//    let count: Int
//    
//    switch dayType {
//    case .workingSchoolDay:
//        count = Int.random(in: 1...6)
//    case .workingHoliday:
//        count = Int.random(in: 1...4)
//    case .weekendOrHoliday:
//        count = Int.random(in: 1...2)
//    }
//    
//    var minutes = Set<Int>()
//    while minutes.count < count {
//        let minute = Int.random(in: 0...59)
//        minutes.insert(minute)
//    }
//    
//    for minute in minutes.sorted() {
//        generatedMinuteInfo.append(MinuteInfo(minute: minute, condition: nil))
//    }
//    
//    return generatedMinuteInfo
//}
//
//
//func generateDummyData() {
//    var data: [TransportLine] = []
//    
//    for transportLineIndex in 1...20 {
//        data.append(generateTransportLine(for: "\(transportLineIndex)"))
//    }
//    
//    do {
//        // 1. Convert to JSON data
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        let jsonData = try encoder.encode(data)
//        
//        // 2. Encode JSON to Base64
//        let base64String = jsonData.base64EncodedString()
//        
//        // 3. Get documents directory URL
//        let documentsDirectory = try FileManager.default.url(
//            for: .documentDirectory,
//            in: .userDomainMask,
//            appropriateFor: nil,
//            create: true
//        )
//        
//        // 4. Create file URL
//        let fileURLForJson = documentsDirectory.appendingPathComponent("transport_data.json")
//        let fileURLForBase64 = documentsDirectory.appendingPathComponent("transport_data.txt")
//        
//        // 5. Write to file
//        try jsonData.write(to: fileURLForJson)
//        try base64String.write(to: fileURLForBase64, atomically: true, encoding: .utf8)
//        
//        print("✅ Successfully saved JSON to: \(fileURLForJson.path)")
//    } catch {
//        print("❌ Error saving: \(error.localizedDescription)")
//    }
//}
