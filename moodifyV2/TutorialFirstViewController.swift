//
//  TutorialFirstViewController.swift
//  moodifyV2
//
//  Created by Dylan Harding on 2/23/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import UIKit

class TutorialFirstViewController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    let gradient = CAGradientLayer()
    
    @IBAction func handleSwipe(recognizer:UISwipeGestureRecognizer) {
        print("yay swipe came thru")
        
//        let translation = recognizer.translation(in: self.view)
//        if let view = recognizer.view {
//            view.center = CGPoint(x:view.center.x + translation.x,
//                                  y:view.center.y + translation.y)
//        }
//        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient.frame = gradientView.bounds
        gradient.colors = Constants.themeColors()
        gradientView.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
    }

}
