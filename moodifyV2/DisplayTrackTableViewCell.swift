//
//  DisplayTrackTableViewCell.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/8/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class DisplayTrackTableViewCell:UITableViewCell{
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var aristNameLabel: UILabel!
    
    @IBOutlet weak var trackImage: UIImageView!
    func displayTrack(track: Track){
        trackNameLabel.text = track.trackName
        aristNameLabel.text = track.artistName
        trackImage.image = track.trackArtworkImage
    }
    
}
