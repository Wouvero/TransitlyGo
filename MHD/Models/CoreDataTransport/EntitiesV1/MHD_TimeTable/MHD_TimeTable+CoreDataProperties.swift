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


extension MHD_TimeTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_TimeTable> {
        return NSFetchRequest<MHD_TimeTable>(entityName: "MHD_TimeTable")
    }

    @NSManaged public var hour: Int16
    @NSManaged public var minuteInfos: NSSet?
    @NSManaged public var daytimeSchedule: MHD_DaytimeSchedule?

}

// MARK: Generated accessors for minuteInfos
extension MHD_TimeTable {

    @objc(addMinuteInfosObject:)
    @NSManaged public func addToMinuteInfos(_ value: MHD_MinuteInfo)

    @objc(removeMinuteInfosObject:)
    @NSManaged public func removeFromMinuteInfos(_ value: MHD_MinuteInfo)

    @objc(addMinuteInfos:)
    @NSManaged public func addToMinuteInfos(_ values: NSSet)

    @objc(removeMinuteInfos:)
    @NSManaged public func removeFromMinuteInfos(_ values: NSSet)

}

extension MHD_TimeTable : Identifiable {

}

extension MHD_TimeTable {

    static func deleteAll(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_TimeTable.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("😞 Failed to clear existing data: \(error)")
        }
    }
    
}
