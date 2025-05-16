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


extension CDHourlyDeparture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDHourlyDeparture> {
        return NSFetchRequest<CDHourlyDeparture>(entityName: "CDHourlyDeparture")
    }

    @NSManaged public var hour: Int16
    @NSManaged public var dayTypeSchedule: CDDayTypeSchedule?
    @NSManaged public var minutes: NSSet?

}

// MARK: Generated accessors for minutes
extension CDHourlyDeparture {

    @objc(addMinutesObject:)
    @NSManaged public func addToMinutes(_ value: CDMinuteInfo)

    @objc(removeMinutesObject:)
    @NSManaged public func removeFromMinutes(_ value: CDMinuteInfo)

    @objc(addMinutes:)
    @NSManaged public func addToMinutes(_ values: NSSet)

    @objc(removeMinutes:)
    @NSManaged public func removeFromMinutes(_ values: NSSet)

}

extension CDHourlyDeparture : Identifiable {

}
