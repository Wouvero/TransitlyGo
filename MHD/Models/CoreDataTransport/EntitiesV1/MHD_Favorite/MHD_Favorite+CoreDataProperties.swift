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
    @NSManaged public var fromStation: String?
    @NSManaged public var toStation: String?

}

extension MHD_Favorite : Identifiable {

}

extension MHD_Favorite {
    
    static func getAll(in context: NSManagedObjectContext) -> [MHD_Favorite] {
        var results: [MHD_Favorite] = []
        
        context.performAndWait {
            let fetchRequest: NSFetchRequest<MHD_Favorite> = MHD_Favorite.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortIndex", ascending: true)]
            
            do {
                results = try context.fetch(fetchRequest)
            } catch {
                print("Failed to fetch favorites: \(error.localizedDescription)")
                results = []
            }
        }
        
        return results
    }
    
    static func checkIfItemExists(
        for fromStationName: String,
        and toStationname: String,
        in context: NSManagedObjectContext
    ) -> Bool {
        context.performAndWait {
            let fetchRequest = MHD_Favorite.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(
                format: "fromStation.stationName == %@ AND toStation.stationName == %@",
                fromStationName,
                toStationname
            )
            fetchRequest.fetchLimit = 1  // Optimize by only fetching one
            
            do {
                return try context.count(for: fetchRequest) > 0
            } catch {
                print("Error checking favorite existence: \(error.localizedDescription)")
                return false
            }
        }
    }
    
    @discardableResult
    static func add(_ favorite: RouteFinderModel, with name: String, in context: NSManagedObjectContext) -> Bool {
       
        context.performAndWait {
            print(favorite)
            let newFavoriteEntity = MHD_Favorite(context: context)
            newFavoriteEntity.id = UUID()
            newFavoriteEntity.fromStation = favorite.fromStationInfo.stationName
            newFavoriteEntity.toStation = favorite.toStationInfo.stationName
            newFavoriteEntity.name = name
            
            do {
                try context.save()
                return true
            } catch {
                /// context.rollback() is a Core Data method that undoes all changes made in a managed
                /// object context (NSManagedObjectContext) since the last save or since the context was created.
                /// It essentially resets the context to its last "clean" state, discarding any pending changes.
                context.rollback()
                print("Failed to save favorite: \(error.localizedDescription)")
                return false
            }
        }
        
    }
    
    @discardableResult
    static func delete(_ item: MHD_Favorite, in context: NSManagedObjectContext) -> Bool {
        guard item.managedObjectContext == context else {
            print("Attempted to delete item from wrong context")
            return false
        }
        
        /// context.performAndWait is a thread-safe way to execute Core Data operations
        /// on a managed object context (NSManagedObjectContext). It ensures that all
        /// database operations (fetching, saving, deleting) happen safely on the correct
        /// thread (usually the context's private queue).
        return context.performAndWait {
            context.delete(item)
            
            do {
                try context.save()
                return true
            } catch {
                print("Error deleting favorite item \(error).")
                return false
            }
        }
    }
    
    
    @discardableResult
    static func update(_ item: MHD_Favorite, in context: NSManagedObjectContext) -> Bool {
        guard item.managedObjectContext == context else {
            print("Attempted to update item from wrong context")
            return false
        }
       
        return context.performAndWait {
            do {
                try context.save()
                return true
            } catch {
                context.rollback()
                print("Failed to update favorite: \(error.localizedDescription)")
                return false
            }
        }
    }
    
}
