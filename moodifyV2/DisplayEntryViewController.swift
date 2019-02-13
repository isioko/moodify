//
//  DisplayEntryViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/5/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class DisplayEntryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    // Colors for gradient
    let pinkColor = UIColor(red: 250/225, green: 104/225, blue: 104/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 85/225, green: 127/225, blue: 242/225, alpha: 1).cgColor
    let gradient = CAGradientLayer()
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var entryTextView: UITextView!
    
    public var entry_to_display = Entry.init()
    public var selectedTracks = [Track]()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateBubbleLabel: UILabel!
    
    @IBOutlet weak var locationBubbleView: UIView!
    @IBOutlet weak var dateBubbleView: UIView!
    @IBOutlet weak var entryTextBubbleView: UIView!
    @IBOutlet weak var trackBubbleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackCollectionView.dataSource = self
        trackCollectionView.delegate = self
        trackCollectionView.reloadData()
        
        entryTextView.text = entry_to_display.entryText
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        
        let formatter_time = DateFormatter()
        formatter_time.dateFormat = "h:mm a"
        
        dateBubbleLabel.text = formatter.string(from: entry_to_display.entryDate) + " @ " + formatter_time.string(from: entry_to_display.entryDate)
        dateLabel.text = entry_to_display.relativeDate
        locationLabel.text = entry_to_display.location
        
                // Make all views have rounded edges
        entryTextBubbleView.layer.cornerRadius = 8
        entryTextBubbleView.clipsToBounds = true
        dateBubbleView.layer.cornerRadius = 8
        dateBubbleView.clipsToBounds = true
        locationBubbleView.layer.cornerRadius = 8
        locationBubbleView.clipsToBounds = true
        trackBubbleView.layer.cornerRadius = 8
        trackBubbleView.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if entry_to_display.associatedTracks.count == 0{
            trackCollectionView.isHidden = true
            trackCollectionView.alpha = 0
            trackBubbleView.isHidden = true
            trackCollectionView.alpha = 0
        }
        trackCollectionView.reloadData()
        entryTextView.text = entry_to_display.entryText
        gradient.frame = gradientView.bounds
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(doneButton)
        
    }
    
    // Collection View
    @IBOutlet weak var trackCollectionView: UICollectionView!{
        didSet {
            trackCollectionView.dataSource = self
            trackCollectionView.delegate = self
        }
    }
    
    /* Collection View delegate functions */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entry_to_display.associatedTracks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "displayTrackCollectionViewCell", for: indexPath) as! DisplayTrackCollectionViewCell
        let track = entry_to_display.associatedTracks[indexPath.row]
        cell.displayTrack(track: track)
        return cell
    }
    
}
