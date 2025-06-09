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


extension MHD_StationLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_StationLocation> {
        return NSFetchRequest<MHD_StationLocation>(entityName: "MHD_StationLocation")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var platform: String?
    @NSManaged public var stationInfo: MHD_StationInfo?

}

extension MHD_StationLocation : Identifiable {
    
}

extension MHD_StationLocation {

    static func deleteAll(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_StationLocation.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("😞 Failed to clear existing data: \(error)")
        }
    }
    
}
