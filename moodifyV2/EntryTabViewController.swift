//
//  EntryTabViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/3/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class EntryTabViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, SaveNewEntryDelegate{
    var entries = Entries.init()
    var writeEntry: WriteEntryViewController?
    @IBOutlet weak var gradientView: UIView!
    let gradient = CAGradientLayer()
    public var todays_tracks = [Track]()
    // Colors for gradient
    let pinkColor = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 102/225, green: 140/225, blue: 225/225, alpha: 1).cgColor
    
    @IBOutlet weak var plusButton: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //add gradient to background
        gradient.frame = gradientView.bounds
        //gradient.colors = [UIColor.magenta.cgColor, UIColor.blue.cgColor]
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(plusButton)
        entryCollectionView.reloadData()
        entryCollectionView.collectionViewLayout.invalidateLayout()
        
        
    }
    
    
    @IBAction func backFromModal(_ segue: UIStoryboardSegue){
        self.tabBarController?.selectedIndex = 0
    }

    @IBOutlet weak var entryCollectionView: UICollectionView!{
        didSet{
            entryCollectionView.dataSource = self
            entryCollectionView.delegate = self
        }
    }
 
    func saveNewEntry(entry: Entry) {
        entries.entries_list.insert(entry, at:0)
    }
    
    func updateNewEntry(entry: Entry) {
        if(entries.entries_list.count > 0){
            entries.entries_list[0] = entry
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entry_i = indexPath.row
        let entry_to_send = entries.entries_list[entry_i]
//        performSegue(withIdentifier: "viewEntrySegue", sender: self)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return entries.entries_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as! EntryViewCell
        let entry = entries.entries_list[indexPath.row]
        cell.displayContent(entry: entry)
        //cell.layer.cornerRadius = 2.0
        
        return cell
    }
    
    override func viewDidLoad() {
        displayTracks()
    }

    func displayTracks() {
        spotifyManager.getRecentPlayed { (tracks) in
            let group = DispatchGroup()
            tracks.forEach { track in
                group.enter()
                
                let track_name = track.0
                let artist_name = track.1
                let image_url = track.2
                
                let new_track = Track()
                new_track.trackName = track_name
                new_track.artistName = artist_name
                
                let url = URL(string: image_url)
                do {
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
                    new_track.trackArtworkImage = image
                } catch {
                    print("error")
                }
                
                self.todays_tracks.append(new_track)
                
                group.leave()
            }
            print("DONE TRACKS")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "writeEntrySegue" {
            if let wevc = segue.destination as? WriteEntryViewController{
                wevc.updated_entries = entries
                wevc.delegate = self
                wevc.todays_tracks = self.todays_tracks
            }
        } else if segue.identifier == "viewEntrySegue" {
            if let devc = segue.destination as? DisplayEntryViewController {

                let entry_cell = sender as! UICollectionViewCell
                let indexPath = self.entryCollectionView!.indexPath(for: entry_cell)
                let entry_clicked = self.entries.entries_list[indexPath!.row]
                devc.entry_to_display = entry_clicked
            }
        } else if segue.identifier == ""{
            
        }
    }
}
