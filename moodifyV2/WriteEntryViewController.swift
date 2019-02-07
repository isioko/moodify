//
//  WriteEntryViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/3/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

protocol SaveNewEntryDelegate {
    func saveNewEntry(entry: Entry)
    func updateNewEntry(entry: Entry)
}

class WriteEntryViewController:UIViewController,
UITextFieldDelegate, UITextViewDelegate{
    public var new_entry = Entry.init()
    public var updated_entries = Entries.init()
    var delegate:SaveNewEntryDelegate?
    let gradient = CAGradientLayer()
    @IBOutlet weak var gradientView: UIView!
    var alreadySavedEntry = false
    public var todays_tracks = [Track]()
    @IBOutlet weak var entryTextView: UITextView!
    // MARK - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    // Colors for gradient
    let pinkColor = UIColor(red: 255/225, green: 102/225, blue: 102/225, alpha: 1).cgColor
    let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
    let blueColor = UIColor(red: 102/225, green: 140/225, blue: 225/225, alpha: 1).cgColor
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTextView.layer.cornerRadius = 8
        entryTextView.clipsToBounds = true
        entryTextView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        gradient.frame = gradientView.bounds
        gradient.colors = [pinkColor, purpleColor, blueColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(doneButton)
        gradientView.addSubview(saveButton)
        gradientView.addSubview(entryTextView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func clickSave(_ sender: UIButton) {
        if let entry_text = entryTextView.text{
            new_entry.entryText = entry_text
        }
        if(alreadySavedEntry){
            delegate?.updateNewEntry(entry: new_entry)
        }else{
            delegate?.saveNewEntry(entry: new_entry)
            alreadySavedEntry = true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseMusicSegue" {
            if let drpvc = segue.destination as? DisplayRecentlyPlayedViewController{
                drpvc.todays_tracks = todays_tracks
            }
        }
    }
    
}
