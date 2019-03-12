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

class EntryTabViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchControllerDelegate {
    
    enum scopeConstants {
        static let entriesOnly = "Entries Only"
        static let songsOnly = "Songs Only"
    }
    public var entriesOnlyScope = true
    var entries = [Entry]()
    var core_data_entries: [NSObject] = []
    var core_data_tracks: [NSObject] = []
    
    var filteredEntriesByDate = [NSObject]()

    var writeEntry: WriteEntryViewController?
    @IBOutlet weak var gradientView: UIView!
    let gradient = CAGradientLayer()
    public var newEntry = Entry()
    public var currentSearchString = ""
    public var showMemoryPopup = true
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect.zero)

    //search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var plusButton: UIButton!
    var filteredEntries = [NSObject]()
    var filteredTracks = [NSObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        // if searchText is nothing, display all entries & songs
        if searchText == "" {
            filteredEntries = core_data_entries
            entryCollectionView.reloadData()
            entryCollectionView.collectionViewLayout.invalidateLayout()
            return
        }
        
        if scope == scopeConstants.entriesOnly {
            // displays entries which have text that match search criteria
            filteredEntries = core_data_entries.filter({( entry_obj : NSObject) -> Bool in
                let entry = getEntryFromNSObject(NS_entry: entry_obj)
                return entry.entryText.lowercased().contains(searchText.lowercased())
            })
        } else {
            // displays entries which have songs that match search criteria
            filteredTracks = core_data_tracks.filter({( track_obj : NSObject) -> Bool in
            let track = getTrackFromNSObject(NS_track: track_obj)
                // filter on track name and artist name
                return track.trackName.lowercased().contains(searchText.lowercased())
            })
            // filter on artist name
            let filteredTracksByArtist = core_data_tracks.filter({( track_obj : NSObject) -> Bool in
                let track = getTrackFromNSObject(NS_track: track_obj)
                return track.artistName.lowercased().contains(searchText.lowercased())
            })
            filteredTracks += filteredTracksByArtist
            filteredEntries.removeAll()
            var filteredTrackNames = [String]()
            if filteredTracks.count == 0 {
                entryCollectionView.reloadData()
                entryCollectionView.collectionViewLayout.invalidateLayout()
                return
            }
            for track_obj in filteredTracks {
                let track = getTrackFromNSObject(NS_track: track_obj)
                filteredTrackNames.append(track.trackName)
            }
            let filtered_track = filteredTrackNames[0]
            for entry_obj in core_data_entries {
                let entry = getEntryFromNSObject(NS_entry: entry_obj)
                let assoc_tracks = entry.associatedTracks
                let filtered_assoc_tracks = assoc_tracks.filter({( track : Track) -> Bool in
                    return filtered_track.lowercased().contains(track.trackName.lowercased())
                })
                if filtered_assoc_tracks.count > 0 {
                    filteredEntries.append(entry_obj)
                }
            }
        }
        entryCollectionView.reloadData()
        entryCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }

    func setUpSearch() {
        // Setup the Search Controller
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Entries"
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        // set up scope bar for search
        searchController.searchBar.scopeButtonTitles = [scopeConstants.entriesOnly, scopeConstants.songsOnly]
        searchController.searchBar.delegate = self
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 55, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "moodify-start-logo-01.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func setUpSearchGraphics(){
        searchController.searchBar.tintColor = UIColor.white
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            //            textfield.textColor = UIColor.black
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
            
            // Change placeholder color to white
            let textfieldLabel = textfield.value(forKey: "placeholderLabel") as? UILabel
            textfieldLabel?.textColor = UIColor.white
        }
        // Change search icon
        searchController.searchBar.setImage(UIImage(named: "searchBar"), for: .search, state: .normal)
        
        searchController.searchBar.isTranslucent = true
    }
    
    func getYesterdaysEntries() {
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy/MM/dd"
        
        let today = Date()
        let yesterday = today.addingTimeInterval(TimeInterval(-60*60*24))
        let yesterdayString = date_formatter.string(from: yesterday)
        
        // for testing
//        let todayString = date_formatter.string(from: today)
        
        filteredEntriesByDate = core_data_entries.filter({( entry_obj : NSObject) -> Bool in
            let entry = getEntryFromNSObject(NS_entry: entry_obj)
            let entryDateString = date_formatter.string(from: entry.entryDate)
            return entryDateString == yesterdayString

            // for testing
//            return entryDateString == todayString

        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUpSearch()
        setUpSearchGraphics()
        // CORE DATA
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequestMemory = NSFetchRequest<NSManagedObject>(entityName: "MemoryEntity")
        let fetchRequestSearch = NSFetchRequest<NSManagedObject>(entityName: "SearchEntity")

        let fetchRequestSongs = NSFetchRequest<NSManagedObject>(entityName: "TrackEntity")
        let fetchRequestEntries =
            NSFetchRequest<NSManagedObject>(entityName: "EntryEntity")
        let sort = NSSortDescriptor(key: #keyPath(EntryEntity.date), ascending: false)
        fetchRequestEntries.sortDescriptors = [sort]

        //3
        do {
            core_data_entries = try managedContext.fetch(fetchRequestEntries)
            core_data_tracks = try managedContext.fetch(fetchRequestSongs)
            // get search string and scope values
            let search_memory = try managedContext.fetch(fetchRequestSearch)
            if search_memory.count > 0{
                entriesOnlyScope = search_memory[0].value(forKey: "entriesOnlyScopeBool") as! Bool
                currentSearchString = search_memory[0].value(forKey: "searchString") as! String
            }
            // get var to know if user has "exxed" out of NotificationViewController previously
            let memory_saved_pref = try managedContext.fetch(fetchRequestMemory)
            if memory_saved_pref.count > 0 {
                showMemoryPopup = memory_saved_pref[0].value(forKey: "showBool") as! Bool
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        // end of core data
        
        if currentSearchString != "" {
            searchController.isActive = true
            searchController.searchBar.text = currentSearchString
            if !entriesOnlyScope{
                navigationItem.searchController!.searchBar.selectedScopeButtonIndex = 1
            }
            filterContentForSearchText(currentSearchString)
        }
        getYesterdaysEntries()
        
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy/MM/dd"
        
        let dateString = date_formatter.string(from: Date())
        
        let lastNotificationDate = UserDefaults.standard.string(forKey: "lastNotificationDate")
        let lastClosedNotification = UserDefaults.standard.string(forKey: "lastClosedNotification")
        
        
        if lastClosedNotification != dateString {
            if lastNotificationDate != dateString && filteredEntriesByDate.count > 0  {
                print("send notification")
            
                UserDefaults.standard.set(dateString, forKey: "lastNotificationDate")
                self.performSegue(withIdentifier: "toNotificationSegue", sender: self)
            } else {
                print("do not send notification")
            }
        }
        
        // Uncomment line below to play with the notification pop up
//            self.performSegue(withIdentifier: "toNotificationSegue", sender: self)
        
        // Add gradient to background
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
        
        
        navigationController?.navigationBar.isTranslucent = true
        
        // remove navigation background
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // change search bar settings
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.isTranslucent = false
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search Entries", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @IBOutlet weak var entryCollectionView: UICollectionView!{
        didSet{
            entryCollectionView.dataSource = self
            entryCollectionView.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isFiltering() && searchController.searchBar.text != ""{
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
        if isFiltering() && searchController.searchBar.text != ""{
            entry_obj = filteredEntries[indexPath.row]
        } else {
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
        updateCoreDataForSearch()
        if segue.identifier == "writeEntrySegue" {
            if let wevc = segue.destination as? WriteEntryViewController{
                wevc.updated_entries = entries
            }
        } else if segue.identifier == "viewEntrySegue" {
            if let devc = segue.destination as? DisplayEntryViewController {

                let entry_cell = sender as! UICollectionViewCell
                let indexPath = self.entryCollectionView!.indexPath(for: entry_cell)
                let entry_clicked_obj: NSObject
                if isFiltering() && searchController.searchBar.text != "" {
                    entry_clicked_obj = filteredEntries[indexPath!.row]
                } else {
                    entry_clicked_obj = core_data_entries[indexPath!.row]
                }
                let entry_clicked = getEntryFromNSObject(NS_entry: entry_clicked_obj)
                devc.entry_to_display = entry_clicked
            }
        } 
    }
    
    
    func updateCoreDataForSearch(){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchEntity")
        do{
            
            let count = try managedContext.count(for: request)
            var foundSearch = try managedContext.fetch(request)
            
            
            if(count == 0) {
                // no matching object
                let searchObj = SearchEntity(context: managedContext)
                searchObj.setValue(entriesOnlyScope, forKeyPath:"entriesOnlyScopeBool")
                searchObj.setValue(currentSearchString, forKeyPath:"searchString")
                
            } else {
                let searchObj = foundSearch[0] as! SearchEntity
                searchObj.setValue(entriesOnlyScope, forKeyPath:"entriesOnlyScopeBool")
                searchObj.setValue(currentSearchString, forKeyPath:"searchString")

            }
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
}


extension EntryTabViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        searchBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        currentSearchString = searchController.searchBar.text!
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension EntryTabViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0{
            entriesOnlyScope = true
        } else {
            entriesOnlyScope = false
        }
        filterContentForSearchText(searchBar.text!, scope:
            searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearchString = searchText
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        currentSearchString = searchBar.text!
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
    }
}

extension EntryTabViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell_width = collectionView.bounds.width
        let cell_height: CGFloat = 105
        return CGSize(width: cell_width, height: cell_height)
    }
}
