//
//  CalendarViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/5/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController{
    
    @IBOutlet weak var gradientView: UIView!
    let gradient = CAGradientLayer()
    
    @IBOutlet weak var recentlyPlayedButton: UIButton!
    @IBOutlet weak var authorizeButton: UIButton!
    
    // Colors for gradient
    let pinkColor = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 102/225, green: 140/225, blue: 225/225, alpha: 1).cgColor
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        gradient.frame = gradientView.bounds
        //gradient.colors = [UIColor.magenta.cgColor, UIColor.blue.cgColor]
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(authorizeButton)
        gradientView.addSubview(recentlyPlayedButton)
    }
    
    @IBAction func ClickAuthorizeButton(_ sender: UIButton) {
        spotifyManager.authorize()
    }
    
    @IBAction func ClickRecentlyPlayedTracks(_ sender: UIButton) {
        spotifyManager.getRecentPlayed { (tracks) in
            print(tracks.count)
        }
    }
}
