//
//  DisplayEntryViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/5/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class DisplayEntryViewController: UIViewController{
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var entryTextView: UITextView!
    public var entry_to_display = Entry.init()
    
    let gradient = CAGradientLayer()

    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTextView.text = entry_to_display.entryText
        print("printing")
        print(entry_to_display.entryText)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        entryTextView.text = entry_to_display.entryText
        
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.magenta.cgColor, UIColor.blue.cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(entryTextView)
        gradientView.addSubview(doneButton)
    }
}
