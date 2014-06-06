//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Yong Li on 6/3/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

import UIKit
import imageIO
import MobileCoreServices

class YLImageView : UIImageView {
    override var image:UIImage? {
    get {
        return super.image
    }
    set {
        super.image = newValue
        NSLog("========= $$$$$$$$$ ======= Set image")
    }
    }
}

class ViewController: UIViewController {
    
    var downloadTask:NSURLSessionDownloadTask? = nil
    @IBOutlet var imageView: UIImageView? = nil;
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clicked(sender : AnyObject) {
        var size = sender.size
        println("button: \(sender) clicked, wid: \(size.width), hei: \(size.height)")
        
        var session = NSURLSession.sharedSession()
        var myrequest = NSURLRequest(URL: NSURL.URLWithString("http://cdn1.raywenderlich.com/wp-content/uploads/2013/09/networking7.png"))
        
//        func handler(url : NSURL!, reponse: NSURLResponse!, error : NSError!) -> Void {
//            var img:UIImage? = UIImage(data: NSData(contentsOfURL: url))
//            dispatch_async(dispatch_get_main_queue(), {
//                self.imageView!.image = img
//            })
//        }
        
        // Here we use trailing closures to put the closures out side of the parameters list
        self.downloadTask = session.downloadTaskWithRequest(myrequest) {
            (url : NSURL!, reponse: NSURLResponse!, error : NSError!) -> Void in
            var img:UIImage? = UIImage(data: NSData(contentsOfURL: url))
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView!.image = img
                })
        }
        self.downloadTask!.resume()
        println("task: \(self.downloadTask)")
    }
    
    @IBAction func loadImage(sender : AnyObject) {
        let path = NSBundle.mainBundle().URLForResource("logo", withExtension: "jpg")
        let data = NSData(contentsOfURL: path)
        // parse image from data using UIImage
        //let img = UIImage(data: data)
        
        // or we can use core graphics
        var cgimgsource = CGImageSourceCreateWithData(data, nil).takeRetainedValue()
        
        var imgCount = CGImageSourceGetCount(cgimgsource)
        var isGIF = UTTypeConformsTo(CGImageSourceGetType(cgimgsource).takeUnretainedValue(), kUTTypeGIF)
        var cgimg = CGImageSourceCreateImageAtIndex(cgimgsource, 0, nil).takeUnretainedValue()
        var img = UIImage(CGImage: cgimg)
        self.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView!.image = img
    }
}

