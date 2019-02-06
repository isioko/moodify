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
    public var spotifyID: String
    public var entryDate: String
    

    init() {
        self.entryText = ""
        self.spotifyID = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        self.entryDate = formatter.string(from: date)
    }
}
