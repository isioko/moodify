//
//  DisplayEntryViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/5/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class DisplayEntryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entry_to_display.associatedTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayTrackTableViewCell", for: indexPath) as! DisplayTrackTableViewCell
        let track = entry_to_display.associatedTracks[indexPath.row]
        cell.displayTrack(track: track)
        
        return cell

    }
    // Colors for gradient
    let pinkColor = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 102/225, green: 140/225, blue: 225/225, alpha: 1).cgColor

    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var entryTextView: UITextView!
    public var entry_to_display = Entry.init()
    public var selectedTracks = [Track]()
    
    let gradient = CAGradientLayer()
    
    @IBOutlet weak var displayEntryTracksTableView: UITableView!{
        didSet {
            displayEntryTracksTableView.dataSource = self
            displayEntryTracksTableView.delegate = self
        }
    }
    
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        displayEntryTracksTableView.dataSource = self
        displayEntryTracksTableView.delegate = self
        displayEntryTracksTableView.reloadData()
        entryTextView.text = entry_to_display.entryText
        print("printing")
        print(entry_to_display.entryText)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        entryTextView.text = entry_to_display.entryText
        
        gradient.frame = gradientView.bounds
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(entryTextView)
        gradientView.addSubview(doneButton)
    }
}
