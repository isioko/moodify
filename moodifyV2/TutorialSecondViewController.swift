//
//  TutorialSecondViewController.swift
//  moodifyV2
//
//  Created by Dylan Harding on 2/23/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import UIKit

class TutorialSecondViewController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    let gradient = CAGradientLayer()
    
    override func viewDidAppear(_ animated: Bool) {
        gradient.frame = gradientView.bounds
        gradient.colors = Constants.themeColors()
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
}
