//
//
//
// Created by: Patrik Drab on 17/06/2025
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

    @NSManaged public var sortIndex: Int64
    @NSManaged public var from: String?
    @NSManaged public var to: String?
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?

}

extension MHD_Favorite: Identifiable {

}

extension MHD_Favorite {
    static func getAll(in context: NSManagedObjectContext) -> [MHD_Favorite] {
        let fetchRequest: NSFetchRequest<MHD_Favorite> = MHD_Favorite.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortIndex", ascending: true)]
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Faild to fetch favorites")
            return []
        }
    }
}
