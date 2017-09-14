//
//  XCDAVPlayerVC.swift
//  NewVideoTest
//
//  Created by Mehdi Sohrabi (mehdok@gmail.com) on 9/11/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import AVKit
import XCDYouTubeKit

class XCDAVPlayerVC: UIViewController {

    var avPlyrViewController: AVPlayerViewController? = nil
    var currentAVPlyrItem: AVPlayerItem? = nil
    
    var currentVideoNO: Int = 0  // For current video track.
    var arrOfAVPItems: [AVPlayerItem] = [AVPlayerItem]()
    var arrOfPlyer: [AVPlayer] = [AVPlayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoList = ["186oNNE6LFM","bxajnypzxh0", "_gEjmghHkD8", "Fq94WTCBQR0", "dl_MCMMM_yg",
                         "IhX0fOUYd8Q", "fLqV5g8D2WA", "ZS-Wh5qN2E8", "1Hr3-ee5VV4",
                         "gx-9S5T_U5g"]
        
        var urlCount = 0
        
        let small = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
        let medium = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
        let hd = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
        
        for videoId in videoList {
            print(videoId)
            XCDYouTubeClient.default().getVideoWithIdentifier(videoId, completionHandler: { (video, error) in
                if let streamUrl = (video?.streamURLs[small] ??
                                    video?.streamURLs[medium] ??
                                    video?.streamURLs[hd]) {
                    urlCount += 1
                    
                    let item = AVPlayerItem(url: streamUrl)
                    item.preferredForwardBufferDuration = CMTimeGetSeconds(CMTime(value: 6, timescale: 1))
                    self.arrOfAVPItems.append(AVPlayerItem(url: streamUrl))
                    print("new url", streamUrl)
                    if urlCount == videoList.count {
                        self.initPlayerController()
                        return
                    }
                }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension XCDAVPlayerVC {
    func initPlayerController() {
        for playerItem in arrOfAVPItems {
            let player = AVPlayer(playerItem: playerItem)
            player.play()
            player.pause()
            
            arrOfPlyer.append(player)
        }
        
        avPlyrViewController = AVPlayerViewController()
        //avPlyrViewController?.delegate = self;
        avPlyrViewController?.player = arrOfPlyer[0]; // Add first player from the Array.
        avPlyrViewController?.showsPlaybackControls = true;
        avPlyrViewController?.allowsPictureInPicturePlayback = true;
        avPlyrViewController?.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        self.present(avPlyrViewController!, animated: true) {
            self.playVideos()
            
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(XCDAVPlayerVC.playNextVideo(_:)))
            leftSwipe.direction = .left
            self.avPlyrViewController?.view.addGestureRecognizer(leftSwipe)
            
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(XCDAVPlayerVC.playPrevVideo(_:)))
            rightSwipe.direction = .right
            self.avPlyrViewController?.view.addGestureRecognizer(rightSwipe)
            
            
        }
    }
}

extension XCDAVPlayerVC {
    func playVideos() {
        currentAVPlyrItem?.removeObserver(self, forKeyPath: "status")
        
        if currentVideoNO > 0 {
            currentAVPlyrItem = arrOfAVPItems[currentVideoNO]
            
            currentAVPlyrItem?.addObserver(self, forKeyPath: "status", options: [NSKeyValueObservingOptions.initial , NSKeyValueObservingOptions.new], context: nil)
            
            avPlyrViewController?.player?.pause()
            avPlyrViewController?.player = nil
            
            avPlyrViewController?.player = arrOfPlyer[currentVideoNO]
            avPlyrViewController?.player?.currentItem?.seek(to: kCMTimeZero)
            avPlyrViewController?.player?.play()
        }
    }
    
    func playNextVideo(_ gusture: UISwipeGestureRecognizer) {
        currentVideoNO += 1
        if currentVideoNO > arrOfAVPItems.count - 1 {
            currentVideoNO = 0
        }
        
        playVideos()
    }
    
    func playPrevVideo(_ gusture: UISwipeGestureRecognizer) {
        currentVideoNO -= 1
        if currentVideoNO < 0 {
            currentVideoNO = arrOfAVPItems.count - 1
        }
        
        playVideos()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(currentAVPlyrItem?.status)
    }
}


