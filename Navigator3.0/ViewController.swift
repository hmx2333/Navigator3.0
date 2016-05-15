//
//  ViewController.swift
//  Navigator3.0
//
//  Created by haha on 16/5/14.
//  Copyright © 2016年 haha. All rights reserved.
//

import UIKit
import AVFoundation
import GPUImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var cameraImage: UIView!
    var captureSession = AVCaptureSession()
    var stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraImage.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.sessionPreset = AVCaptureSessionPreset1920x1080
        
        var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError?
        let input = try! AVCaptureDeviceInput(device: backCamera)
        captureSession.addInput(input)
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
            cameraImage.layer.addSublayer(previewLayer)
            captureSession.startRunning()
        }
        
        
        
    }
    
    
    
    
    

    @IBOutlet weak var tempImageView: UIImageView!
    func didPressTakePhoto() {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                (SampleBuffer, error) in
                if SampleBuffer != nil {
                    
                    var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(SampleBuffer)
                    var dataProvider = CGDataProviderCreateWithCFData(imageData)
                    var kCGRenderingIntentDefault = CGColorRenderingIntent.RenderingIntentDefault
                    var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                    
                    var image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    
                    self.tempImageView.image = image
                    self.tempImageView.hidden = false
                    
                }
            })
        }
        
    }
    var didTakePhoto = false
    
    func didPressTakeAnother() {
        if didTakePhoto == true {
            
            tempImageView.hidden = true
            didTakePhoto = false
        }
        else {
            captureSession.startRunning()
            didTakePhoto = true
            didPressTakePhoto()
            
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        didPressTakeAnother()
    }
    
//    func imageFilter() {
//        let imageFilter = GPUImageCannyEdgeDetectionFilter()
//        
//    }
    
    
    
    
}


