//
//  User.swift
//  airchecknasa
//
//  Created by Kaira Villanueva on 5/9/17.
//  Copyright © 2017 nasadatanaut. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

struct User {
    let uid: String
    let email: String
    
    init(userData: FIRUser) {
        uid = userData.uid
        
        if let mail = userData.providerData.first?.email {
            email = mail
        } else {
            email = ""
        }
    }
    
    init (uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
