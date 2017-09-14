//
//  ServerPlayerView.swift
//  NewVideoTest
//
//  Created by Mehdi Sohrabi (mehdok@gmail.com) on 9/12/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import AVFoundation

class ServerPlayerView: UIViewController {
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var preview: UIImageView!

    var looper: PlayerLooper?
    var videoId: String!
    var visible = false
    var hasPreview = false
    var thumbnail: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func prepare() {
        looper?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        visible = true
        looper?.visible = true
        
        looper?.start(layer: self.view.layer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        visible = false
        looper?.visible = false
        
        looper?.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showPreview()
    }
    
    func showPreview() {
        if thumbnail != nil && preview != nil {
            preview.image = thumbnail
            preview.isHidden = false
            progress.isHidden = true
        }
    }
}

extension ServerPlayerView: PlayerLooperDelegate {
    func onPlayerStatusChanged(status: AVPlayerLooperStatus) {
        if status == AVPlayerLooperStatus.cancelled {
            print("canceled: ", videoId)
        } else if status == AVPlayerLooperStatus.failed {
            print("failed: ", videoId)
        } else if status == AVPlayerLooperStatus.ready {
            print("ready: ", videoId)

            if !visible {
                //prepare()
            }
        } else if status == AVPlayerLooperStatus.unknown {
            print("unknown: ", videoId)
        }
    }
    
    func thumbnailIsReady(image: UIImage?) {
        print("thumbnailIsReady", videoId)
        thumbnail = image
        // if view outlets is loaded
        showPreview()
    }
    
    func playbackStarted() {
        print("playbackStarted", videoId)
        progress.isHidden = true
        preview.isHidden = true
    }
}
