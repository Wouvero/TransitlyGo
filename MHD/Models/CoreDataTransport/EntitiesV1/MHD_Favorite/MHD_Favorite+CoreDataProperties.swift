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


extension MHD_Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_Favorite> {
        return NSFetchRequest<MHD_Favorite>(entityName: "MHD_Favorite")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sortIndex: Int64
    @NSManaged public var fromStation: MHD_StationInfo?
    @NSManaged public var toStation: MHD_StationInfo?

}

extension MHD_Favorite : Identifiable {

}
