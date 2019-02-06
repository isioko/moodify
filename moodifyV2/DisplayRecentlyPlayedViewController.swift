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
        spotifyManager.getRecentPlayed { (tracks) in
            for track in tracks{
                let track_name = track.0
                let artist_name = track.1
                let image_url = track.2
                let new_track = Track()
                new_track.trackName = track_name
                new_track.artistName = artist_name
                let url = URL(string: image_url)
                do{
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
                    new_track.trackArtworkImage = image
                }catch{
                    print("error")
                }
                self.todays_tracks.append(new_track)
            }
        }
        trackTableView.dataSource = self
        trackTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        trackTableView!.reloadData()
        perform(#selector(reloadTheData), with: nil, afterDelay: 0.1)
    }
    
    @objc func reloadTheData(){
        trackTableView.reloadData()
    }
    
}
