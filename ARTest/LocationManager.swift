//
//  LocationManager.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-06-22.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//

import CoreLocation


protocol LocationManagerDelegate {
    func locationChanged(_ coordinate: CLLocationCoordinate2D?)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    var currentLocatin: CLLocation
    var delegate: LocationManagerDelegate?
    
    // Flag
    var firstLoad: Bool
    
    override init() {
        self.currentLocatin = CLLocation()
        firstLoad = true
        super.init()
    }
    
    class var sharedInstance: LocationManager {
        
        struct Singleton {
            static let instance = LocationManager()
        }
        
        return Singleton.instance
    }
    
    
    // Method for checking permission and requesting
    func requestPermissionAndStartUpdateLocation() {
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        // Get permission if not set, else start update location
        if (CLLocationManager.authorizationStatus() == .restricted) || (CLLocationManager.authorizationStatus() == .denied) || (CLLocationManager.authorizationStatus() == .notDetermined) {
            manager.requestWhenInUseAuthorization()
        } else {
            manager.startUpdatingLocation()
        }
    }
    
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
    
    //MARK: Delegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // If auth status becomes approved
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastIndex = locations.endIndex - 1
        let newLoc: CLLocation = locations[lastIndex]
        
        let loc1 = CLLocation(latitude: self.currentLocatin.coordinate.latitude, longitude: self.currentLocatin.coordinate.longitude)
        let loc2 = CLLocation(latitude: newLoc.coordinate.latitude, longitude: newLoc.coordinate.longitude)
        
        let distance: Double = loc1.distance(from: loc2)
        self.currentLocatin = newLoc
        
        //if !firstLoad {
        if distance > 10 {
            delegate?.locationChanged(self.currentLocatin.coordinate)
        }
        //    self.firstLoad = false
        //}
    }
    
    
}
