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
    
    @IBOutlet weak var entryTextView: UITextView!
    // MARK - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.magenta.cgColor, UIColor.blue.cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(doneButton)
        gradientView.addSubview(saveButton)
        gradientView.addSubview(entryTextView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        newEntryTextField.delegate = self
        entryTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    

    
//    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {  //delegate method
//        return false
//    }
//
//    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
//        textField.resignFirstResponder()
//        return true
//    }

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

}
