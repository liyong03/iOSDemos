//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Yong Li on 6/3/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var downloadTask:NSURLSessionDownloadTask? = nil
                            
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
        
        func handler(url : NSURL!, reponse: NSURLResponse!, error : NSError!) -> Void {
            println("url:\(url)\n response:\(reponse)\n error: \(error)")
        }
        
        self.downloadTask = session.downloadTaskWithRequest(myrequest, completionHandler: handler)
        self.downloadTask!.resume()
        println("task: \(self.downloadTask)")
    }

}

