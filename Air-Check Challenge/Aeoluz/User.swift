//
//  User.swift
//  Aeoluz
//
//  Created by Kaira Villanueva on 8/18/16.
//  Copyright © 2016 Kaira Villanueva. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let uid: String
    let email:String
    
    init(userData:FIRUser) {
        uid = userData.uid
        
        if let mail = userData.providerData.first?.email {
            email = mail
        } else {
            email = ""
        }
    }
    
    init(uid:String, email:String) {
        self.uid = uid
        self.email = email
    }
}
