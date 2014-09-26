//
//  ViewController.swift
//  testiOS8Camera
//
//  Created by Yong Li on 14-9-25.
//  Copyright (c) 2014年 Yong Li. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private var avsession: AVCaptureSession = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.avsession.sessionPreset = AVCaptureSessionPresetPhoto
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for d in devices {
            if let dev = d as? AVCaptureDevice {
            if dev.hasMediaType(AVMediaTypeVideo) && dev.position == AVCaptureDevicePosition.Back {
                
                var error:NSError?
                let input = AVCaptureDeviceInput.deviceInputWithDevice(dev as AVCaptureDevice, error: &error) as AVCaptureInput
                self.avsession.addInput(input)
                
                let previewLayer = AVCaptureVideoPreviewLayer(session: self.avsession)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                self.view.layer.addSublayer(previewLayer)
                
                self.avsession.startRunning()
                
                break
            }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

