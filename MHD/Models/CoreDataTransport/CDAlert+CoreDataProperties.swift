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


extension CDAlert {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAlert> {
        return NSFetchRequest<CDAlert>(entityName: "CDAlert")
    }

    @NSManaged public var endTime: Date?
    @NSManaged public var startTime: Date?
    @NSManaged public var message: String?
    @NSManaged public var id: String?
    @NSManaged public var line: CDTransportLine?

}

extension CDAlert : Identifiable {

}
