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


extension CDMinuteInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMinuteInfo> {
        return NSFetchRequest<CDMinuteInfo>(entityName: "CDMinuteInfo")
    }

    @NSManaged public var minute: Int16
    @NSManaged public var condition: String?
    @NSManaged public var hourlyDeparture: CDHourlyDeparture?

}

extension CDMinuteInfo : Identifiable {

}
