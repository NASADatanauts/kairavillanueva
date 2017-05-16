//
//  Health.swift
//  airchecknasa
//
//  Created by Kaira Villanueva on 5/9/17.
//  Copyright © 2017 nasadatanaut. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct AirStatus {
    
    let key: String!
    let date: Date!
    let health: String!
    let latitude: String!
    let longitude: String!
    let addedByUser: String!
    let itemRef: FIRDatabaseReference?
    
    
    init (key: String = "",
          date: Date,
          health: String,
          latitude: String,
          longitude: String,
          addedByUser: String ) {
        
        self.key = key
        self.date = date
        self.health = health
        self.latitude = latitude
        self.longitude = longitude
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    func convertDateToString(dt: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        let dateString:String = formatter.string(from: dt)
        return dateString
    }
    
}
