//
//  ViewController.swift
//  ARTest
//
//  Created by Wilhelm Michaelsen on 7/3/17.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, AppManagerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        let rc = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(rc)
        
        /* Start checking user location */
        AppManager.sharedInstance.startUpdatingLocation()
        AppManager.sharedInstance.delegate = self
    }
    
    @objc
    func handleTap(recog: UITapGestureRecognizer) {
        self.scanSign()
//        if flag == false {
//            sceneView.session.pause()
//            flag = true
//        } else {
//            sceneView.session.run(ARWorldTrackingSessionConfiguration())
//            flag = false
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Run the view's session
        sceneView.session.run(ARWorldTrackingSessionConfiguration())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - ARSCNViewDelegate
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("\n\nHEJ\n\n")
    }
    
    
    func scanSign() {
        let img = sceneView.snapshot()
        AppManager.sharedInstance.analyzeImage(image: img, completion: {string in
            print(string!)
        })
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.black
        let textFont = UIFont(name: "Helvetica Bold", size: 64)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 900, height: 600), false, scale)
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .center
        
        let textFontAttributes = [
            .font: textFont,
            .foregroundColor: textColor,
            NSAttributedStringKey.paragraphStyle: paraStyle
            ] as [NSAttributedStringKey : Any]
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 900, height: 600)))
        
        let rect = CGRect(origin: point, size: CGSize(width: 900, height: 600))
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //MARK: - AppManagerDelegate
    
    @objc func addArScene(scene: SCNScene, withText text: String) {
        let sceneCopy = scene

        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }
        
        /* Construct sign with background with text on */
        var image = UIImage(named: "imageBg")
        image = textToImage(drawText: text, inImage: image!, atPoint: CGPoint(x: 0.0, y: 0.0))
        
        let imagePlane = SCNPlane(width: 0.60, height: 0.40)
        imagePlane.firstMaterial?.diffuse.contents = image
        imagePlane.firstMaterial?.lightingModel = .constant
        
        let planeNode = SCNNode(geometry: imagePlane)
        sceneCopy.rootNode.addChildNode(planeNode)
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.0
        planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        
        sceneView.scene = sceneCopy
    }
}
