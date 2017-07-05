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
        
        let rc = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(rc)
        
        /* Start checking user location */
        AppManager.sharedInstance.startUpdatingLocation()
        AppManager.sharedInstance.delegate = self
    }
    
    @objc
    func handleTap(recog: UITapGestureRecognizer) {
        
        
    }
    
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
    
    @objc func addArScene(scene: SCNScene) {
        let sceneCopy = scene

        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }
                
        let imagePlane = SCNPlane(width: 0.20, height: 0.28)
        imagePlane.firstMaterial?.diffuse.contents = UIImage(named: "sign1")
        imagePlane.firstMaterial?.lightingModel = .constant
        
        let planeNode = SCNNode(geometry: imagePlane)
        sceneCopy.rootNode.addChildNode(planeNode)
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.5
        planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        
        sceneView.scene = sceneCopy
    }
}
