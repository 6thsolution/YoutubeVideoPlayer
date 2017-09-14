//
//  RangePlayerView.swift
//  NewVideoTest
//
//  Created by papyrus on 9/13/17.
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
    var visible: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var url = videoUrl.absoluteString
        url = String(url.characters.suffix(20))
        print("load controller for: ", url)
        
        looper?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        visible = true
        looper?.visible = true
        looper?.start(in: view.layer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        visible = false
        looper?.visible = false
        looper?.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showPreview(show: true)
    }
    
    func prepare() {
        
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
        print("onLoadError: " , error.localizedDescription)
    }
}

extension RangePlayerView {
    func showPreview(show: Bool) {
        guard let _ = preview, let _ = thumbnail, !visible else {
            return
        }
        
        UIView.transition(with: preview, duration: 0.4, options: .curveEaseInOut, animations: {
            self.progress.stopAnimating()
            self.preview.isHidden = show
        }, completion: nil)
    }
}
