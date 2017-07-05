//
//  AppManager.swift
//  ARTest
//
//  Created by Wilhelm Michaelsen on 7/4/17.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import Foundation
import CoreLocation
import ARKit

protocol AppManagerDelegate {
    func addArScene(scene: SCNScene)
}

class AppManager: LocationManagerDelegate {
    
    //MARK: - Properties
    
    class var sharedInstance: AppManager {
        
        struct Singleton {
            static let instance = AppManager()
        }
        
        return Singleton.instance
    }
    
    var currentUserLocation: [Double]?
    var delegate: AppManagerDelegate?
    
    
    /* Location of signs */
    var signLocations: NSDictionary?
    
    //MARK: - Init
    init() {
        LocationManager.sharedInstance.delegate = self
        
        /* Read and store locations of poet signs */
        if let path = Bundle.main.path(forResource: "locations", ofType: "plist") {
            signLocations = NSDictionary(contentsOfFile: path)
        }
    }
    
    //MARK: - Sign Methods
    
    func enteredSignArea() {
        print("\n\nENTERED REGION\n\n")
        displayAR()
    }
    
    //MARK: - AR Methods
    
    func displayAR() {
        
        let scene = SCNScene(/*named: "art.scnassets/ship.scn"*/)
        delegate?.addArScene(scene: scene)
    }
    
    
    //MARK: - Location Methods
    
    func startUpdatingLocation() {
        LocationManager.sharedInstance.requestPermissionAndStartUpdateLocation()
    }
    
    func stopUpdatingLocation() {
        LocationManager.sharedInstance.stopUpdating()
    }
    
    //MARK: - LocationManagerDelegate
    
    func locationChanged(_ coordinate: CLLocationCoordinate2D?) {
        if coordinate != nil {
            
            /* Go through each sign location and check if user is within 5 meters */
            for location in (signLocations?.value(forKey: "locs") as? [[Double]])! {
                let loc1 = CLLocation(latitude: location[0], longitude: location[1])
                let loc2 = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
                
                if loc1.distance(from: loc2) < 30 {
                    self.enteredSignArea()
                }
            }
            
            let coordinates: [Double] = [coordinate!.latitude, coordinate!.longitude]
            
            /* Update local location variable */
            self.currentUserLocation = coordinates
            
        } else {
            print("coordinate is nil (UserManager.swift)")
        }
    }
}
