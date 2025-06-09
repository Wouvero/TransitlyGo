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


extension MHD_DirectionStation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_DirectionStation> {
        return NSFetchRequest<MHD_DirectionStation>(entityName: "MHD_DirectionStation")
    }

    @NSManaged public var id: String?
    @NSManaged public var isOnSign: Bool
    @NSManaged public var travelTimeToNextStation: Int32
    @NSManaged public var sortIndex: Int32
    @NSManaged public var direction: MHD_Direction?
    @NSManaged public var stationInfo: MHD_StationInfo?
    @NSManaged public var schedules: NSSet?

}

// MARK: Generated accessors for schedules
extension MHD_DirectionStation {

    @objc(addSchedulesObject:)
    @NSManaged public func addToSchedules(_ value: MHD_DaytimeSchedule)

    @objc(removeSchedulesObject:)
    @NSManaged public func removeFromSchedules(_ value: MHD_DaytimeSchedule)

    @objc(addSchedules:)
    @NSManaged public func addToSchedules(_ values: NSSet)

    @objc(removeSchedules:)
    @NSManaged public func removeFromSchedules(_ values: NSSet)

}

extension MHD_DirectionStation : Identifiable {

}
