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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecog:)))
//        view.addGestureRecognizer(tapGesture)
        
        /* Start checking user location */
        AppManager.sharedInstance.startUpdatingLocation()
        AppManager.sharedInstance.delegate = self
    }
//
//    @objc
//    func handleTap(gestureRecog: UITapGestureRecognizer) {
//        guard let currentFrame = sceneView.session.currentFrame else {
//            return
//        }
//
//        let imagePlane = SCNPlane(width: sceneView.bounds.width / 6000, height: sceneView.bounds.height / 6000)
//        imagePlane.firstMaterial?.diffuse.contents = sceneView.snapshot()
//        imagePlane.firstMaterial?.lightingModel = .constant
//
//        let planeNode = SCNNode(geometry: imagePlane)
//        sceneView.scene.rootNode.addChildNode(planeNode)
//
//        var translation = matrix_identity_float4x4
//        translation.columns.3.z = -1.5
//        translation.columns.3.x = -1.5
//        planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
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
        
    }
    
    //MARK: - AppManagerDelegate
    func addArScene(scene: SCNScene) {
        sceneView.scene = scene
    }
}
