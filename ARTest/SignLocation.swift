//
//  SignLocation.swift
//  ARTest
//
//  Created by Wilhelm Michaelsen on 7/5/17.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import MapKit

@objc class SignLocation: NSObject {
    var text: String?
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, text: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.text = text
    }
    
    static func getPlaces() -> [SignLocation] {
        guard let path = Bundle.main.path(forResource: "SignLocations", ofType: "plist"), let array = NSArray(contentsOfFile: path) else { return [] }
        
        var places = [SignLocation]()
        
        for item in array {
            let dictionary = item as? [String : Any]
            let title = dictionary?["title"] as? String
            let subtitle = dictionary?["description"] as? String
            let latitude = dictionary?["latitude"] as? Double ?? 0, longitude = dictionary?["longitude"] as? Double ?? 0
            let text = dictionary?["text"] as? String
            
            let place = SignLocation(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(latitude, longitude), text: text)
            places.append(place)
        }
        
        return places as [SignLocation]
    }
}

extension SignLocation: MKAnnotation { }

