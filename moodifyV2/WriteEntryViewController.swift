//
//  WriteEntryViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/3/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

protocol SaveNewEntryDelegate {
    func saveNewEntry(entry: Entry)
    func updateNewEntry(entry: Entry)
}

class WriteEntryViewController:UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var delegate:SaveNewEntryDelegate?
    
    let gradient = CAGradientLayer()
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var entryTextView: UITextView!
    
    var alreadySavedEntry = false
    public var todays_tracks = [Track]()
    public var new_entry = Entry.init()
    public var updated_entries = Entries.init()
    public var selectedRows:[Bool] = [] // added this
    
    // MARK - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    // Colors for gradient
    let pinkColor = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 102/225, green: 140/225, blue: 225/225, alpha: 1).cgColor
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTextView.layer.cornerRadius = 8
        entryTextView.clipsToBounds = true
        entryTextView.delegate = self
        
        if todays_tracks.count == 0 {
            displayTracks()
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
        gradient.frame = gradientView.bounds
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(doneButton)
        gradientView.addSubview(saveButton)
        gradientView.addSubview(entryTextView)
        print(selectedRows) // aded this
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func clickSave(_ sender: UIButton) {
        if let entry_text = entryTextView.text{
            new_entry.entryText = entry_text
        }
        if(alreadySavedEntry){
            delegate?.updateNewEntry(entry: new_entry)
        }else{
            delegate?.saveNewEntry(entry: new_entry)
            alreadySavedEntry = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseMusicSegue" {
            if let drpvc = segue.destination as? DisplayRecentlyPlayedViewController{
                drpvc.todays_tracks = todays_tracks
                drpvc.selectedRows = selectedRows
            }
        }
    }
    
}
