//
//  TrackTableViewCell.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/5/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackArtworkImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    func displayTrack(track: Track){
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        trackArtworkImage.image = track.trackArtworkImage
    }
    
}
