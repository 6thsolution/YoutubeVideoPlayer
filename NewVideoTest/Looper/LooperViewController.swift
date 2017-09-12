//
//  LooperViewController.swift
//  NewVideoTest
//
//  Created by papyrus on 9/11/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import AVFoundation
import XCDYouTubeKit

class LooperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let small = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
        let medium = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
        let hd = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
        
        XCDYouTubeClient.default().getVideoWithIdentifier("186oNNE6LFM") { (video, error) in
            if let streamUrl = (video?.streamURLs[small] ??
                video?.streamURLs[medium] ??
                video?.streamURLs[hd]) {
                
                print("url", streamUrl)
                
                let lopper = QueuePlayerLooper2(videoURL: streamUrl, loopCount: -1, timeRange: self.createCMTimeRange(start: 0, end: 10))
                
                lopper.start(in: self.view.layer)
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func createCMTimeRange(start:TimeInterval, end:TimeInterval) -> CMTimeRange {
        
        let a:CMTime = CMTime(seconds: start, preferredTimescale: 1)
        let b:CMTime = CMTime(seconds: end, preferredTimescale: 1)
        return CMTimeRange(start: a, end: b)
    }
}
