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


extension CDDirection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDirection> {
        return NSFetchRequest<CDDirection>(entityName: "CDDirection")
    }

    @NSManaged public var id: String?
    @NSManaged public var destinationStationId: String?
    @NSManaged public var line: CDTransportLine?
    @NSManaged public var stations: NSSet?
    @NSManaged public var destinationStation: CDStationInfo?

}

// MARK: Generated accessors for stations
extension CDDirection {

    @objc(addStationsObject:)
    @NSManaged public func addToStations(_ value: CDStation)

    @objc(removeStationsObject:)
    @NSManaged public func removeFromStations(_ value: CDStation)

    @objc(addStations:)
    @NSManaged public func addToStations(_ values: NSSet)

    @objc(removeStations:)
    @NSManaged public func removeFromStations(_ values: NSSet)

}

extension CDDirection : Identifiable {

}
