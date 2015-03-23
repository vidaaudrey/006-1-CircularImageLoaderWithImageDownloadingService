//
//  ImageDownloadService.swift
//  006-Circular-Image-Loader-Indicator
//
//  Created by Audrey Li on 3/22/15.
//  Copyright (c) 2015 Shomigo. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloadService: NSObject, NSURLSessionDelegate {
    
    weak var leanCustomImageView: LeanCustomImageView!
    var downloadProgress: CGFloat = 0.0
    var data: NSData!
    
    init(url: String, learnCustomImageView: LeanCustomImageView){
        super.init()
        self.leanCustomImageView = learnCustomImageView
        downloadImageWithURL(url)
    }
    
    func downloadImageWithURL(url: String) {
        let nsURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: nsURL)
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(SessionProperties.identifier)
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.downloadTaskWithURL(nsURL)
        downloadTask.resume()
    }

    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        downloadProgress = CGFloat(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
        
        //get the main queue and update the progress
        dispatch_async(dispatch_get_main_queue()) {
           self.leanCustomImageView.doWhileLoadingImage(self.downloadProgress)
        }
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        println("didResumeAtOffset: \(fileOffset)")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
   
        var data = NSData(contentsOfURL: location)!
        self.leanCustomImageView.doWhenFinishedLoadingImage(data)
    }
    

}
struct SessionProperties {
    static let identifier:String! = "url_session_background_download"
}