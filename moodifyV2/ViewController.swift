//
//  ViewController.swift
//  iOSDemo
//
//  Created by Marco Albera on 24/09/2017.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var userNameLabel:      UILabel!
    @IBOutlet weak var mailLabel:          UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.4255437488, blue: 0.873636913, alpha: 1)
        customizeProfilePictureView()
        
        // Authorize our app for the Spotify account if there is no token
        // This opens a browser window from which the user can authenticate into his account
        // spotifyManager.authorize()
        
        // Deauthorize just for development to start a new Spotify session
        //spotifyManager.deauthorize()
        
        
        //loadUser()
        perform(#selector(timeToMoveOn), with: nil, afterDelay: 2)
        
    }
    
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "loadAppSegue", sender: self)
    }
    
    func customizeProfilePictureView() {
        // Add a circular layer around profile picture
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width / 2
        profilePictureView.clipsToBounds      = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Load UI
    
    func loadUser() {
        spotifyManager.myProfile { [weak self] profile in
            // Set user name
            self?.userNameLabel.text = profile.name
            
            // Set mail
            self?.mailLabel.text = profile.email ?? ""
            
            // Set image
            if let imageURL = URL(string: profile.artUri) {
                self?.profilePictureView.download(from: imageURL)
            }
        }
    }
    
    
}
