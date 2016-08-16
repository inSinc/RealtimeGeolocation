//
//  DrivingViewController.swift
//  RealtimeGeolation
//
//  Created by Sinclair on 8/7/16.
//  Copyright © 2016 Sinclair Toffa. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class DrivingViewController: UIViewController,CLLocationManagerDelegate {
    var manager: CLLocationManager!
    var lat: Double!
    var long: Double!
    var speed: Double!
    var trackingNumber: Int!
    var firebaseRef:FIRDatabaseReference!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMap()
        firebaseRef = FIRDatabase.database().reference()
        firebaseRef.removeAllObservers()
        trackingNumber = Int(arc4random_uniform(10000) + 1)
        lat = 0
        long = 0
        speed = 0
        trackingNumberLabel.text = "\(trackingNumber)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeMap(){
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let userSpeed = userLocation.speed
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        self.map.setRegion(region, animated: true)
        
        lat = Double(latitude)
        long = Double(longitude)
        speed = Double(userSpeed)
        updateLabels()
        pushToFirebase()
        //print(userLocation)
    }
    
    func updateLabels(){
        latLabel.text = "Lat: \(lat)"
        longLabel.text = "Long: \(long)"
        speedLabel.text = "Speed: \(speed)"
    }
    
    func pushToFirebase(){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let hour = calendar.component(NSCalendarUnit.Hour, fromDate: date)
        let minute = calendar.component(NSCalendarUnit.Minute, fromDate: date)
        let second = calendar.component(NSCalendarUnit.Second, fromDate: date)
        let time = "\(hour):\(minute):\(second)"
        print("We pushing out here "+time)
        let key = firebaseRef.child("\(trackingNumber)").childByAutoId().key
        let update = ["time":time,"latitude":lat,"longitude":long,"speed":speed]
        let updateMyLittleChildren = ["/\(trackingNumber)/\(key)":update]
        firebaseRef.updateChildValues(updateMyLittleChildren)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
