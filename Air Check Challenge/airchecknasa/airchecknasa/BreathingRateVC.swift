//
//  BreathingRateVC.swift
//  airchecknasa
//
//  Created by Kaira Villanueva on 5/7/17.
//  Copyright © 2017 nasadatanaut. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class BreathingRateVC: UIViewController {
    
    @IBOutlet weak var numberButton: UIButton!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var nextViewButton: UIButton!
    
    var latitude:String = ""
    var longitude:String = ""
    var dbRef:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable button
        nextViewButton.isEnabled = false
        
        // Firebase reference for items
        dbRef = FIRDatabase.database().reference().child("health-items")
        
        // Location
        let locationManager = CLLocationManager()
        var currentLocation = CLLocation()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locationManager.location!
            self.latitude =  String(format: "%.01f", currentLocation.coordinate.latitude)
            self.longitude = String(format: "%.01f",currentLocation.coordinate.longitude)
        }
    }
    
    

    // Increases the # in the button for breathing rate
    @IBAction func upButton(_ sender: UIButton) {
        var num = Int(buttonLabel.text!)
        if (num! < 10) {
            num = num! + 1
            let numText = String(num!)
            buttonLabel.text = numText
        } else {
            print("Reached maximum rating")
        }
    }
    
    // Decreases the # in the button for breathing rate
    @IBAction func downButton(_ sender: UIButton) {
        var num = Int(buttonLabel.text!)
        if (num! > 0) {
            num = num! - 1
            let numText = String(num!)
            buttonLabel.text = numText
        } else {
            print("Reached minimum rating")
        }
    }
    
    // Adds health post to Firebase
    @IBAction func addBreathingRate(_ sender: UIButton){
        // Get the current date and time
        let currentDateTime = Date()
        
        // Initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        let dateToday:String = formatter.string(from: currentDateTime)
        
        // Create to pass to Firebase
        let userSubmit = Health(date: dateToday,
                                health: buttonLabel.text!,
                                latitude: self.latitude,
                                longitude: self.longitude,
                                addedByUser: "Kaira")
        
        // Pass to Firebase
        let healthRef = self.dbRef.child(userSubmit.date.uppercased())
        healthRef.setValue(userSubmit.toAnyObject())
        
        // Enables the next button
        nextViewButton.isEnabled = true
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    
}
