//
//
//
// Created by: Patrik Drab on 04/06/2025
// Copyright (c) 2025 MHD
//
//

//

import Foundation
import CoreData


extension MHD_StationInfo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_StationInfo> {
        return NSFetchRequest<MHD_StationInfo>(entityName: "MHD_StationInfo")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var stationName: String?
    @NSManaged public var location: MHD_StationLocation?
    @NSManaged public var transportLines: NSSet?
    @NSManaged public var directionStations: NSSet?
    @NSManaged public var endDestinations: NSSet?
    
}

// MARK: Generated accessors for transportLines
extension MHD_StationInfo {
    
    @objc(addTransportLinesObject:)
    @NSManaged public func addToTransportLines(_ value: MHD_TransportLine)
    
    @objc(removeTransportLinesObject:)
    @NSManaged public func removeFromTransportLines(_ value: MHD_TransportLine)
    
    @objc(addTransportLines:)
    @NSManaged public func addToTransportLines(_ values: NSSet)
    
    @objc(removeTransportLines:)
    @NSManaged public func removeFromTransportLines(_ values: NSSet)
    
}

// MARK: Generated accessors for directionStations
extension MHD_StationInfo {
    
    @objc(addDirectionStationsObject:)
    @NSManaged public func addToDirectionStations(_ value: MHD_DirectionStation)
    
    @objc(removeDirectionStationsObject:)
    @NSManaged public func removeFromDirectionStations(_ value: MHD_DirectionStation)
    
    @objc(addDirectionStations:)
    @NSManaged public func addToDirectionStations(_ values: NSSet)
    
    @objc(removeDirectionStations:)
    @NSManaged public func removeFromDirectionStations(_ values: NSSet)
    
}

// MARK: Generated accessors for endDestinations
extension MHD_StationInfo {
    
    @objc(addEndDestinationsObject:)
    @NSManaged public func addToEndDestinations(_ value: MHD_Direction)
    
    @objc(removeEndDestinationsObject:)
    @NSManaged public func removeFromEndDestinations(_ value: MHD_Direction)
    
    @objc(addEndDestinations:)
    @NSManaged public func addToEndDestinations(_ values: NSSet)
    
    @objc(removeEndDestinations:)
    @NSManaged public func removeFromEndDestinations(_ values: NSSet)
    
}

extension MHD_StationInfo : Identifiable {
    
}



extension MHD_StationInfo {
    static func searchStationInfosGroupedAlphabetically(context: NSManagedObjectContext) -> [String: [MHD_StationInfo]] {
        let fetchRequest: NSFetchRequest<MHD_StationInfo> = MHD_StationInfo.fetchRequest()
        
        let idPredicate = NSPredicate(format: "id ENDSWITH '-1'")
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            idPredicate
        ])
        
        let sortDescriptor = NSSortDescriptor(key: "stationName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        guard let allStationInfos = try? context.fetch(fetchRequest) else {
            print("Failed to fetch station infos")
            return [:]
        }
        
        return Dictionary(grouping: allStationInfos) { stationInfo in
            stationInfo.stationName?.first
                .flatMap { $0.isLetter ? String($0).uppercased() : "#" }
            ?? "#"
        }
    }
    
    
    static func searchStationInfosGroupedAlphabetically(context: NSManagedObjectContext, contains searchText: String) -> [String: [MHD_StationInfo]] {
        let fetchRequest: NSFetchRequest<MHD_StationInfo> = MHD_StationInfo.fetchRequest()
        
        // 1. Add predicate
        let searchPredicate = NSPredicate(format: "stationName CONTAINS[cd] %@", searchText)
        let idPredicate = NSPredicate(format: "id ENDSWITH '-1'")
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            searchPredicate,
            idPredicate
        ])
        
        // 2. Add sort descriptor for alphabetical order
        let sortDescriptor = NSSortDescriptor(key: "stationName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        guard let allStationInfos = try? context.fetch(fetchRequest) else {
            print("Failed to fetch station infos")
            return [:]
        }
        
        return Dictionary(grouping: allStationInfos) { stationInfo in
            stationInfo.stationName?.first
                .flatMap { $0.isLetter ? String($0).uppercased() : "#" }
            ?? "#"
        }
    }
    
    static func getStationInfo(withId id: String, in context: NSManagedObjectContext) -> MHD_StationInfo? {
        let fetchRequest = MHD_StationInfo.fetchRequest()
        
        let idPredicate = NSPredicate(format: "id == %@", id)
        
        fetchRequest.predicate = idPredicate
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print("Faild to fetch stationInfo with id: \(id)")
            return nil
        }
    }
    
    static func deleteAll(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_StationInfo.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("😞 Failed to clear existing data: \(error)")
        }
    }
}
