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

// search controller tutorial: https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started

class EntryTabViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UISearchControllerDelegate{
    var entries = [Entry]()
    var core_data_entries: [NSObject] = []
    var writeEntry: WriteEntryViewController?
    @IBOutlet weak var gradientView: UIView!
    let gradient = CAGradientLayer()
    public var newEntry = Entry()
    
    //search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var plusButton: UIButton!
    var filteredEntries = [NSObject]()
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Entries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredEntries = core_data_entries.filter({( entry_obj : NSObject) -> Bool in
            let entry = getEntryFromNSObject(NS_entry: entry_obj)
            return entry.entryText.lowercased().contains(searchText.lowercased())
        })
        
        entryCollectionView.reloadData()
        entryCollectionView.collectionViewLayout.invalidateLayout()

    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
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
        let sort = NSSortDescriptor(key: #keyPath(EntryEntity.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]

        //3
        do {
            core_data_entries = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        // end of core data
        
        //add gradient to background
        gradient.frame = gradientView.bounds
        gradient.colors = Constants.themeColors()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isFiltering() {
            return filteredEntries.count
        }
        
        return core_data_entries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as! EntryViewCell
        
        // Format cells to be white and have rounded edges
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.layer.masksToBounds = true
        let entry_obj: NSObject
        if isFiltering(){
            entry_obj = filteredEntries[indexPath.row]
        }else{
            entry_obj = core_data_entries[indexPath.row]
        }
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
                let entry_clicked_obj: NSObject
                if isFiltering(){
                    entry_clicked_obj = filteredEntries[indexPath!.row]
                }else{
                    entry_clicked_obj = core_data_entries[indexPath!.row]
                }
//                let entry_clicked_obj = self.core_data_entries[indexPath!.row]
                let entry_clicked = getEntryFromNSObject(NS_entry: entry_clicked_obj)
                devc.entry_to_display = entry_clicked
            }
        } else if segue.identifier == ""{
            
        }
    }
}


extension EntryTabViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
