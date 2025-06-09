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


extension MHD_Direction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_Direction> {
        return NSFetchRequest<MHD_Direction>(entityName: "MHD_Direction")
    }

    @NSManaged public var id: String?
    @NSManaged public var transportLine: MHD_TransportLine?
    @NSManaged public var routeGeoJSONData: Data?
    @NSManaged public var sortIndex: Int16
    @NSManaged public var directionStations: NSSet?
    @NSManaged public var endDestination: MHD_StationInfo?

}

// MARK: Generated accessors for directionStations
extension MHD_Direction {

    @objc(addDirectionStationsObject:)
    @NSManaged public func addToDirectionStations(_ value: MHD_DirectionStation)

    @objc(removeDirectionStationsObject:)
    @NSManaged public func removeFromDirectionStations(_ value: MHD_DirectionStation)

    @objc(addDirectionStations:)
    @NSManaged public func addToDirectionStations(_ values: NSSet)

    @objc(removeDirectionStations:)
    @NSManaged public func removeFromDirectionStations(_ values: NSSet)

}

extension MHD_Direction : Identifiable {

}

extension MHD_Direction {
    
    static func deleteAll(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_Direction.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("😞 Failed to clear existing data: \(error)")
        }
    }
    
}
