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

struct Health {
    
    let key: String!
    let date: String!
    let health: String!
    let latitude: String!
    let longitude: String!
    let addedByUser: String!
    let itemRef: FIRDatabaseReference?
    
    
    init (key: String = "",
          date: String,
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
    
    func toAnyObject() -> AnyObject {
        let dict = [ "date" : date,
                     "health" : health,
                     "latitude": latitude,
                     "longitude": longitude,
                     "addedByUser" : addedByUser]
        return dict as AnyObject
    }
}
