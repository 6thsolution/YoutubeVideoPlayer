//
//  ServerPlayerView.swift
//  NewVideoTest
//
//  Created by papyrus on 9/12/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import AVFoundation

class ServerPlayerView: UIViewController {

    var looper: PlayerLooper?
    var videoId: String!
    var visible = false
    
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
                
            }
        } else if status == AVPlayerLooperStatus.unknown {
            print("unknown: ", videoId)
        }
    }
}
