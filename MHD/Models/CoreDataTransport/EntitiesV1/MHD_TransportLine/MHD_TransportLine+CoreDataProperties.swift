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
        let fetchRequest = MHD_TransportLine.fetchRequest()
        
        let idPredicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = idPredicate
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first != nil ? true : false
        } catch {
            print("Error fetching data")
            return false
        }
    }
    
    static func getAll(in context: NSManagedObjectContext) -> [MHD_TransportLine] {
        let fetchRequest = MHD_TransportLine.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortIndex", ascending: true)]
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching data")
            return []
        }
    }
    
    static func deleteAll(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_TransportLine.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("😞 Failed to clear existing data: \(error)")
        }
    }
    
}
