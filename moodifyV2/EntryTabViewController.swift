//
//  EntryTabViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/3/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EntryTabViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    var entries = Entries.init()
    var entriesCD: [NSObject] = []
    var writeEntry: WriteEntryViewController?
    @IBOutlet weak var gradientView: UIView!
    let gradient = CAGradientLayer()
    public var newEntry = Entry()
    
    // Colors for gradient
    let pinkColor = UIColor(red: 250/225, green: 104/225, blue: 104/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 85/225, green: 127/225, blue: 242/225, alpha: 1).cgColor
    
    @IBOutlet weak var plusButton: UIButton!
    
    // CORE DATA
    func save(entry: Entry) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entry_entity = EntryEntity(context: managedContext)

        // 3
        entry_entity.setValue(entry.entryText, forKeyPath: "text")
        entry_entity.setValue(entry.location, forKeyPath: "location")
        entry_entity.setValue(entry.entryDate, forKeyPath: "date")
        
        // to do: set songs
        for track in entry.associatedTracks{
            let trackObj = TrackEntity(context: managedContext)
            trackObj.setValue(track.artistName, forKeyPath:"artistName")
            trackObj.setValue(track.trackName, forKeyPath:"trackName")
            let imageData = track.trackArtworkImage?.pngData()
            trackObj.setValue(imageData, forKeyPath:"coverArt")
            entry_entity.addToAssociatedTrack(trackObj)
        }
        
        // 4
        do {
            try managedContext.save()
            entriesCD.append(entry_entity)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // CORE DATA
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "EntryEntity")
        
        //3
        do {
            entriesCD = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        // end of core data
        
        if newEntry.entryText != ""{
            save(entry: newEntry)
            // reinit entry to be empty
            newEntry = Entry()
        }
        //add gradient to background
        gradient.frame = gradientView.bounds
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(plusButton)
        
        entryCollectionView.reloadData()
        entryCollectionView.collectionViewLayout.invalidateLayout()
    }

    
    
    @IBOutlet weak var entryCollectionView: UICollectionView!{
        didSet{
            entryCollectionView.dataSource = self
            entryCollectionView.delegate = self
        }
    }
    // don't think ever used anymore, delete
    func updateNewEntry(entry: Entry) {
        if(entries.entries_list.count > 0){
            entries.entries_list[0] = entry
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entry_clicked_obj = self.entriesCD[indexPath.row]
        let entry_clicked = getEntryFromNSObject(NS_entry: entry_clicked_obj)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        return entries.entries_list.count
        return entriesCD.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as! EntryViewCell
//        let entry = entries.entries_list[indexPath.row]
        let entry_obj = entriesCD[indexPath.row]
        // construct entry to display
        let entry = getEntryFromNSObject(NS_entry: entry_obj)
        cell.displayContent(entry: entry)
        return cell
    }
    
    func getTrackFromNSObject(NS_track:NSObject)->Track{
        let track = Track()
        track.trackName = NS_track.value(forKey: "trackName") as! String
        track.artistName = NS_track.value(forKey: "artistName") as! String
        
        let data = NS_track.value(forKey: "coverArt") as! Data
        track.trackArtworkImage = UIImage(data: data)
        return track
    }
    
    func getEntryFromNSObject(NS_entry:NSObject)->Entry{
        let entry = Entry()
        entry.entryDate = NS_entry.value(forKey: "date") as! Date
        entry.location = NS_entry.value(forKey: "location") as! String
        entry.entryText = NS_entry.value(forKey: "text") as! String
        let tracks_found = NS_entry.value(forKey: "associatedTrack") as! NSSet
        var tracks_assoc = [Track]()
        for track_entity in tracks_found{
            let track = getTrackFromNSObject(NS_track: track_entity as! NSObject)
            tracks_assoc.append(track)
        }
        entry.associatedTracks = tracks_assoc
        return entry
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "writeEntrySegue" {
            if let wevc = segue.destination as? WriteEntryViewController{
                wevc.updated_entries = entries
            }
        } else if segue.identifier == "viewEntrySegue" {
            if let devc = segue.destination as? DisplayEntryViewController {

                let entry_cell = sender as! UICollectionViewCell
                let indexPath = self.entryCollectionView!.indexPath(for: entry_cell)
                let entry_clicked_obj = self.entriesCD[indexPath!.row]
                let entry_clicked = getEntryFromNSObject(NS_entry: entry_clicked_obj)
//                let entry_clicked = self.entries.entries_list[indexPath!.row]
                devc.entry_to_display = entry_clicked
            }
        } else if segue.identifier == ""{
            
        }
    }
}
