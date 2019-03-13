//
//  DisplayEntryViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/5/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DisplayEntryViewController: UIViewController, UICollectionViewDataSource{
    let gradient = CAGradientLayer()
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    public var entry_to_display = Entry.init()
    public var selectedTracks = [Track]()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateBubbleLabel: UILabel!

    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var locationBubbleView: UIView!
    @IBOutlet weak var dateBubbleView: UIView!
    @IBOutlet weak var entryTextBubbleView: UIView!
    @IBOutlet weak var trackBubbleView: UIView!
    var core_data_objs: [NSObject] = []
    // Collection View
    @IBOutlet weak var trackCollectionView: UICollectionView! {
        didSet {
            trackCollectionView.dataSource = self
            trackCollectionView.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadCoreData()
        initializeUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackCollectionView.dataSource = self
        trackCollectionView.delegate = self
        trackCollectionView.reloadData()
    }
    
    func initializeUI(){
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

        entry_to_display = getEntryFromNSObject(NS_entry: core_data_objs[0])
        trackCollectionView.reloadData()
        
        if entry_to_display.associatedTracks.count == 0 {
            trackCollectionView.isHidden = true
            trackCollectionView.alpha = 0
            trackBubbleView.isHidden = true
            trackCollectionView.alpha = 0
        }
        
        trackCollectionView.reloadData()
        entryTextView.text = entry_to_display.entryText
        gradient.frame = gradientView.bounds
        gradient.colors = Constants.themeColors()
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(doneButton)
    }
    
    func loadCoreData(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "EntryEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "date == %@", entry_to_display.entryDate as CVarArg)
        
        do {
            core_data_objs = try managedContext.fetch(fetchRequest)
            if core_data_objs.count >= 1{
                print("SUCCESS")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getEntryFromNSObject(NS_entry:NSObject)->Entry {
        let entry = Entry()
        entry.entryDate = NS_entry.value(forKey: "date") as! Date
        entry.location = NS_entry.value(forKey: "location") as! String
        entry.entryText = NS_entry.value(forKey: "text") as! String
        
        let tracks_found = NS_entry.value(forKey: "associatedTrack") as! NSSet
        var tracks_assoc = [Track]()
        for track_entity in tracks_found {
            let track = getTrackFromNSObject(NS_track: track_entity as! NSObject)
            tracks_assoc.append(track)
        }
        entry.associatedTracks = tracks_assoc
        return entry
    }

    func getTrackFromNSObject(NS_track:NSObject)->Track {
        let track = Track()
        track.trackName = NS_track.value(forKey: "trackName") as! String
        track.artistName = NS_track.value(forKey: "artistName") as! String
        
        let data = NS_track.value(forKey: "coverArt") as! Data
        track.trackArtworkImage = UIImage(data: data)
        return track
    }
    
    //Delete an entry. NOTE: makes use of isEqual function in Entry, which does not walk through tracks.
    // Improvement: add notification upon arriving back at entry tab view controller that an entry has been deleted.
    @IBAction func clickDelete(_ sender: UIButton) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EntryEntity")
        var core_data_entries: [NSObject] = []
        
        do {
            core_data_entries = try context.fetch(fetchRequest)
            for obj in core_data_entries {
                let compare_with = getEntryFromNSObject(NS_entry: obj)
                if compare_with.isEqual(compare_with: entry_to_display) {
                    context.delete(obj as! NSManagedObject)
                    try context.save()
                    break
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAssociatedEntriesSegue" {
            if let vaevc = segue.destination as? ViewAssociatedEntriesViewController {
                
                let track_cell = sender as! DisplayTrackCollectionViewCell
                let indexPath = self.trackCollectionView!.indexPath(for: track_cell)
                let track = entry_to_display.associatedTracks[(indexPath?.row)!]

                vaevc.entry_to_display = entry_to_display
                vaevc.track_to_display = track
            }
        }
    }
}

extension DisplayEntryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell_width = collectionView.bounds.width
        let cell_height: CGFloat = 105
        return CGSize(width: cell_width, height: cell_height)
    }
}

extension DisplayEntryViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "displayTrackCollectionViewCell", for: indexPath) as! DisplayTrackCollectionViewCell
        let track = entry_to_display.associatedTracks[indexPath.row]
        cell.displayTrack(track: track)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entry_to_display.associatedTracks.count
    }
}
