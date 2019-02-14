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
    
    // Colors for gradient
    let pinkColor = UIColor(red: 250/225, green: 104/225, blue: 104/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 85/225, green: 127/225, blue: 242/225, alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = blueColor
        gradient.frame = gradientView.bounds
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        moodifyLogo.image = UIImage(named: "moodify-start-logo-01.png")
        perform(#selector(timeToMoveOn), with: nil, afterDelay: 2)
    }
    
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "loadAppSegue", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
