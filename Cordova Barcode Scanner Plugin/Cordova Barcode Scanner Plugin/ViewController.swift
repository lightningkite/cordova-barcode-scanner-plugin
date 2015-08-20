//
//  ViewController.swift
//  Cordova Barcode Scanner Plugin
//
//  Created by Erik Sargent on 12/24/14.
//  Copyright (c) 2015 Christian West. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK: Properties
    let session: AVCaptureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    lazy var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    var barcode = ""
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the “var” keyword and not “let”
        var error : NSError? = nil
        
        let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        
        device.lockForConfiguration(nil)
        
        if device.focusPointOfInterestSupported {
            device.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
        }
        if device.hasTorch && device.isTorchModeSupported(.Auto) {
            device.torchMode = .Auto
            
            //For the torch to work, the AVCaptureSession must have a video data output, even though it is unused
            let videoOutput = AVCaptureVideoDataOutput()
            session.addOutput(videoOutput)
        }
        
        device.unlockForConfiguration()
        
        // If our input is not nil then add it to the session, otherwise we’re kind of done!
        if input != nil {
            session.addInput(input)
        }
        else {
            // This is fine for a demo, do something real with this in your app. :)
            println(error)
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        session.startRunning()
        
        let gesture = UITapGestureRecognizer(target: self, action: "onTap:")
        view.addGestureRecognizer(gesture)
        
        let guideImage = UIImageView(image: UIImage(named: "Scan_Overlay"))
        let width = view.frame.width * 2 / 3;
        let height = width * (175 / 205);
        guideImage.frame = CGRectMake(view.frame.width / 2 - width / 2, view.frame.height / 2 - height / 2, width, height)
        
        view.addSubview(guideImage);
        
        let helpText = UILabel(frame: CGRectMake(0, guideImage.frame.origin.y - 30, view.frame.width, 25))
        helpText.font = UIFont(name: "HelveticaNeue", size: 17)
        helpText.text = "Scan a barcode for more info"
        helpText.textAlignment = NSTextAlignment.Center
        helpText.textColor = UIColor.whiteColor()
        
        helpText.layer.shadowColor = UIColor.blackColor().CGColor
        helpText.layer.shadowOffset = CGSizeMake(0, 0)
        helpText.layer.shadowRadius = 2.0
        helpText.layer.shadowOpacity = 1
        
        view.addSubview(helpText)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground", name:UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        session.startRunning()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        session.stopRunning()
    }
    
    
    //MARK: Application Control
    func applicationWillEnterForeground() {
        session.startRunning()
    }
    
    func applicationDidEnterBackground() {
        session.stopRunning()
    }
    
    
    //MARK: Actions
    func onTap(gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.locationInView(self.view)
        let focusPoint = CGPointMake(
            tapPoint.x / self.view.bounds.size.width,
            tapPoint.y / self.view.bounds.size.height)
        
        if device == nil {
            return
        } else if device.lockForConfiguration(nil) {
            device.focusPointOfInterest = focusPoint
            device.focusMode = .AutoFocus
            device.unlockForConfiguration()
        }
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for metadataObject : AnyObject in metadataObjects {
            let transformedMetadataObject = previewLayer.transformedMetadataObjectForMetadataObject(metadataObject as! AVMetadataObject)
            if transformedMetadataObject.isKindOfClass(AVMetadataMachineReadableCodeObject.self) {
                let barcodeObject = transformedMetadataObject as! AVMetadataMachineReadableCodeObject
                
                barcode = barcodeObject.stringValue

                dispatch_async(dispatch_get_main_queue(), {
                })
                session.stopRunning()
            }
        }
    }
    
}