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

class NotificationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entries.count
    }
    
    @IBOutlet weak var Emotiface: UIImageView!
    var entries = [Entry]()
    var core_data_entries: [NSObject] = []
    var filteredEntriesByDate = [NSObject]()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
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
        //Get average sentiment of associated entries
        if entries.count != 0 { //always true, when called
            total = total/entries.count
        }
        displaySentiment(score: total)
    }
    
    func displaySentiment(score:Int){
        // pull appropriate index from that array
        //center score at 3
        emotiFace.layer.cornerRadius = 8.0
        emotiFace.clipsToBounds = true
        // create array of all faces
        var images : [UIImage] = []
        let strings : [String] = ["😩","😔","😕","😑","😏","😊","😃"]
        // <= -5, -5 < -3, -3 < -1, 0
        
        for s in strings {
            images.append(s.emojiToImage()!)
        }
        var ind = (score + 5)/2
        if ind < 0 {ind = 0}
        if ind > strings.count-1 {ind = strings.count-1}
        // print statement for debugging until Dylan done with storyboard
        print(strings[ind])
        emotiFace.image = images[ind]
    }
    
    
    func getYesterdaysEntries() {
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy/MM/dd"
        
        let today = Date()
        let yesterday = today.addingTimeInterval(TimeInterval(-60*60*24))
        let yesterdayString = date_formatter.string(from: yesterday)
        
        filteredEntriesByDate = core_data_entries.filter({( entry_obj : NSObject) -> Bool in
            let entry = getEntryFromNSObject(NS_entry: entry_obj)
            let entryDateString = date_formatter.string(from: entry.entryDate)
            return entryDateString == yesterdayString
        })
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
}
