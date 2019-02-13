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
        
        let numDays = getNumDays(date: entry.entryDate)
        let relativeDateForEntry = calculateRelativeDate(num_days: numDays)

        relativeDateLabel.text = relativeDateForEntry
    }
    
    func getNumDays(date: Date) -> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let formatter_2 = DateFormatter()
        formatter_2.dateFormat = "yyyy/MM/dd"
        
        var currentDate = formatter_2.string(from: Date())
        currentDate += " 00:00"
        
        var entryDate = formatter_2.string(from: date)
        entryDate += " 00:00"
        
        let currentDate_asDate = formatter.date(from: currentDate)
        let entryDate_asDate = formatter.date(from: entryDate)
        
        let numDays = Calendar.current.dateComponents([.day], from: entryDate_asDate!, to: currentDate_asDate!).day
        
        return numDays!
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
