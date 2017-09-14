//
//  RangePlayerView.swift
//  NewVideoTest
//
//  Created by Mehdi Sohrabi (mehdok@gmail.com) on 9/13/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import AVFoundation

class RangePlayerView: UIViewController {
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var playerStatus: UILabel!
    
    var looper: RangeLooper?
    var videoUrl: URL!
    var thumbnail: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        looper?.visible = true
        looper?.start(in: view.layer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        looper?.visible = false
        looper?.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        showPreview(show: true)
    }
    
    func prepare() {
        looper?.delegate = self
    }
}

extension RangePlayerView: RangeLooperDelegate {
    func onPlayerStatusChanged(status: AVPlayerLooperStatus) {
        
    }
    
    func thumbnailIsReady(image: UIImage?) {
        thumbnail = image
        showPreview(show: true)
    }
    
    func playbackStarted() {
        showPreview(show: false)
    }
    
    func onLoadError(error: PlaybackError) {
        guard let _ = preview, let _ = progress, let _ = playerStatus else {
            return
        }
        
        preview.isHidden = true
        progress.stopAnimating()
        
        playerStatus.isHidden = false
        playerStatus.text = error.localizedDescription
    }
}

extension RangePlayerView {
    func showPreview(show: Bool) {
        guard let _ = preview, let _ = thumbnail else {
            return
        }
        
        print("showPreview: ", show)
        
        self.progress.stopAnimating()
        self.preview.image = self.thumbnail

//        if !show {
//            UIView.transition(with: preview, duration: 0.5, options: .transitionCrossDissolve, animations: {
//                self.preview.isHidden = !show
//            }, completion: nil)
//        } else {
//            self.preview.isHidden = !show
//        }

//         self.preview.isHidden = !show
        
        UIView.transition(with: preview, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.preview.isHidden = !show
        }, completion: nil)
        
    }
}
