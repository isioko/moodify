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

class WriteEntryViewController:UIViewController, UITextFieldDelegate, UITextViewDelegate,CLLocationManagerDelegate {
    
    let gradient = CAGradientLayer()
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var entryTextView: UITextView!
    
    var alreadySavedEntry = false
    public var todays_tracks = [Track]()
    public var new_entry = Entry.init()
    public var updated_entries = Entries.init()
    public var selectedTracks = [Track]()
    public var selectedRows:[Bool] = [] // added this
    
    // MARK - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // Colors for gradient
    let pinkColor = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 102/225, green: 140/225, blue: 225/225, alpha: 1).cgColor
        
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTextView.layer.cornerRadius = 8
        entryTextView.clipsToBounds = true
        entryTextView.delegate = self
        locationManager.delegate = self
        if todays_tracks.count == 0 {
            displayTracks()
        }
        loadLocation()
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
    
    @IBOutlet weak var locationLabel: UILabel!
    
    //https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
    let locationManager = CLLocationManager()
    public var location = ""

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
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
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(addButton)
        gradientView.addSubview(cancelButton)
        gradientView.addSubview(entryTextView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
        if let entry_text = entryTextView.text{
            new_entry.entryText = entry_text
        }
        if let location = locationLabel.text{
            new_entry.location = "@" + location
        }
        new_entry.associatedTracks = selectedTracks
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseMusicSegue" {
            if let drpvc = segue.destination as? DisplayRecentlyPlayedViewController{
                drpvc.todays_tracks = todays_tracks
                drpvc.selectedRows = selectedRows
                if let entry_text = entryTextView.text{
                    drpvc.entryText = entry_text
                }
            }
        }else if segue.identifier == "showEntriesSegue"{
            if let etvc = segue.destination as? EntryTabViewController{
                etvc.newEntry = new_entry
            }
        }
    }
}
