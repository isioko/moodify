//
//  DisplayRecentlyPlayedViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/5/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class DisplayRecentlyPlayedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // Gradient Color Constants
    let pinkColorUI = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 1)
    let pinkColor = UIColor(red: 250/225, green: 104/225, blue: 104/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 85/225, green: 127/225, blue: 242/225, alpha: 1).cgColor
    public var entryText = ""
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var aBackButton: UIButton!
    
    let gradient = CAGradientLayer()
    
    public var selectedRows:[Bool] = [] 
    var selectedTracks:[Track] = []
    public var selectedTracksString = ""
    
    public var todays_tracks = [Track()]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todays_tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackTableViewCell", for: indexPath) as! TrackTableViewCell
        let track = todays_tracks[indexPath.row]
        cell.displayTrack(track: track)
        
        if selectedRows[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.setNeedsLayout()
        
        return cell
    }
    
    @IBOutlet weak var trackTableView: UITableView!{
        didSet {
            trackTableView.dataSource = self
            trackTableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        trackTableView.dataSource = self
        trackTableView.delegate = self
        trackTableView.reloadData()
        
        trackTableView.layer.cornerRadius = 8.0
        trackTableView.clipsToBounds = true
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
            
            print("DONE TRACKS")
            if doneTracks {
                print("CALLED DISMISS")
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRows[indexPath.row] = !selectedRows[indexPath.row]

        if selectedRows[indexPath.row] {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        gradient.frame = gradientView.bounds
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(trackTableView)
        trackTableView.reloadData()
    }
    
    func populateSelectedTracks() {
        for i in 0..<todays_tracks.count {
            if selectedRows[i] {
                selectedTracks.append(todays_tracks[i])
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToWriteEntrySegue" {
            if let wevc = segue.destination as? WriteEntryViewController {
                wevc.todays_tracks = self.todays_tracks
                populateSelectedTracks()
                
                if selectedTracks.count > 0 {
                    for i in 0..<selectedTracks.count - 1 {
                        selectedTracksString += selectedTracks[i].trackName + ", "
                    }
                    selectedTracksString += selectedTracks[selectedTracks.count - 1].trackName
                }
                
                wevc.selectedTracks = selectedTracks
                wevc.selectedRows = self.selectedRows
                wevc.new_entry.entryText = self.entryText
                wevc.selectedTracksString = selectedTracksString
            }
        }
    }
}
