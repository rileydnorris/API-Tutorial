//
//  ViewController.swift
//  API-Tutorial-Video
//
//  Created by Riley Norris on 12/30/18.
//  Copyright © 2018 Riley Norris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bodies: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postCall()
    }
    
    /// Defines how many rows we want in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodies.count
    }
    
    /// Defines our cells in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = bodies[indexPath.row]
        return cell
    }
    
    /// Code for a GET call
    func getCall() {
        
        // set the url
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        // request to define all the options for our API call
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // adding a placeholder authorization header
        request.addValue("auth_token", forHTTPHeaderField: "auth_header")
        
        // setting timeout of API call to be 10 seconds
        request.timeoutInterval = 10
        
        // start the session to start the call and receive our response
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            // print out response to let us know more information about the call
            if let response = response {
                print(response)
            }
            
            // receive the data
            do {
                // turning the data into a json object
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    
                    // looping through each object in the json object
                    json?.forEach({ element in
                        
                        // if a key "body" exists, add it to the array
                        if let body = element["body"] as? String {
                            self.bodies.append(body)
                        }
                    })
                    
                    // reload tableview on main thread to avoid corruption
                    DispatchQueue.main.sync {
                        self.tableView.reloadData()
                    }
                }
            }
            
            }.resume()
    }
    
    /// Code for a POST call
    func postCall() {
        
        // defining our json body that we'll give to the request
        let jsonBody: [String : Any] = [
            "title" : "test",
            "body" : "Hello there",
            "userId" : 1
        ]
        
        // set the url
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/")!
        
        // request to define all the options for our API call
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // specify that we are passing a JSON object to the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // convert the jsonBody dictionary to an actual JSON object and attaching to request
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else { return }
        request.httpBody = httpBody
        
        // start the session to start the call and receive our response
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            do {
                // turning the data into a json object
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                    
                    // if a key "id" exists, add to array
                    if let id = json["id"] as? Int {
                        self.bodies.append("\(id)")
                    }
                    
                    // reload tableview on main thread to avoid corruption
                    DispatchQueue.main.sync {
                        self.tableView.reloadData()
                    }
                }
            }
            
            }.resume()
    }
}

