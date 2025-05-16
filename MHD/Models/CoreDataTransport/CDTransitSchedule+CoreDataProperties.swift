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


extension CDTransitSchedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTransitSchedule> {
        return NSFetchRequest<CDTransitSchedule>(entityName: "CDTransitSchedule")
    }

    @NSManaged public var id: String?
    @NSManaged public var station: CDStation?
    @NSManaged public var dayTypeSchedules: NSSet?

}

// MARK: Generated accessors for dayTypeSchedules
extension CDTransitSchedule {

    @objc(addDayTypeSchedulesObject:)
    @NSManaged public func addToDayTypeSchedules(_ value: CDDayTypeSchedule)

    @objc(removeDayTypeSchedulesObject:)
    @NSManaged public func removeFromDayTypeSchedules(_ value: CDDayTypeSchedule)

    @objc(addDayTypeSchedules:)
    @NSManaged public func addToDayTypeSchedules(_ values: NSSet)

    @objc(removeDayTypeSchedules:)
    @NSManaged public func removeFromDayTypeSchedules(_ values: NSSet)

}

extension CDTransitSchedule : Identifiable {

}
