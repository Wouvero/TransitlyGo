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


extension CDDirectionSpecificInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDirectionSpecificInfo> {
        return NSFetchRequest<CDDirectionSpecificInfo>(entityName: "CDDirectionSpecificInfo")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var platform: String?
    @NSManaged public var station: CDStation?

}

extension CDDirectionSpecificInfo : Identifiable {

}
