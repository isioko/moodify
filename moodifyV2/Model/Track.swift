//
//  Track.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/5/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import UIKit
import Foundation

class Track {
    public var trackName: String
    public var artistName: String
    public var trackArtworkImage: UIImage?
    
    init(){
        self.trackName = ""
        self.artistName = ""
        self.trackArtworkImage = UIImage()
    }
}
