//
//
//
// Created by: Patrik Drab on 29/04/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import CoreData

extension CDTransportLine {
    static func generateDummyData(in context: NSManagedObjectContext) {
        // Clear existing data first (optional)
        deleteAllTransportLines(in: context)
        
        let transportLines = [
            (indexPosition: Int64(0), id: "TS_1", name: "1"),
            (indexPosition: Int64(1), id: "TS_2", name: "2"),
            (indexPosition: Int64(2), id: "TS_4", name: "4"),
            (indexPosition: Int64(3), id: "TS_5", name: "5"),
            (indexPosition: Int64(4), id: "TS_7", name: "7"),
            (indexPosition: Int64(5), id: "TS_10", name: "10"),
            (indexPosition: Int64(6), id: "TS_11", name: "11"),
            (indexPosition: Int64(7), id: "TS_12", name: "12"),
            (indexPosition: Int64(8), id: "TS_13", name: "13"),
            (indexPosition: Int64(9), id: "TS_14", name: "14"),
            (indexPosition: Int64(10), id: "TS_15", name: "15"),
        ]
        
        let stationInfoData = [
            (id: "STI_1", stationName: "Main Central Station"),
            (id: "STI_2", stationName: "Riverfront Plaza"),
            (id: "STI_3", stationName: "University District"),
            (id: "STI_4", stationName: "Commerce Square"),
            (id: "STI_5", stationName: "Parkview Terminal"),
            (id: "STI_6", stationName: "West End Crossing"),
            (id: "STI_7", stationName: "Hillside Junction"),
            (id: "STI_8", stationName: "Downtown Exchange"),
            (id: "STI_9", stationName: "North Quarter Hub"),
            (id: "STI_10", stationName: "Southside Transit Center")
        ]
        
        var createdStationInfo: [CDStationInfo] = []
        for stationInfo in stationInfoData {
            let newStationInfo = CDStationInfo(context: context)
            newStationInfo.id = stationInfo.id
            newStationInfo.stationName = stationInfo.stationName
            createdStationInfo.append(newStationInfo)
        }
        
        
        //var createdLines: [CDTransportLine] = []
        for transportLine in transportLines {
            let newTransportLine = CDTransportLine(context: context)
            newTransportLine.indexPosition = transportLine.indexPosition
            newTransportLine.id = transportLine.id
            newTransportLine.name = transportLine.name
            
            //createdLines.append(newTransportLine)
            
            let directions = [
                (
                    id: "\(newTransportLine)_\(stationInfoData[0].stationName)",
                    destination: createdStationInfo[0],
                    isOutbound: true
                ),
                (
                    id: "\(newTransportLine)_\(stationInfoData[9].stationName)",
                    destination: createdStationInfo[9],
                    isOutbound: false
                ),
            ]
            
            for direction in directions {
                let newDirection = CDDirection(context: context)
                newDirection.id = direction.id
                newDirection.line = newTransportLine
                newDirection.destinationStation = direction.destination
                newDirection.destinationStationId = direction.destination.id
                
                for (index, stationIndex) in createdStationInfo.enumerated() {
                    let newStation = CDStation(context: context)
                    newStation.id = "ST_\(UUID().uuidString)"
                    newStation.travelTimeToNextStop = (index == createdStationInfo.count - 1) ? 0 : Int64.random(in: 1...5)
                    newStation.isOnSign = Double.random(in: 0...1) < 0.1 ? true : false
                    newStation.stationInfo = stationIndex
                    newStation.direction = newDirection
                    
                    let directionInfo = CDDirectionSpecificInfo(context: context)
                    directionInfo.latitude = Double.random(in: 48.997...49.007)
                    directionInfo.longitude = Double.random(in: 21.230...21.250)
                    
                    directionInfo.station = newStation
                    
                    
                    newDirection.addToStations(newStation)
                    createDummySchedule(for: newStation, in: context)
                }
            }
        }
    }
    
    
    private static func createDummySchedule(for station: CDStation, in context: NSManagedObjectContext) {
        let schedule = CDTransitSchedule(context: context)
        schedule.id = "SCH_\(UUID().uuidString)"
        schedule.station = station
        
        // Create schedules for different day types
        let dayTypes: [(type: Int16, name: String)] = [
            (0, "Weekday"),
            (1, "Saturday"),
            (2, "Sunday")
        ]
        
        for dayType in dayTypes {
            let dayTypeSchedule = CDDayTypeSchedule(context: context)
            dayTypeSchedule.dayType = dayType.type
            dayTypeSchedule.transitSchedule = schedule
            
            // Create hourly departures (6AM to 10PM)
            for hour in 6...22 {
                let hourlyDeparture = CDHourlyDeparture(context: context)
                hourlyDeparture.hour = Int16(hour)
                hourlyDeparture.dayTypeSchedule = dayTypeSchedule
                
                // Create minute departures (random 2-4 departures per hour)
                let departureCount = Int.random(in: 2...4)
                let minuteSteps = 60 / departureCount
                
                for i in 0..<departureCount {
                    let minuteInfo = CDMinuteInfo(context: context)
                    let baseMinute = i * minuteSteps
                    let minuteVariance = Int.random(in: -5...5) // Random variance
                    let actualMinute = max(0, min(59, baseMinute + minuteVariance))
                    
                    minuteInfo.minute = Int16(actualMinute)
                    minuteInfo.condition = Double.random(in: 0...1) < 0.05 ? ["D", "C", "A"].randomElement()! : nil
                    minuteInfo.hourlyDeparture = hourlyDeparture
                }
            }
        }
    }
    
    
    
    
    private static func deleteAllTransportLines(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDTransportLine.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to clear existing data: \(error)")
        }
    }
    
    private static func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
                context.rollback()
            }
        }
    }
}
