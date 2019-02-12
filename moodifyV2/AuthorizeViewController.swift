//
//  AuthorizeViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/6/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class AuthorizeViewController: UIViewController{
    // Colors for gradient
    let pinkColor = UIColor(red: 250/225, green: 104/225, blue: 104/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 85/225, green: 127/225, blue: 242/225, alpha: 1).cgColor
    
    let gradient = CAGradientLayer()
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var authorizeApp: UIButton!
    
    @IBAction func deauthorizeApp(_ sender: UIButton) {
        // Deauthorize just for development to start a new Spotify session
        spotifyManager.deauthorize()
        
    }
    @IBAction func authorizeAppp(_ sender: Any) {
        // Authorize our app for the Spotify account if there is no token
        // This opens a browser window from which the user can authenticate into his account
        spotifyManager.authorize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //add gradient to background
        gradient.frame = gradientView.bounds
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
}
