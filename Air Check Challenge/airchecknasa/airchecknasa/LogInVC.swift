//
//  LogInVC.swift
//  airchecknasa
//
//  Created by Kaira Villanueva on 5/9/17.
//  Copyright © 2017 nasadatanaut. All rights reserved.
//

import UIKit
import CoreLocation


class LogInVC: UIViewController {
    
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        // Location services
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}
