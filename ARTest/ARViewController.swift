//
//  ARViewController.swift
//  ARTest
//
//  Created by Wilhelm Michaelsen on 2017-07-17.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import UIKit
import AVFoundation

class ARViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.addSublayer(AppManager.sharedInstance.previewLayer)
        AppManager.sharedInstance.previewLayer.frame = self.view.layer.frame
        AppManager.sharedInstance.startCameraFeed()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        AppManager.sharedInstance.takePhoto()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
