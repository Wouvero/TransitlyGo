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


extension MHD_TransportLine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_TransportLine> {
        return NSFetchRequest<MHD_TransportLine>(entityName: "MHD_TransportLine")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var sortIndex: Int64
    @NSManaged public var stations: NSSet?
    @NSManaged public var directions: NSSet?

}

// MARK: Generated accessors for stations
extension MHD_TransportLine {

    @objc(addStationsObject:)
    @NSManaged public func addToStations(_ value: MHD_StationInfo)

    @objc(removeStationsObject:)
    @NSManaged public func removeFromStations(_ value: MHD_StationInfo)

    @objc(addStations:)
    @NSManaged public func addToStations(_ values: NSSet)

    @objc(removeStations:)
    @NSManaged public func removeFromStations(_ values: NSSet)

}

// MARK: Generated accessors for directions
extension MHD_TransportLine {

    @objc(addDirectionsObject:)
    @NSManaged public func addToDirections(_ value: MHD_Direction)

    @objc(removeDirectionsObject:)
    @NSManaged public func removeFromDirections(_ value: MHD_Direction)

    @objc(addDirections:)
    @NSManaged public func addToDirections(_ values: NSSet)

    @objc(removeDirections:)
    @NSManaged public func removeFromDirections(_ values: NSSet)

}

extension MHD_TransportLine : Identifiable {

}

extension MHD_TransportLine {
    
    static func checkIfItemExists(with id: String, in context: NSManagedObjectContext) -> Bool {
        context.performAndWait {
            let fetchRequest = MHD_TransportLine.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.fetchLimit = 1
            
            do {
                return try context.count(for: fetchRequest) > 0
            } catch {
                print("Error checking transport line existence: \(error.localizedDescription)")
                return false
            }
        }
    }
    
    static func getAll(in context: NSManagedObjectContext) -> [MHD_TransportLine] {
        var results: [MHD_TransportLine] = []
        
        context.performAndWait {
            let fetchRequest = MHD_TransportLine.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortIndex", ascending: true)]
            do {
                results = try context.fetch(fetchRequest)
            } catch {
                print("Failed to fetch transport lines: \(error.localizedDescription)")
                results = []
            }
        }
        
        return results
    }
    
    @discardableResult
    static func deleteAll(in context: NSManagedObjectContext) -> Bool {
        var success = false
        
        context.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_TransportLine.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                
                // IMPORTANT: Refresh context after batch operation
                context.refreshAllObjects()
                
                success = true
            } catch {
                print("Failed to delete all transport lines: \(error.localizedDescription)")
                // Attempt fallback to individual deletion if batch fails
                success = deleteAllItemsIndividually(in: context)
            }
        }
        
        return success
    }
    
    private static func deleteAllItemsIndividually(in context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<MHD_TransportLine> = MHD_TransportLine.fetchRequest()
        
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
