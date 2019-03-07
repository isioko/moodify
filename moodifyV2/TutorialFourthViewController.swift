//
//  TutorialFourthViewController.swift
//  moodifyV2
//
//  Created by Dylan Harding on 3/6/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import UIKit

class TutorialFourthViewController: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    let gradient = CAGradientLayer()
    
    override func viewDidAppear(_ animated: Bool) {
        gradient.frame = gradientView.bounds
        gradient.colors = Constants.themeColors()
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
}
