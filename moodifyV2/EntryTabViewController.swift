//
//  EntryTabViewController.swift
//  moodifyV2
//
//  Created by Shelby Marcus on 2/3/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class EntryTabViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, SaveNewEntryDelegate{
    var entries = Entries.init()
    var writeEntry: WriteEntryViewController?
    @IBOutlet weak var gradientView: UIView!
    
    let gradient = CAGradientLayer()
    
    @IBOutlet weak var plusButton: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //add gradient to background
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.magenta.cgColor, UIColor.blue.cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.addSubview(plusButton)
        entryCollectionView.reloadData()
        entryCollectionView.collectionViewLayout.invalidateLayout()

    }
    
    @IBAction func backFromModal(_ segue: UIStoryboardSegue){
        self.tabBarController?.selectedIndex = 0
    }

    @IBOutlet weak var entryCollectionView: UICollectionView!{
        didSet{
            entryCollectionView.dataSource = self
            entryCollectionView.delegate = self
        }
    }
 
    func saveNewEntry(entry: Entry) {
        entries.entries_list.insert(entry, at:0)
    }
    
    func updateNewEntry(entry: Entry) {
        if(entries.entries_list.count > 0){
            entries.entries_list[0] = entry
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entry_i = indexPath.row
        let entry_to_send = entries.entries_list[entry_i]
//        performSegue(withIdentifier: "viewEntrySegue", sender: self)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return entries.entries_list.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as! EntryViewCell
        let entry = entries.entries_list[indexPath.row]
        cell.displayContent(entry: entry)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "writeEntrySegue" {
            if let wevc = segue.destination as? WriteEntryViewController{
                wevc.updated_entries = entries
                wevc.delegate = self
            }
        }else if segue.identifier == "viewEntrySegue"{
            if let devc = segue.destination as? DisplayEntryViewController {

                let entry_cell = sender as! UICollectionViewCell
                let indexPath = self.entryCollectionView!.indexPath(for: entry_cell)
                let entry_clicked = self.entries.entries_list[indexPath!.row]
                devc.entry_to_display = entry_clicked
            }
            
            
            
        }
    }
}
