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
        let sort = NSSortDescriptor(key: #keyPath(EntryEntity.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]

        //3
        do {
            entriesCD = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        // end of core data
        
        //add gradient to background
        gradient.frame = gradientView.bounds
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(plusButton)
        
        entryCollectionView.reloadData()
        entryCollectionView.collectionViewLayout.invalidateLayout()
        
        // Add shadow to plus button
        plusButton.layer.shadowColor = UIColor.darkGray.cgColor
        plusButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        plusButton.layer.shadowRadius = 5
        plusButton.layer.shadowOpacity = 0.5
        
        spotifyManager.refreshTokenIfNeeded()
    }
    
    @IBOutlet weak var entryCollectionView: UICollectionView!{
        didSet{
            entryCollectionView.dataSource = self
            entryCollectionView.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entry_clicked_obj = self.entriesCD[indexPath.row]
        let entry_clicked = getEntryFromNSObject(NS_entry: entry_clicked_obj)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return entriesCD.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as! EntryViewCell
        
        // Format cells to be white and have rounded edges
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.layer.masksToBounds = true
        
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
                devc.entry_to_display = entry_clicked
            }
        } else if segue.identifier == ""{
            
        }
    }
}


