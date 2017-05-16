//
//  SummaryReportVC.swift
//  airchecknasa
//
//  Created by Kaira Villanueva on 5/7/17.
//  Copyright © 2017 nasadatanaut. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class SummaryReportVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Firebase
    var dbRef:FIRDatabaseReference!
    var posts = [AirStatus]()
    
    // Retrieves objects from Firebase
    func startObservingDB(callback: @escaping ((_ data:[AirStatus]) -> Void )) {
        
        dbRef.queryOrdered(byChild: "date").observe(FIRDataEventType.value, with: { (snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject] {
                for child in snapDict{
                    if let name = child.value as? [String:AnyObject]{
                        
                        // Converts string date to actual date
                        let strTime = name["date"] as! String
                        let formatter = DateFormatter()
                        formatter.timeStyle = .none
                        formatter.dateStyle = .long
                        let date:Date = formatter.date(from: strTime)!
                        
                        // Creates an AirStatus object and is stored in an array
                        let post = AirStatus.init(date: date,
                                               health: name["health"] as! String,
                                               latitude: name["latitude"] as! String,
                                               longitude: name["longitude"] as! String,
                                               addedByUser: name["addedByUser"] as! String)
                        self.posts.append(post)
                    }
                }
                
                // Sorts the objects by date
                let objects: [AirStatus] = self.posts.sorted{ $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970 }
                self.posts = objects
                
                // Retrieves only the first 7 objects
                if (self.posts.count > 7) {
                    let first7 = self.posts.prefix(7)
                    let first7Arr: [AirStatus] = Array(first7)
                    self.posts = first7Arr
                }
                
                // Reloads table and aysync callback
                self.tableView.reloadData()
                callback(self.posts)
            }
        })
    }
    
    
    // Intial setup
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference().child("health-items")
        startObservingDB(callback: { (data:[AirStatus]) -> Void in
            // print(data)
        })
    }
    
    
    // Returns number of sections in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    // Returns number of rows (items) in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count;
    }
    
    // Configures the content and returns the cell
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier: String = "AirCheckCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CustomCell
        
        // Retrieves items in array
        let cellContent: AirStatus = self.posts[indexPath.row]
        
        cell.date.text = cellContent.convertDateToString(dt: cellContent.date)
        cell.lat.text = cellContent.latitude
        cell.lon.text = cellContent.longitude
        cell.rate.text = cellContent.health
        
        return cell
    }
    
    
}
