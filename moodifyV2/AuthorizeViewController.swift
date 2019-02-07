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
}
