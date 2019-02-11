//
//  EntryViewCell.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/3/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class EntryViewCell:UICollectionViewCell{
    static let reuseIdentifier = "entryCell"
    
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var relativeDateLabel: UILabel!
    
    func displayContent(entry: Entry){
        entryLabel.text = entry.entryText
        dateLabel.text = entry.entryDate
    }
}
