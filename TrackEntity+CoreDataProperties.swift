//
//  TrackEntity+CoreDataProperties.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/10/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//
//

import Foundation
import CoreData


extension TrackEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackEntity> {
        return NSFetchRequest<TrackEntity>(entityName: "TrackEntity")
    }

    @NSManaged public var trackName: String?
    @NSManaged public var artistName: String?
    @NSManaged public var coverArt: NSData?

}
