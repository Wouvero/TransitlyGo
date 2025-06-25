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
    
    static func searchStationInfosGroupedAlphabetically(context: NSManagedObjectContext, contains searchText: String? = nil) -> [String: [MHD_StationInfo]] {
        var results: [String: [MHD_StationInfo]] = [:]
        
        
        context.performAndWait {
            // 1. Build predicates
            var predicates = [NSPredicate(format: "id ENDSWITH '-1'")]
            
            if let searchText = searchText?.trimmingCharacters(in: .whitespaces), !searchText.isEmpty {
                predicates.append(NSPredicate(format: "stationName CONTAINS[cd] %@", searchText))
            }
            
            // 2. Configure fetch request
            let fetchRequest: NSFetchRequest<MHD_StationInfo> = MHD_StationInfo.fetchRequest()
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "stationName", ascending: true)]
            fetchRequest.returnsObjectsAsFaults = false
            
            // 3. Execute fetch and group results
            do {
                let fetchedResults = try context.fetch(fetchRequest)
                results = Dictionary(grouping: fetchedResults) { stationInfo in
                    guard let firstChar = stationInfo.stationName?.first else { return "#" }
                    return firstChar.isLetter ? String(firstChar).uppercased() : "#"
                }
            } catch {
                print("Failed to fetch station infos: \(error.localizedDescription)")
                results = [:]
            }
        }
        
        return results
    }
    
    static func getStationInfo(withId id: String, in context: NSManagedObjectContext) -> MHD_StationInfo? {
        var result: MHD_StationInfo?
        
        context.performAndWait {
            let fetchRequest: NSFetchRequest<MHD_StationInfo> = MHD_StationInfo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.fetchLimit = 1
            fetchRequest.returnsObjectsAsFaults = false  // Get full objects if we'll use their properties
            
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                print("Failed to fetch stationInfo with id \(id): \(error.localizedDescription)")
            }
        }
        
        return result
    }
    
    @discardableResult
    static func deleteAll(in context: NSManagedObjectContext) -> Bool {
        var success = false
        
        context.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_StationInfo.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                context.refreshAllObjects()
                success = true
            } catch {
                print("Failed to delete all station infos: \(error.localizedDescription)")
                success = deleteAllItemsIndividually(in: context)
            }
        }
        
        return success
    }
    
    private static func deleteAllItemsIndividually(in context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<MHD_StationInfo> = MHD_StationInfo.fetchRequest()
        
        do {
            let items = try context.fetch(fetchRequest)
            items.forEach { context.delete($0) }
            try context.save()
            return true
        } catch {
            context.rollback()
            print("❌ Fallback deletion failed: \(error.localizedDescription)")
            return false
        }
    }
}
