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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var numTracksLabel: UILabel!
    
    func displayContent(entry: Entry){
        entryLabel.text = entry.entryText
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        dateLabel.text = formatter.string(from: entry.entryDate)
        locationLabel.text = entry.location
        locationImage.image = UIImage(named: "location-logo.png")
        numTracksLabel.text = String(entry.associatedTracks.count)
        
        let current_date = Date()
//        print("current date", current_date)
//        print("current date with formatter", current_date)
//        print("entry date", entry.entryDate)
//        print("entry date with formatter", formatter.string(from: entry.entryDate))
//
        
        print("time interval from now", entry.entryDate, entry.entryDate.timeIntervalSinceNow)
        print("num days", Int(-1 * (entry.entryDate.timeIntervalSinceNow / 86400)))
//        let diff = current_date.interval(ofComponent: .day, fromDate: entry.entryDate)
        let diff = Int(-1 * (entry.entryDate.timeIntervalSinceNow / 86400))
        let relativeDateForEntry = calculateRelativeDate(num_days: diff)

        //relativeDateLabel.text = entry.relativeDate
        relativeDateLabel.text = relativeDateForEntry
    }
    
    func calculateRelativeDate(num_days: Int)->String{
        if num_days == 0 {
            return "TODAY"
        } else if num_days == 1 {
            return "YESTERDAY"
        } else if num_days == 2 {
            return "TWO DAYS AGO"
        } else if num_days == 3 {
            return "THREE DAYS AGO"
        } else if num_days == 4 {
            return "FOUR DAYS AGO"
        } else if num_days == 5 {
            return "FIVE DAYS AGO"
        } else if num_days == 6 {
            return "SIX DAYS AGO"
        } else if num_days > 6 && num_days < 30 {
            return "THIS MONTH"
        } else {
            return ""
        }
    }
}
