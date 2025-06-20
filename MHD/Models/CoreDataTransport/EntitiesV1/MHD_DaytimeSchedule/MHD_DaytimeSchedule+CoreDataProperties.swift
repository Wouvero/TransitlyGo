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


extension MHD_DaytimeSchedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_DaytimeSchedule> {
        return NSFetchRequest<MHD_DaytimeSchedule>(entityName: "MHD_DaytimeSchedule")
    }

    @NSManaged public var dayType: Int16
    @NSManaged public var hours: NSSet?
    @NSManaged public var directionStation: MHD_DirectionStation?

}

// MARK: Generated accessors for timeTables
extension MHD_DaytimeSchedule {

    @objc(addHoursObject:)
    @NSManaged public func addToHours(_ value: MHD_Hour)

    @objc(removeHoursObject:)
    @NSManaged public func removeFromHours(_ value: MHD_Hour)

    @objc(addHours:)
    @NSManaged public func addToHours(_ values: NSSet)

    @objc(removeHours:)
    @NSManaged public func removeFromHours(_ values: NSSet)


}

extension MHD_DaytimeSchedule : Identifiable {

}

extension MHD_DaytimeSchedule {

    static func deleteAll(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_DaytimeSchedule.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("😞 Failed to clear existing data: \(error)")
        }
    }
    
}
