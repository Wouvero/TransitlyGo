//
//
//
// Created by: Patrik Drab on 18/05/2025
// Copyright (c) 2025 MHD 
//
//         

//

import Foundation
import CoreData


extension CDDayTypeSchedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDayTypeSchedule> {
        return NSFetchRequest<CDDayTypeSchedule>(entityName: "CDDayTypeSchedule")
    }

    @NSManaged public var dayType: Int16
    @NSManaged public var timeTables: NSSet?
    @NSManaged public var transitSchedule: CDTransitSchedule?

}

// MARK: Generated accessors for timeTables
extension CDDayTypeSchedule {

    @objc(addTimeTablesObject:)
    @NSManaged public func addToTimeTables(_ value: CDHourlyInfo)

    @objc(removeTimeTablesObject:)
    @NSManaged public func removeFromTimeTables(_ value: CDHourlyInfo)

    @objc(addTimeTables:)
    @NSManaged public func addToTimeTables(_ values: NSSet)

    @objc(removeTimeTables:)
    @NSManaged public func removeFromTimeTables(_ values: NSSet)

}

extension CDDayTypeSchedule : Identifiable {

}
