//
//  Entry.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/3/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation

class Entry {
    public var entryText: String
    public var entryDate: Date
    public var location: String
    public var associatedTracks = [Track]()
    public var relativeDate: String
    public var entryDateString: String
    public var numAssociatedTracks: Int
    init() {
        self.entryText = ""
        self.location = ""
        let date = Date()
        self.entryDate = date
        self.relativeDate = ""
        self.numAssociatedTracks = 0
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy/MM/dd"
        self.entryDateString = date_formatter.string(from: date)
    }
    
    // NOTE: only goes so far as to compare SIZE of tracks array; does not loop through tracks
    func isEqual(compare_with : Entry) -> Bool {
        if entryText != compare_with.entryText {return false}
        if location != compare_with.location {return false}
        if entryDate != compare_with.entryDate {return false}
        // only compares SIZE of track lists
        if associatedTracks.count != compare_with.associatedTracks.count {return false}
        return true
    }
}
