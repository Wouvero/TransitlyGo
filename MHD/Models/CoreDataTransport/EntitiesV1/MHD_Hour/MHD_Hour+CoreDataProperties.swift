//
//
//
// Created by: Patrik Drab on 20/06/2025
// Copyright (c) 2025 MHD 
//
//         

//

import Foundation
import CoreData


extension MHD_Hour {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_Hour> {
        return NSFetchRequest<MHD_Hour>(entityName: "MHD_Hour")
    }

    @NSManaged public var hourInfo: Int16
    @NSManaged public var daytimeSchedule: MHD_DaytimeSchedule?
    @NSManaged public var minutes: NSSet?

}

// MARK: Generated accessors for minutes
extension MHD_Hour {

    @objc(addMinutesObject:)
    @NSManaged public func addToMinutes(_ value: MHD_Minute)

    @objc(removeMinutesObject:)
    @NSManaged public func removeFromMinutes(_ value: MHD_Minute)

    @objc(addMinutes:)
    @NSManaged public func addToMinutes(_ values: NSSet)

    @objc(removeMinutes:)
    @NSManaged public func removeFromMinutes(_ values: NSSet)

}

extension MHD_Hour : Identifiable {

}

extension MHD_Hour {
    
    static func deleteAll(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_Hour.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("😞 Failed to clear existing data: \(error)")
        }
    }
}
