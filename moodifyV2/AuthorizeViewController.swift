//
//  AuthorizeViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/6/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AuthorizeViewController: UIViewController{
    
    let gradient = CAGradientLayer()
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var authorizeApp: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var deauthButton: UIButton!
    
    override func viewDidLoad() {
        print("view did load")
        if !spotifyManager.isAuthorized() {
            continueButton.isHidden = true
        } else {
            continueButton.isHidden = false
        }
        
        deauthButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Add gradient to background
        gradient.frame = gradientView.bounds
        gradient.colors = Constants.themeColors()
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    /* Triggers segue depending on whether "first" app launch or not.
     * "First launch" detected by whether or not any entries exist in CoreData*/
    @IBAction func clickContinue(_ sender: UIButton) {
        print("Triggered click")
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "EntryEntity")
        //3
        do {
            _ = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func deauthorizeApp(_ sender: UIButton) {
        // Deauthorize just for development to start a new Spotify session
        spotifyManager.deauthorize()
    }
    
    @IBAction func authorizeAppp(_ sender: Any) {
        // Authorize our app for the Spotify account if there is no token
        // This opens a browser window from which the user can authenticate into his account
        spotifyManager.authorize()
        continueButton.isHidden = false
    }
}
