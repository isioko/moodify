//
//  WriteEntryViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/3/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreData


class WriteEntryViewController:UIViewController {
    
    let gradient = CAGradientLayer()
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBOutlet weak var tracksForEntryView: UIView!
    @IBOutlet weak var entryTextBubbleView: UIView!
    
    public var todays_tracks = [Track]()
    public var new_entry = Entry.init()
    public var updated_entries = [Entry]()
    public var selectedTracks = [Track]()
    public var selectedRows:[Bool] = [] // added this
    public var selectedTracksString = ""
    
    
    let PLACEHOLDER_TEXT = "What's on your mind?"

    // Buttons
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var selectedTracksLabel: UILabel!
    // variables for location feature
    let locationManager = CLLocationManager()
    public var location = ""
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make all views have rounded edges
        entryTextBubbleView.layer.cornerRadius = 8
        entryTextBubbleView.clipsToBounds = true
        tracksForEntryView.layer.cornerRadius = 8
        tracksForEntryView.clipsToBounds = true
        locationView.layer.cornerRadius = 8
        locationView.clipsToBounds = true
        
        entryTextView.delegate = self
        locationManager.delegate = self
        if todays_tracks.count == 0 {
            displayTracks()
        }
        loadLocation()
        if selectedTracksString != "" {
            selectedTracksLabel.text = selectedTracksString
            selectedTracksLabel.textColor = UIColor.black
        } else {
            selectedTracksLabel.text = "Add your soundtrack"
            selectedTracksLabel.textColor = UIColor.lightGray
        }
    }

    func displayTracks() {
        var doneTracks = false
        spotifyManager.getRecentPlayed { (tracks) in
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            if !doneTracks {
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.gray
                loadingIndicator.startAnimating();
                
                alert.view.addSubview(loadingIndicator)
                self.present(alert, animated: true, completion: nil)
            }
            
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
            doneTracks = true
            
            if doneTracks {
                if self.selectedRows.count == 0 {
                    for _ in 1...self.todays_tracks.count {
                        self.selectedRows.append(false)
                    }
                }
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadLocation()
        entryTextView.text = new_entry.entryText
        gradient.frame = gradientView.bounds
        gradient.colors = Constants.themeColors()
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(addButton)
        gradientView.addSubview(cancelButton)
        
        // START: Placeholder Text
        if entryTextView.text == "" {
            entryTextView.text = PLACEHOLDER_TEXT
            entryTextView.textColor = UIColor.lightGray
        }
        // END: Placeholder text
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
        if entryTextView.text != PLACEHOLDER_TEXT {
            if let entry_text = entryTextView.text {
                new_entry.entryText = entry_text
            }
        } else {
            new_entry.entryText = " "
        }
        
        if let location = locationLabel.text {
            new_entry.location = location
        }
        
        new_entry.associatedTracks = selectedTracks
        new_entry.numAssociatedTracks = selectedTracks.count
        save(entry: new_entry)
    }
    
    // CORE DATA
    var core_data_objs: [NSObject] = []
    func save(entry: Entry) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // create CoreData representation of the new entry
        let entry_entity = EntryEntity(context: managedContext)
        entry_entity.setValue(entry.entryText, forKeyPath: "text")
        entry_entity.setValue(entry.location, forKeyPath: "location")
        entry_entity.setValue(entry.entryDate, forKeyPath: "date")
        entry_entity.setValue(entry.numAssociatedTracks, forKeyPath: "numAssociatedTracks")
        // load all the tracks associated with entry into CoreData
        var trackEntries = [NSObject]()
        for track in entry.associatedTracks{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackEntity")
            let predicate = NSPredicate(format: "trackName == %@", track.trackName)
            request.predicate = predicate
            request.fetchLimit = 1
            do{
                var foundTracks = try managedContext.fetch(request)
                let count = try managedContext.count(for: request)
                if(count == 0){
                    // no matching object
                    let trackObj = TrackEntity(context: managedContext)
                    trackObj.setValue(track.artistName, forKeyPath:"artistName")
                    trackObj.setValue(track.trackName, forKeyPath:"trackName")
                    let imageData = track.trackArtworkImage?.pngData()
                    trackObj.setValue(imageData, forKeyPath:"coverArt")
                    entry_entity.addToAssociatedTrack(trackObj)
                    trackObj.addToAssociatedEntry(entry_entity)
                    trackEntries.append(trackObj)
                }
                else{
                    // at least one matching object exists
                    let trackObj = foundTracks[0] as! TrackEntity
                    trackObj.setValue(track.artistName, forKeyPath:"artistName")
                    trackObj.setValue(track.trackName, forKeyPath:"trackName")
                    let imageData = track.trackArtworkImage?.pngData()
                    trackObj.setValue(imageData, forKeyPath:"coverArt")
                    entry_entity.addToAssociatedTrack(trackObj)
                    trackObj.addToAssociatedEntry(entry_entity)
                }
            }
            catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    
        do {
            try managedContext.save()
            core_data_objs.insert(entry_entity, at: 0)
            for trackObj in trackEntries{
                core_data_objs.append(trackObj)
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // keep track of entry text when go to choose music, not in core data yet because haven't saved
        if segue.identifier == "chooseMusicSegue" {
            if let drpvc = segue.destination as? DisplayRecentlyPlayedViewController{
                drpvc.todays_tracks = todays_tracks
                drpvc.selectedRows = selectedRows
                if let entry_text = entryTextView.text {
                    if entry_text != PLACEHOLDER_TEXT {
                        drpvc.entryText = entry_text
                    } else {
                        drpvc.entryText = ""
                    }
                }
            }
        }
    }
}

extension WriteEntryViewController: CLLocationManagerDelegate{
    //https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lookUpCurrentLocation(completionHandler: {completionHandler in
            if let completionHandler = completionHandler{
                if let new_location = completionHandler.locality{
                    self.location = new_location
                }
            }
        }
        )
        if location != ""{
            locationLabel.text = location
        }
    }
    
    //https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    func loadLocation(){
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            if location != ""{
                locationManager.stopUpdatingLocation()
                locationLabel.text = location
            }
        }
    }
}

extension WriteEntryViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
}

extension WriteEntryViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if entryTextView.textColor == UIColor.lightGray {
            entryTextView.text = nil
            entryTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if entryTextView.text.isEmpty {
            entryTextView.text = PLACEHOLDER_TEXT
            entryTextView.textColor = UIColor.lightGray
        }
    }
}
