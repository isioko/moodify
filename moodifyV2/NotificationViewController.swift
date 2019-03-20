//
//  NotificationViewController.swift
//  moodifyV2
//
//  Created by Isi Okojie on 3/2/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NotificationViewController: UIViewController, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entries.count
    }
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var numEntriesLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    var entries = [Entry]()
    var core_data_entries: [NSObject] = []
    var filteredEntriesByDate = [NSObject]()
    
    override func viewDidAppear(_ animated: Bool) {
        popupView.layer.cornerRadius = 8.0
        popupView.clipsToBounds = true
        
        // CORE DATA
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "EntryEntity")
        let sort = NSSortDescriptor(key: #keyPath(EntryEntity.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        //3
        do {
            core_data_entries = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        getYesterdaysEntries()
        
        for object in filteredEntriesByDate {
            entries.append(getEntryFromNSObject(NS_entry: object))
        }
        analyzeSentiment(entries: entries)
        notificationCollectionView.reloadData()
    }
    
    func analyzeSentiment(entries : [Entry]){
        let sentiment = Sentimently()
        var total = 0
        for entry in entries{
            print(entry.entryText)
            total += sentiment.score(entry.entryText).score
            print(sentiment.score(entry.entryText)) //TEST
        }
        // Get average sentiment of associated entries
        if entries.count != 0 { //always true, when called
            total = total/entries.count
        }
        displaySentiment(score: total)
    }
    
    func displaySentiment(score:Int){
        // create array of all faces
        var images : [UIImage] = []
        let strings : [String] = ["😩","☹️","😕","😐","🙂","😀","😁"]
        // <= -5, -5 < -3, -3 < -1, 0
        
        for s in strings {
            images.append(s.emojiToImage()!)
        }
        var ind = (score + 5)/2
        if ind < 0 {ind = 0}
        if ind > strings.count-1 {ind = strings.count-1}
        if score == 0 {ind = 3} //don't round down on 0 entries
        emojiLabel.text = strings[ind]
    }
    
    
    func getYesterdaysEntries() {
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy/MM/dd"
        
        let today = Date()
        let yesterday = today.addingTimeInterval(TimeInterval(-60*60*24))
        let yesterdayString = date_formatter.string(from: yesterday)
        
        // only for testing purposes
//        let todayString = date_formatter.string(from: today)
        
        filteredEntriesByDate = core_data_entries.filter({( entry_obj : NSObject) -> Bool in
            let entry = getEntryFromNSObject(NS_entry: entry_obj)
            let entryDateString = date_formatter.string(from: entry.entryDate)
            
            // Switch for testing to view today's entries
            return entryDateString == yesterdayString
//            return entryDateString == todayString
        })
        
        numEntriesLabel.text = String(filteredEntriesByDate.count)
    }
    
    func getEntryFromNSObject(NS_entry:NSObject) -> Entry {
        let entry = Entry()
        entry.entryDate = NS_entry.value(forKey: "date") as! Date
        entry.location = NS_entry.value(forKey: "location") as! String
        entry.entryText = NS_entry.value(forKey: "text") as! String
        return entry
    }
    
    @IBOutlet weak var notificationCollectionView: UICollectionView! {
        didSet {
            notificationCollectionView.dataSource = self
            notificationCollectionView.delegate = self
        }
    }
    
    func updateCoreDataDoneLookingAtMemory() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MemoryEntity")
        do {
            let count = try managedContext.count(for: request)
            var foundMemory = try managedContext.fetch(request)
            
            if(count == 0){
                // no matching object
                let memoryObj = MemoryEntity(context: managedContext)
                memoryObj.setValue(false, forKeyPath:"showBool")
                
            }else{
                let memoryObj = foundMemory[0] as! MemoryEntity
                memoryObj.setValue(false, forKeyPath:"showBool")
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch: UITouch? = touches.first
//        let touch_point = touch!.location(in: popupView)
//        // check if user touched outside of Popup, if so exit out popup functionality
//        if self.view.bounds.contains(touch_point){
//            print("TOUCH IS IN BOUNDS OF POPUP")
//        }else{
//            print("TOUCH IS NOT IN BOUNDS OF POPUP")
//            performSegue(withIdentifier: "backToEntryTabFromPopUp", sender: self)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEntryFromMemorySegue" {
            if let devc = segue.destination as? DisplayEntryViewController {
                
                let entry_cell = sender as! UICollectionViewCell
                let indexPath = self.notificationCollectionView!.indexPath(for: entry_cell)
                let entry_clicked_obj: NSObject
                entry_clicked_obj = filteredEntriesByDate[indexPath!.row]
                
                let entry_clicked = getEntryFromNSObject(NS_entry: entry_clicked_obj)
                devc.entry_to_display = entry_clicked
                // leave memory notification view controller up in entry tab in future
            }
        } else if segue.identifier == "backToEntryTabFromPopUp" {
            let date_formatter = DateFormatter()
            date_formatter.dateFormat = "yyyy/MM/dd"
            let dateString = date_formatter.string(from: Date())
            UserDefaults.standard.set(dateString, forKey: "lastClosedNotification")
        }
    }
}

extension NotificationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell_width = collectionView.bounds.width
        let cell_height: CGFloat = 105
        return CGSize(width: cell_width, height: cell_height)
    }
}

extension NotificationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notifCell", for: indexPath) as! NotificationEntryViewCell
        // Format cells to be white and have rounded edges
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.layer.masksToBounds = true
        
        let entry_obj = entries[indexPath.row]
        cell.displayContent(entry: entry_obj)
        return cell
    }
}
