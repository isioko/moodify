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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.magenta.cgColor, UIColor.blue.cgColor]
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
