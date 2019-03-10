//
//  AppDelegate.swift
//  iOSDemo
//
//  Created by Marco Albera on 24/09/2017.
//

import UIKit

// Import SpotifyKit iOS library
import SpotifyKit
import CoreData

// MARK: SpotifyKit initialization

// The Spotify developer application object
// Fill this with the data from the app you've set up on Spotify developer page
fileprivate let application = SpotifyManager.SpotifyDeveloperApplication(
    clientId:     "a9e85dbb91464cf08f68d59908cc496c",
    clientSecret: "a77cbf757c9a435a9e7fec4aaabcfa97",
    redirectUri:  "moodifyV2://spotify-login-callback"
)

// The SpotifyKit helper object that will allow you to perform the queries
let spotifyManager = SpotifyManager(with: application)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // MARK: URL event handling
    
    /**
     After sending 'swiftify.authorize()' command,
     our application receives an URL starting with the "redirect uri" we've set up
     in Spotify Developer page and added to our app's Info.plist under "URL types" -> "URL schemes".
     This URI contains the token access code which grants the privileges needed for performing Spotify queries.
     Here we catch the URI as it is passed to our app, retrieve the token code and send it
     to Swifify, which will generate the code and save it in Keychain for persistency
     */
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        print(url)
        spotifyManager.saveToken(from: url)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func resetMemoryNotificationVars() {
        let managedContext =
            self.persistentContainer.viewContext
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MemoryEntity")
        do {
            
            let count = try managedContext.count(for: request)
            var foundMemory = try managedContext.fetch(request)
            
            if(count == 0) {
                // no matching object
                let memoryObj = MemoryEntity(context: managedContext)
                memoryObj.setValue(true, forKeyPath:"showBool")
                
            } else {
                let memoryObj = foundMemory[0] as! MemoryEntity
                memoryObj.setValue(true, forKeyPath:"showBool")
                
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        // this function resets variable controlling NotificationViewController display
        // right now it resets so that pop up will display next time app is opened
        resetMemoryNotificationVars()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

