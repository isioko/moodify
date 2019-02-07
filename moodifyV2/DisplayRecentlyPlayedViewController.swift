//
//  DisplayRecentlyPlayedViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/5/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class DisplayRecentlyPlayedViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate{
    let gradient = CAGradientLayer()
    public var songsForEntry = [Track]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todays_tracks.count
    }
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var aBackButton: UIButton!
    
    @IBAction func reloadData(_ sender: UIButton) {
        trackTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackTableViewCell", for: indexPath) as! TrackTableViewCell
        let track = todays_tracks[indexPath.row]
        cell.displayTrack(track: track)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackTableViewCell", for: indexPath) as! TrackTableViewCell
        let track = todays_tracks[indexPath.row]
        songsForEntry.append(track)
        let bgColorView = UIView()
        bgColorView.backgroundColor = pinkColorUI
        cell.selectedBackgroundView = bgColorView
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
    }
    

    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackTableViewCell", for: indexPath) as! TrackTableViewCell
        let track = todays_tracks[indexPath.row]
        songsForEntry.append(track)
        cell.reload()
    }
    
    private func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackTableViewCell", for: indexPath) as! TrackTableViewCell
        cell.contentView.backgroundColor = UIColor.clear
    }
    
    let pinkColorUI = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 1)
    let pinkColor = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 102/225, green: 140/225, blue: 225/225, alpha: 1).cgColor

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        gradient.frame = gradientView.bounds
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(trackTableView)
        trackTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToWriteEntrySegue" {
            if let wevc = segue.destination as? WriteEntryViewController{
                wevc.todays_tracks = self.todays_tracks
            }
        }
    }
}
