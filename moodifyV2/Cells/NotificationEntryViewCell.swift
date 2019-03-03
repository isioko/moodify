//
//  NotificationEntryViewCell.swift
//  moodifyV2
//
//  Created by Isi Okojie on 3/2/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class NotificationEntryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var entryLabel: UILabel!
    
    func displayContent(entry: Entry) {
        entryLabel.text = entry.entryText
    }
}
