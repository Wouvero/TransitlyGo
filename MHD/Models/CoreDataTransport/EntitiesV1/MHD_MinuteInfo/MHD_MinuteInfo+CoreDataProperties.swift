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


extension MHD_MinuteInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MHD_MinuteInfo> {
        return NSFetchRequest<MHD_MinuteInfo>(entityName: "MHD_MinuteInfo")
    }

    @NSManaged public var minute: Int16
    @NSManaged public var condition: String?
    @NSManaged public var timeTable: MHD_TimeTable?

}

extension MHD_MinuteInfo : Identifiable {

}

extension MHD_MinuteInfo {
    
    static func deleteAll(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MHD_MinuteInfo.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("😞 Failed to clear existing data: \(error)")
        }
    }
    
}
