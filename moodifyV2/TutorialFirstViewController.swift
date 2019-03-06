//
//  TutorialFirstViewController.swift
//  moodifyV2
//
//  Created by Dylan Harding on 2/23/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import UIKit

class TutorialFirstViewController: UIViewController {

    let gradient = CAGradientLayer()
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        gradient.frame = gradientView.bounds
        gradient.colors = Constants.themeColors()
        gradientView.layer.insertSublayer(gradient, at: 0)
    }

}
