//
//  CoreML.swift
//  ARTest
//
//  Created by Wilhelm Michaelsen on 2017-07-18.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import Foundation
import CoreML
import UIKit
import Vision

class CoreML: NSObject{
    
    class var sharedInstance: CoreML {
        
        struct Singleton {
            static let instance = CoreML()
        }
        
        return Singleton.instance
    }
    
    var image: UIImage?
    
    override init() {
        super.init()
    }
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
    }
    
    func detectPic(completion: @escaping (String) -> Void) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Failed to load model")
        }
        
        let request = VNCoreMLRequest(model: model) {
            request, error in
            
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                fatalError("Unexpected results")
            }
            
            completion(topResult.identifier)
        }
        
        guard let ciimage = CIImage(image: image!) else {
            fatalError("Failed to create CIImage from UIImage")
        }
        
        let handler = VNImageRequestHandler(ciImage: ciimage)
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
}
