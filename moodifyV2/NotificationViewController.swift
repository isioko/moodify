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

class NotificationViewController: UIViewController /*,UICollectionViewDelegate, UICollectionViewDataSource*/ {
//    
//    public var entries = [Entry]()
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return entries.count
//    }
//
//    var core_data_objs: [NSObject] = []
//    public var entry_to_display = Entry.init()
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notifCell", for: indexPath) as! NotificationEntryViewCell
//
//        // Format cells to be white and have rounded edges
//        cell.contentView.backgroundColor = UIColor.white
//        cell.contentView.layer.cornerRadius = 8.0
//        cell.contentView.layer.masksToBounds = true
//
//        let entry_obj = entries[indexPath.row]
//        cell.displayContent(entry: entry_obj)
//        return cell
//    }
    
    override func viewDidAppear(_ animated: Bool) {
//        // CORE DATA
//
//        //1
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return
//        }
//
//        let managedContext =
//            appDelegate.persistentContainer.viewContext
//
//        //2
//        let fetchRequest =
//            NSFetchRequest<NSManagedObject>(entityName: "EntryEntity")
//        fetchRequest.fetchLimit = 5
//
//        let date_formatter = DateFormatter()
//        date_formatter.dateFormat = "yyyy/MM/dd"
////        fetchRequest.predicate = NSPredicate(format: "date < %@", NSDate as! CVarArg)
////        fetchRequest.predicate = NSPredicate(format: "dateString == %@", "2019/03/01")
//
//        //3
//        do {
//            core_data_objs = try managedContext.fetch(fetchRequest)
//            if core_data_objs.count >= 1{
//                print("SUCCESS")
//            }
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//        // end of core data
//
//

    }
    
//    func getEntryFromNSObject(NS_entry:NSObject) -> Entry {
//        let entry = Entry()
//        entry.entryDate = NS_entry.value(forKey: "date") as! Date
//        entry.location = NS_entry.value(forKey: "location") as! String
//        entry.entryText = NS_entry.value(forKey: "text") as! String
//        return entry
//    }
//    
//    @IBOutlet weak var notificationCollectionView: UICollectionView! {
//        didSet {
//            notificationCollectionView.dataSource = self
//            notificationCollectionView.delegate = self
//        }
//    }
    
    override func viewDidLoad() {

    }
    
}
