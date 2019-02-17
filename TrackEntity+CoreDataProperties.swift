//
//  TrackEntity+CoreDataProperties.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/16/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//
//

import Foundation
import CoreData


extension TrackEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackEntity> {
        return NSFetchRequest<TrackEntity>(entityName: "TrackEntity")
    }

    @NSManaged public var artistName: String?
    @NSManaged public var coverArt: NSData?
    @NSManaged public var trackName: String?
    @NSManaged public var associatedEntry: NSSet?

}

// MARK: Generated accessors for associatedEntry
extension TrackEntity {

    @objc(addAssociatedEntryObject:)
    @NSManaged public func addToAssociatedEntry(_ value: EntryEntity)

    @objc(removeAssociatedEntryObject:)
    @NSManaged public func removeFromAssociatedEntry(_ value: EntryEntity)

    @objc(addAssociatedEntry:)
    @NSManaged public func addToAssociatedEntry(_ values: NSSet)

    @objc(removeAssociatedEntry:)
    @NSManaged public func removeFromAssociatedEntry(_ values: NSSet)

}
