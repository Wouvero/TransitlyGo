//
//
//
// Created by: Patrik Drab on 05/06/2025
// Copyright (c) 2025 MHD 
//
//

import CoreData


struct DummyDataManager {
    static let context: NSManagedObjectContext = {
        MHD_CoreDataManager.shared.viewContext
    }()
    
    static func initialData() {
        MHD_TransportLine.deleteAll(in: context)
        MHD_StationInfo.deleteAll(in: context)
        
        createStationInfos(allStationInfos)
        
        createTransportLines([transportLine_4, transportLine_8, transportLine_38])
        
   
        do {
            try context.save()
        } catch {
            print("Failed to save TransportLine: \(error)")
        }
    }
    
    private static func createStationInfos(_ stationInfos: [StationInfo]) {
        for stationInfo in stationInfos {
            let stationInfoEntity = MHD_StationInfo(context: context)
            stationInfoEntity.id = stationInfo.id
            stationInfoEntity.stationName = stationInfo.stationName
            
            let stationLocationEntity = MHD_StationLocation(context: context)
            stationLocationEntity.latitude = stationInfo.location.latitude
            stationLocationEntity.longitude = stationInfo.location.longitude
            stationInfoEntity.location = stationLocationEntity
        }
    }

    private static func createTransportLines(_ transportLines: [TransportLine]) {
        for (index, transportLine) in transportLines.enumerated() {
            
            
            let transportLineEntity = MHD_TransportLine(context: context)
            transportLineEntity.id = transportLine.id
            transportLineEntity.name = transportLine.name
            transportLineEntity.sortIndex = Int64(index)
            
            
            createDirections(transportLine.directions, for: transportLineEntity)
        }
    }
    
    private static func createDirections(_ directions: [Direction], for transportLineEntity: MHD_TransportLine) {
        for (directionIndex, direction) in directions.enumerated() {
            let directionEntity = MHD_Direction(context: context)
            directionEntity.id = direction.id
            directionEntity.routeGeoJSONData = direction.routeGeoJSONData
            //print(direction.routeGeoJSONData ?? "No")
            directionEntity.transportLine = transportLineEntity
            directionEntity.sortIndex = Int16(directionIndex)
            
            createDirectionStations(direction.directionStations, for: directionEntity)
        }
    }
    
    private static func createDirectionStations(_ directionStations: [DirectionStation], for directionEntity: MHD_Direction) {
        for (directionStationsIndex, station) in directionStations.enumerated() {
            let stationEntity = MHD_DirectionStation(context: context)
            stationEntity.id = station.id
            stationEntity.isOnSign = station.isOnSign
            stationEntity.sortIndex = Int32(directionStationsIndex)
            stationEntity.direction = directionEntity
            
            if let time = station.travelTimeToNextStation {
                stationEntity.travelTimeToNextStation = time
            }
            
            // ---- Schedules
            createDummySchedule(for: stationEntity, in: context)
            // ---- Get Station Info
            
            guard let stationInfoEntity = MHD_StationInfo.getStationInfo(withId: station.stationInfoId, in: context) else { continue }

            stationEntity.stationInfo = stationInfoEntity
            
            if directionStationsIndex == directionStations.count - 1 {
                directionEntity.endDestination = stationInfoEntity
            }
        }
    }
    

    private static func createDummySchedule(for directionStation: MHD_DirectionStation, in context: NSManagedObjectContext) {

        // Create schedules for different day types
        let dayTypes: [(type: Int16, name: String)] = [
            (0, "Weekday"),
            (1, "Saturday"),
            (2, "Sunday")
        ]
        
        for dayType in dayTypes {
            let daytimeScheduleEntity = MHD_DaytimeSchedule(context: context)
            daytimeScheduleEntity.dayType = dayType.type
            daytimeScheduleEntity.directionStation = directionStation
            
            // Create hourly departures (6AM to 10PM)
            for hour in 6...22 {
                let timeTableEntity = MHD_Hour(context: context)
                timeTableEntity.hourInfo = Int16(hour)
                timeTableEntity.daytimeSchedule = daytimeScheduleEntity
                
                // Create minute departures (random 2-4 departures per hour)
                let departureCount = Int.random(in: 2...4)
                let minuteSteps = 60 / departureCount
                
                for i in 0..<departureCount {
                    let minuteInfoEntity = MHD_Minute(context: context)
                    let baseMinute = i * minuteSteps
                    let minuteVariance = Int.random(in: -5...5) // Random variance
                    let actualMinute = max(0, min(59, baseMinute + minuteVariance))
                    
                    minuteInfoEntity.minuteInfo = Int16(actualMinute)
                    minuteInfoEntity.condition = Double.random(in: 0...1) < 0.02 ? ["D", "C", "A"].randomElement()! : nil
                    minuteInfoEntity.hour = timeTableEntity
                }
            }
        }
    }
}
