//
//  ViewController.swift
//  RealtimeGeolation
//
//  Created by Sinclair on 8/7/16.
//  Copyright © 2016 Sinclair Toffa. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference()
        ref.removeAllObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

