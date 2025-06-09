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
    @NSManaged public var timeTables: NSSet?
    @NSManaged public var directionStation: MHD_DirectionStation?

}

// MARK: Generated accessors for timeTables
extension MHD_DaytimeSchedule {

    @objc(addTimeTablesObject:)
    @NSManaged public func addToTimeTables(_ value: MHD_TimeTable)

    @objc(removeTimeTablesObject:)
    @NSManaged public func removeFromTimeTables(_ value: MHD_TimeTable)

    @objc(addTimeTables:)
    @NSManaged public func addToTimeTables(_ values: NSSet)

    @objc(removeTimeTables:)
    @NSManaged public func removeFromTimeTables(_ values: NSSet)

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
