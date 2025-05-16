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


extension CDDayTypeSchedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDayTypeSchedule> {
        return NSFetchRequest<CDDayTypeSchedule>(entityName: "CDDayTypeSchedule")
    }

    @NSManaged public var dayType: Int16
    @NSManaged public var transitSchedule: CDTransitSchedule?
    @NSManaged public var timeTables: NSSet?

}

// MARK: Generated accessors for timeTables
extension CDDayTypeSchedule {

    @objc(addTimeTablesObject:)
    @NSManaged public func addToTimeTables(_ value: CDHourlyDeparture)

    @objc(removeTimeTablesObject:)
    @NSManaged public func removeFromTimeTables(_ value: CDHourlyDeparture)

    @objc(addTimeTables:)
    @NSManaged public func addToTimeTables(_ values: NSSet)

    @objc(removeTimeTables:)
    @NSManaged public func removeFromTimeTables(_ values: NSSet)

}

extension CDDayTypeSchedule : Identifiable {

}
