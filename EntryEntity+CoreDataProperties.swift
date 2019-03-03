//
//  EntryEntity+CoreDataProperties.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/16/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//
//

import Foundation
import CoreData


extension EntryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntryEntity> {
        return NSFetchRequest<EntryEntity>(entityName: "EntryEntity")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var location: String?
    @NSManaged public var text: String?
    @NSManaged public var associatedTrack: NSSet?
//    @NSManaged public var dateString: String?

}

// MARK: Generated accessors for associatedTrack
extension EntryEntity {

    @objc(addAssociatedTrackObject:)
    @NSManaged public func addToAssociatedTrack(_ value: TrackEntity)

    @objc(removeAssociatedTrackObject:)
    @NSManaged public func removeFromAssociatedTrack(_ value: TrackEntity)

    @objc(addAssociatedTrack:)
    @NSManaged public func addToAssociatedTrack(_ values: NSSet)

    @objc(removeAssociatedTrack:)
    @NSManaged public func removeFromAssociatedTrack(_ values: NSSet)

}
