//
//  AVSession.swift
//  ARTest
//
//  Created by Wilhelm Michaelsen on 2017-07-17.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import Foundation
import AVFoundation

protocol AVSessionDelegate {
    func photoTaken(photo: CGImage?)
}

class AVSession: NSObject, AVCapturePhotoCaptureDelegate {
    
    //MARK: - Properties
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
    var previewLayer = AVCaptureVideoPreviewLayer()
    var delegate: AVSessionDelegate?
    
    class var sharedInstance: AVSession {
        
        struct Singleton {
            static let instance = AVSession()
        }
        
        return Singleton.instance
    }
    
    //MARK: - Methods
    
    override init() {
        super.init()
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDualCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera,AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        for device in deviceDiscoverySession.devices {
            if(device.position == AVCaptureDevice.Position.back){
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        
                        if captureSession.canAddOutput(sessionOutput) {
                            captureSession.addOutput(sessionOutput)
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                            previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                        }
                    }
                }
                catch {
                    print("exception!")
                }
            }
        }
        
    }
    
    func start() {
        captureSession.startRunning()
    }
    
    func takePicture() {
        let sessionOutputSettings = AVCapturePhotoSettings(format: ["AVVideoCodecKey":"jpeg"])
        sessionOutput.capturePhoto(with: sessionOutputSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        self.delegate?.photoTaken(photo: photo.cgImageRepresentation()?.takeUnretainedValue())
    }

}
