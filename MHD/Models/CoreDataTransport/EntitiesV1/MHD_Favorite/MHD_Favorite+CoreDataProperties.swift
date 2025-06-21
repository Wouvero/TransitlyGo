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
    
    static func checkIfItemExists(
        for fromStationName: String,
        and toStationname: String,
        in context: NSManagedObjectContext
    ) -> Bool {
        let fetchRequest = MHD_Favorite.fetchRequest()
        
        let predicate = NSPredicate(
            format: "fromStation.stationName == %@ AND toStation.stationName == %@",
            fromStationName,
            toStationname
        )
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Error fetching data")
            return false
        }
    }
    
    static func addToFavorite(_ favorite: SearchRouteModel, in context: NSManagedObjectContext) {
        let favoriteEntity = MHD_Favorite(context: context)
        favoriteEntity.fromStation = favorite.fromStationInfo
        favoriteEntity.toStation = favorite.toStationInfo
        
        do {
            try context.save()
        } catch {
            print("Error saving to favorite \(error)")
        }
    }
    
    static func removeFromFavorite(in context: NSManagedObjectContext) {
        
    }
}
