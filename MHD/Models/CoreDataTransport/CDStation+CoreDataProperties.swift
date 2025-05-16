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


extension CDStation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDStation> {
        return NSFetchRequest<CDStation>(entityName: "CDStation")
    }

    @NSManaged public var id: String?
    @NSManaged public var travelTimeToNextStop: Int64
    @NSManaged public var isOnSign: Bool
    @NSManaged public var stationInfo: CDStationInfo?
    @NSManaged public var directionSpecificInfo: CDDirectionSpecificInfo?
    @NSManaged public var direction: CDDirection?
    @NSManaged public var transitSchedule: CDTransitSchedule?

}

extension CDStation : Identifiable {

}

extension CDStation {
    func fetchAllStations(context: NSManagedObjectContext) -> [CDStation] {
        let fetchRequest = CDStation.fetchRequest()
        
        do {
            let stations = try context.fetch(fetchRequest)
            return stations
        } catch let error as NSError {
            print("Could not fetch stations. \(error), \(error.userInfo)")
            return []
        }
    }
}
