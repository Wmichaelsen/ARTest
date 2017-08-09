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
import AVFoundation

protocol AppManagerDelegate {
    func addArScene(scene: SCNScene, withText text: String)
}

class AppManager: LocationManagerDelegate, AVSessionDelegate {
    
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
    var signLocations: [SignLocation]
    
    var previewLayer: CALayer {
        get {
            return AVSession.sharedInstance.previewLayer
        }
        set {
            
        }
    }
    
    var currentFrame: CGImage?
    
    //MARK: - Init
    init() {
        /* Read and store locations of poetry signs */
        signLocations = SignLocation.getPlaces()
        
        LocationManager.sharedInstance.delegate = self
        AVSession.sharedInstance.delegate = self
    }
    
    //MARK: - Sign Methods
    
    func enteredSign(withText text: String) {
        print("\n\nENTERED REGION\n\n")
        displayAR(withText: text)
    }
    
    //MARK: - AR Methods
    
    func displayAR(withText text: String) {
        
        let scene = SCNScene(/*named: "art.scnassets/ship.scn"*/)
        delegate?.addArScene(scene: scene, withText: text)
    }
    
    
    //MARK: - Location Methods
    
    func startUpdatingLocation() {
        LocationManager.sharedInstance.requestPermissionAndStartUpdateLocation()
    }
    
    func stopUpdatingLocation() {
        LocationManager.sharedInstance.stopUpdating()
    }
    
    //MARK: - AVSession Methods
    func startCameraFeed() {
        AVSession.sharedInstance.start()
    }
    
    func takePhoto() {
        AVSession.sharedInstance.takePicture()
    }
    
    //MARK: - CoreML Methods
    func analyzeImage(image: UIImage, completion: @escaping (_ string: String?) -> Void) {
        let ml = CoreML(image: image)
        ml.detectPic(completion: { string in
            completion(string)
        })
    }
    
    //MARK: - AVSessionDelegate
    func photoTaken(photo: CGImage?) {
        currentFrame = photo
    }
    
    //MARK: - LocationManagerDelegate
    
    func locationChanged(_ coordinate: CLLocationCoordinate2D?) {
        if coordinate != nil {
            
            /* Go through each sign location and check if user is within 5 meters */
            for signLocation in signLocations {
                let loc1 = CLLocation(latitude: signLocation.coordinate.latitude, longitude: signLocation.coordinate.longitude)
                let loc2 = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
                
                if loc1.distance(from: loc2) < 30 {
                    if signLocation.text != nil {
                        self.enteredSign(withText: signLocation.text!)
                    } else {
                        self.enteredSign(withText: "")
                    }
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
