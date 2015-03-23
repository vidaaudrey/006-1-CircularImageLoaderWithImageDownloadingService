//
//  LeanCustomImageView.swift
//  006-Circular-Image-Loader-Indicator
//
//  Created by Audrey Li on 3/22/15.
//  Copyright (c) 2015 Shomigo. All rights reserved.
//

import UIKit

class LeanCustomImageView: UIImageView {

    let imageDownloadService: ImageDownloadService!
    
    var progressIndicatorView: CircularLoaderView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentMode = .ScaleAspectFill
        
        progressIndicatorView = CircularLoaderView(frame: bounds)
        addSubview(self.progressIndicatorView)
        progressIndicatorView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        let url = "http://hdw.datawallpaper.com/nature/just-beautiful-desktop-background-493093.jpg"
        
        imageDownloadService = ImageDownloadService(url: url, learnCustomImageView: self)
        progressIndicatorView.progress = CGFloat(imageDownloadService.downloadProgress)
    }
    
    
    func doWhileLoadingImage(downloadProgress: CGFloat){
        progressIndicatorView.progress = downloadProgress
        println("Download Progress: \(downloadProgress)")

    }
    func doWhenFinishedLoadingImage(data: NSData){
        self.image = UIImage(data: data)
        self.progressIndicatorView.reveal()
        self.progressIndicatorView.progressLabel.text = ""
    }

}
