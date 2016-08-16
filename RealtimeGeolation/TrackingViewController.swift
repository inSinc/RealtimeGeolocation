//
//  TrackingViewController.swift
//  RealtimeGeolation
//
//  Created by Sinclair on 8/7/16.
//  Copyright © 2016 Sinclair Toffa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit

class TrackingViewController: UIViewController, CLLocationManagerDelegate{
    var trackingNumber:Int!
    var firebaseRef:FIRDatabaseReference!
    var manager: CLLocationManager!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var trackingNumberTextField: UITextField!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBAction func startTrackingButton(sender: AnyObject) {
        if(trackingNumberTextField.text?.isEmpty == true){
            directionsLabel.text = "Please enter tracking number."
            directionsLabel.textColor = UIColor.redColor()
        }else{
            trackingNumber = Int(trackingNumberTextField.text!)
            attemptToRetrieve()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.latLabel.alpha = 0.0
        self.longLabel.alpha = 0.0
        self.speedLabel.alpha = 0.0
        self.timeLabel.alpha = 0.0
        self.trackingNumber = 0
        self.firebaseRef = FIRDatabase.database().reference()
        self.manager = CLLocationManager()
        self.map.alpha = 0.0
        self.manager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func attemptToRetrieve(){
        if(firebaseRef.child("\(trackingNumber)").key == ""){
            self.directionsLabel.text = "Invalid tracking number. Try again."
            self.directionsLabel.textColor = UIColor.redColor()
        }else{
            self.latLabel.alpha = 1.0
            self.longLabel.alpha = 1.0
            self.speedLabel.alpha = 1.0
            self.timeLabel.alpha = 1.0
            self.map.alpha = 1.0
            self.firebaseRef.child("\(trackingNumber)").observeEventType(.ChildAdded, withBlock: { (snapshot) in
                let trackingDetails = snapshot.value as! [String : AnyObject]
                self.latLabel.text = "Latitude: " + String(trackingDetails["latitude"]!)
                self.longLabel.text = "Longitude: " + String(trackingDetails["longitude"]!)
                self.speedLabel.text = "Speed: " + String(trackingDetails["speed"]!)
                self.timeLabel.text = "Time: " + String(trackingDetails["time"]!)
                self.updateMap(Double(trackingDetails["latitude"]! as! NSNumber),longitude: Double(trackingDetails["longitude"]! as! NSNumber))
            })
        }
    }
    
    func updateMap(latitude:Double,longitude:Double){
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        self.map.setRegion(region, animated: true)
    }
    
    //closes keyboard when user touches elsewhere outside the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //closes keyboard when user hits return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
