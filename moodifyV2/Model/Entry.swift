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
    public var relativeDate:String

    init() {
        self.entryText = ""
        self.location = ""
        let date = Date()
        self.entryDate = date
        self.relativeDate = ""
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM-dd-yyyy"
//        self.entryDate = formatter.string(from: date)
        
    }
}
