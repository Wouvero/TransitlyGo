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


extension CDTransportLine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTransportLine> {
        return NSFetchRequest<CDTransportLine>(entityName: "CDTransportLine")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var indexPosition: Int64
    @NSManaged public var alerts: NSSet?
    @NSManaged public var directions: NSSet?

}

// MARK: Generated accessors for alerts
extension CDTransportLine {

    @objc(addAlertsObject:)
    @NSManaged public func addToAlerts(_ value: CDAlert)

    @objc(removeAlertsObject:)
    @NSManaged public func removeFromAlerts(_ value: CDAlert)

    @objc(addAlerts:)
    @NSManaged public func addToAlerts(_ values: NSSet)

    @objc(removeAlerts:)
    @NSManaged public func removeFromAlerts(_ values: NSSet)

}

// MARK: Generated accessors for directions
extension CDTransportLine {

    @objc(addDirectionsObject:)
    @NSManaged public func addToDirections(_ value: CDDirection)

    @objc(removeDirectionsObject:)
    @NSManaged public func removeFromDirections(_ value: CDDirection)

    @objc(addDirections:)
    @NSManaged public func addToDirections(_ values: NSSet)

    @objc(removeDirections:)
    @NSManaged public func removeFromDirections(_ values: NSSet)

}

extension CDTransportLine : Identifiable {

}
