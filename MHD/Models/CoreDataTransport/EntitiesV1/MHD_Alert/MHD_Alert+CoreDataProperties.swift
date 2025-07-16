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


extension MHD_Alert {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_Alert> {
        return NSFetchRequest<MHD_Alert>(entityName: "MHD_Alert")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var endTime: Date?
    @NSManaged public var startTime: Date?
    @NSManaged public var message: String?

}

extension MHD_Alert : Identifiable {

}

extension MHD_Alert {
    
//    static func deleteAll(in context: NSManagedObjectContext) {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_Alert.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        
//        do {
//            try context.execute(deleteRequest)
//        } catch {
//            print("😞 Failed to clear existing data: \(error)")
//        }
//    }
    
}
