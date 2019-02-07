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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    
    func reload() {
        let pinkUIColor = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 0.2)
        
        if isSelected {
            contentView.backgroundColor = pinkUIColor
        }
        else if isHighlighted {
            contentView.backgroundColor = pinkUIColor
        }
        else {
            contentView.backgroundColor = UIColor.white
        }
    }
    
    func displayTrack(track: Track){
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        trackArtworkImage.image = track.trackArtworkImage
    }
    
}
