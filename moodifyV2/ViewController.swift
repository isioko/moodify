//
//  ViewController.swift
//  iOSDemo
//
//  Created by Marco Albera on 24/09/2017.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    let gradient = CAGradientLayer()
    
    @IBOutlet weak var moodifyLogo: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        //self.view.backgroundColor = blueColor
        gradient.frame = gradientView.bounds
        gradient.colors = Constants.themeColors()
        gradientView.layer.insertSublayer(gradient, at: 0)
        moodifyLogo.image = UIImage(named: "moodify-start-logo-01.png")
        perform(#selector(timeToMoveOn), with: nil, afterDelay: 1.5)
    }
    
    @objc func timeToMoveOn() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            self.performSegue(withIdentifier: "straightToEntryTab", sender: self)
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            self.performSegue(withIdentifier: "loadAppSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
