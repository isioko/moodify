//
//  ViewAssociatedEntriesViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/16/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewAssociatedEntriesViewController: UIViewController, UICollectionViewDataSource {
    public var entries = [Entry]()
    var track_to_display = Track.init()
    var core_data_objs: [NSObject] = []
    public var entry_to_display = Entry.init()
    let gradient = CAGradientLayer()
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var songBubbleView: UIView!
    @IBOutlet weak var sentiFace: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var coverArtImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var numEntriesLabel: UILabel!
    
    @IBOutlet weak var assocEntriesCollectionView: UICollectionView! {
        didSet {
            assocEntriesCollectionView.dataSource = self
            assocEntriesCollectionView.delegate = self
        }
    }
    
    func loadCoreData(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TrackEntity")
        fetchRequest.fetchLimit = 5
        fetchRequest.predicate = NSPredicate(format: "trackName == %@", track_to_display.trackName)
        
        do {
            core_data_objs = try managedContext.fetch(fetchRequest)
            if core_data_objs.count >= 1{
                print("SUCCESS")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func sentimentAnalysisForSong(track_obj: Track){
        let assoc_entries = track_obj.associatedEntries

        let sentiment = Sentimently()
        var total = 0
        for assoc_entry in assoc_entries{
            print(assoc_entry.entryText)
            entries.append(assoc_entry)
            total += sentiment.score(assoc_entry.entryText).score
            print(sentiment.score(assoc_entry.entryText)) //TEST
            
        }
        //Get average sentiment of associated entries
        total = total/assoc_entries.count
        displaySentiment(score: total)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        gradient.frame = gradientView.bounds
        gradient.colors = Constants.themeColors()
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        songBubbleView.backgroundColor = UIColor.white
        songBubbleView.layer.cornerRadius = 8.0
        songBubbleView.layer.masksToBounds = true
        
        loadCoreData()
        
        // add entries to datasource
        // TO DO: get tracks from Core Data so can display sorted
        let track = getTrackFromNSObject(NS_track: core_data_objs[0] )
        sentimentAnalysisForSong(track_obj: track)
        assocEntriesCollectionView.reloadData()
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        coverArtImage.image = track.trackArtworkImage
    }
    
    func displaySentiment(score:Int){
        // pull appropriate index from that array
        //center score at 3
        sentiFace.layer.cornerRadius = 8.0
        sentiFace.clipsToBounds = true
        // create array of all faces
        var images : [UIImage] = []
        let strings : [String] = ["😩","☹️","😕","😐","🙂","😀","😁"]
        // <= -5, -5 < -3, -3 < -1, 0
        for s in strings {
            images.append(s.emojiToImage()!)
        }
        var ind = (score + 5)/2
        if ind < 0 {ind = 0}
        if ind > strings.count-1 {ind = strings.count-1}
        if score == 0 {ind = 3} //don't round down on 0 entries
        sentiFace.image = images[ind]
    }

    func getEntryFromNSObject(NS_entry:NSObject)->Entry {
        let entry = Entry()
        entry.entryDate = NS_entry.value(forKey: "date") as! Date
        entry.location = NS_entry.value(forKey: "location") as! String
        entry.entryText = NS_entry.value(forKey: "text") as! String
        entry.numAssociatedTracks = NS_entry.value(forKey: "numAssociatedTracks") as! Int
        return entry
    }

    func getTrackFromNSObject(NS_track:NSObject)->Track {
        let track = Track()
        track.trackName = NS_track.value(forKey: "trackName") as! String
        track.artistName = NS_track.value(forKey: "artistName") as! String
        let entries_found = NS_track.value(forKey: "associatedEntry") as! NSSet
        var entries_assoc = [Entry]()
        
        var numEntries: Int = 0
        
        for entry_entity in entries_found { 
            let entry = getEntryFromNSObject(NS_entry: entry_entity as! NSObject)
            entries_assoc.append(entry)
            numEntries += 1
        }
        
        numEntriesLabel.text = String(numEntries)
        numEntriesLabel.textAlignment = .left
        track.associatedEntries = entries_assoc
        let data = NS_track.value(forKey: "coverArt") as! Data
        track.trackArtworkImage = UIImage(data: data)
        return track
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneWithViewingAssociationsSegue" {
            if let devc = segue.destination as? DisplayEntryViewController {
                
                devc.entry_to_display = entry_to_display
            }
        } else if segue.identifier == "inspectAssociatedEntrySegue" {
            if let devc = segue.destination as? DisplayEntryViewController {
                let entry_cell = sender as! AssociatedEntryViewCell
                let indexPath = self.assocEntriesCollectionView!.indexPath(for: entry_cell)
                let entry = entries[(indexPath?.row)!]

                devc.entry_to_display = entry
            }
        }
    }
}

extension ViewAssociatedEntriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell_width = collectionView.bounds.width
        let cell_height: CGFloat = 105
        return CGSize(width: cell_width, height: cell_height)
    }
}
extension ViewAssociatedEntriesViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "assocEntryCell", for: indexPath) as! AssociatedEntryViewCell
        
        // Format cells to be white and have rounded edges
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.layer.masksToBounds = true
        
        let entry_obj = entries[indexPath.row]
        cell.displayContent(entry: entry_obj)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entries.count
    }

}
