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
    }
    
    func isEqual(compare_with : Entry)-> Bool{
        if entryText != compare_with.entryText {return false}
        if location != compare_with.location {return false}
        if entryDate != compare_with.entryDate {return false}
        // add comparison on tracks!!
        //if associatedTracks != compare_with.associatedTracks {return false}
        return true
    }
}
