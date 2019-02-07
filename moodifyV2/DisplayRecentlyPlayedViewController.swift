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
    let pinkColor = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 102/225, green: 140/225, blue: 225/225, alpha: 1).cgColor
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var aBackButton: UIButton!
    
    let gradient = CAGradientLayer()
    public var songsForEntry = [Track]()
    
    public var selectedRows:[Bool] = [] 
    var selectedTracks:[Track] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todays_tracks.count
    }
    
    @IBAction func reloadData(_ sender: UIButton) {
        trackTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackTableViewCell", for: indexPath) as! TrackTableViewCell
        let track = todays_tracks[indexPath.row]
        cell.displayTrack(track: track)
        
        if selectedRows[indexPath.row] {
            // row selected
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.setNeedsLayout()
        
        return cell
    }
    
    public var todays_tracks = [Track()]
    
    @IBOutlet weak var trackTableView: UITableView!{
        didSet{
            trackTableView.dataSource = self
            trackTableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        trackTableView.dataSource = self
        trackTableView.delegate = self
        trackTableView.reloadData()
        
        // commented this out 
//        for _ in 1...todays_tracks.count {
//            selectedRows.append(false)
//        }
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
                for i in 0..<selectedTracks.count {
                    print(selectedTracks[i].trackName)
                }
                wevc.selectedRows = self.selectedRows
            }
        }
    }
}
