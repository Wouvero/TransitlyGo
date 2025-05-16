//
//
//
// Created by: Patrik Drab on 29/04/2025
// Copyright (c) 2025 MHD 
//
//         

//

import Foundation
import CoreData


extension CDStationInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDStationInfo> {
        return NSFetchRequest<CDStationInfo>(entityName: "CDStationInfo")
    }

    @NSManaged public var id: String?
    @NSManaged public var stationName: String?
    @NSManaged public var stations: NSSet?
    @NSManaged public var directions: NSSet?

}

// MARK: Generated accessors for stations
extension CDStationInfo {

    @objc(addStationsObject:)
    @NSManaged public func addToStations(_ value: CDStation)

    @objc(removeStationsObject:)
    @NSManaged public func removeFromStations(_ value: CDStation)

    @objc(addStations:)
    @NSManaged public func addToStations(_ values: NSSet)

    @objc(removeStations:)
    @NSManaged public func removeFromStations(_ values: NSSet)

}

// MARK: Generated accessors for destinationStation
extension CDStationInfo {

    @objc(addDestinationStationObject:)
    @NSManaged public func addToDestinationStation(_ value: CDDirection)

    @objc(removeDestinationStationObject:)
    @NSManaged public func removeFromDestinationStation(_ value: CDDirection)

    @objc(addDestinationStation:)
    @NSManaged public func addToDestinationStation(_ values: NSSet)

    @objc(removeDestinationStation:)
    @NSManaged public func removeFromDestinationStation(_ values: NSSet)

}

extension CDStationInfo: Identifiable {

}

extension CDStationInfo {
    static func fetchAllStationInfo(context: NSManagedObjectContext) -> [String: [CDStationInfo]] {
        let fetchRequest: NSFetchRequest<CDStationInfo> = CDStationInfo.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "stationName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let allStationInfos = try context.fetch(fetchRequest)
            
            return Dictionary(grouping: allStationInfos) { stationInfo in
                guard let name = stationInfo.stationName?.uppercased(), !name.isEmpty else {
                    return "#"  // For stations with no name
                }
                
                let firstLetter = String(name.prefix(1))
                return firstLetter
            }
        } catch {
            print("Failed to fetch station infos: \(error.localizedDescription)")
            return [:]
        }
    }
    
    
    static func fetchAllStationInfo(context: NSManagedObjectContext, contains searchText: String) -> [CDStationInfo] {
        let fetchRequest: NSFetchRequest<CDStationInfo> = CDStationInfo.fetchRequest()
        
        // 1. Add predicate
        let predicate = NSPredicate(format: "stationName CONTAINS[cd] %@", searchText)
        fetchRequest.predicate = predicate
        
        
        // 2. Add sort descriptor for alphabetical order
        let sortDescriptor = NSSortDescriptor(key: "stationName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Failed to fetch station infos: \(error.localizedDescription)")
            return []
        }
    }
}
