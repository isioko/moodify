//
//  DisplayTrackCollectionViewCell.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/9/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class DisplayTrackCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    
    func displayTrack(track: Track){
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        trackImage.image = track.trackArtworkImage
    }
    
}
