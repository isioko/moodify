//
//  ViewController.swift
//  moodifyV2
//
//  Created by Isi Okojie on 1/31/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let SpotifyClientID = "a9e85dbb91464cf08f68d59908cc496c"
    fileprivate let SpotifyRedirectURI = URL(string: "moodify://spotify-login-callback")!

    @IBAction func AuthenticateButton(_ sender: Any) {
        getAuth()
    }
    
    func getAuth() {
        //let url = URL(string:"https://accounts.spotify.com/authorize")
        
        let url = URL(string: "https://accounts.spotify.com/login?continue=https%3A%2F%2Faccounts.spotify.com%2Fauthorize")
        
        var request = URLRequest(url: url!)
        
        request.addValue(SpotifyClientID, forHTTPHeaderField: "client_id")
        //request.addValue("code", forHTTPHeaderField: "response_type")
        //request.addValue("moodify://spotify-login-callback", forHTTPHeaderField: "redirect_uri")

        //var responseURL = URL(string:"")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            print(response)
        }
        task.resume()
        
        
        //return(responseURL!)
        //print(responseURL)
        /*
        let task2 = URLSession.shared.dataTask(with: responseURL!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            print(response?.url)
            //print("about to do Json")
            //let json = try! JSONSerialization.jsonObject(with: data, options: [])
            //print(json)
        }
        task2.resume()
         */
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

