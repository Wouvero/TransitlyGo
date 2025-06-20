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


extension MHD_Minute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_Minute> {
        return NSFetchRequest<MHD_Minute>(entityName: "MHD_Minute")
    }

    @NSManaged public var condition: String?
    @NSManaged public var minuteInfo: Int16
    @NSManaged public var hour: MHD_Hour?

}

extension MHD_Minute : Identifiable {

}

extension MHD_Minute {
    static func deleteAll(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_Minute.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("😞 Failed to clear existing data: \(error)")
        }
    }
}
