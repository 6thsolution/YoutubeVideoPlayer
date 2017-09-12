/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	An object that uses AVPlayerLooper to loop a video.
*/

import UIKit
import AVFoundation

protocol PlayerLooperDelegate: class {
    func onPlayerStatusChanged(status: AVPlayerLooperStatus)
    func thumbnailIsReady(image: UIImage)
    func playbackStarted()
}

class PlayerLooper: NSObject {
    // MARK: Types

    private struct ObserverContexts {
        static var isLooping = 0
        
        static var isLoopingKey = "isLooping"
        
        static var loopCount = 0
        
        static var loopCountKey = "loopCount"
        
        static var playerItemDurationKey = "duration"
    }

    // MARK: Properties

    private var player: AVQueuePlayer?

    private var playerLayer: AVPlayerLayer?

    private var playerLooper: AVPlayerLooper?

    private var isObserving = false

    private let numberOfTimesToPlay: Int

    private let videoURL: URL
    
    private var playerItem: AVPlayerItem?
    private var itemReady = false
    var visible = false
    var parentLayer: CALayer!
    
    weak var delegate: PlayerLooperDelegate? = nil

    // MARK: Looper

    required init(videoURL: URL, loopCount: Int) {

        self.videoURL = videoURL
        self.numberOfTimesToPlay = loopCount
        playerItem = AVPlayerItem(url: videoURL)
        
        super.init()

        
        playerItem?.asset.loadValuesAsynchronously(forKeys: ["playable", "tracks", "duration"], completionHandler: {()->Void in
            self.itemReady = true
            
            self.sendThumbnail()
            
            if self.visible == true {
                self.start(layer: self.parentLayer)
            }
        })
    }
    
    func sendThumbnail() {
        do {
            let imageGenerator = AVAssetImageGenerator(asset: (playerItem?.asset)!)
            let time = CMTimeMake(1, 1)
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: imageRef)
            
            DispatchQueue.main.async {
                self.delegate?.thumbnailIsReady(image: thumbnail)
            }
        } catch _ {
            
        }
        
    }

    func start(layer: CALayer) {
        parentLayer = layer
        
        if !itemReady {
            return
        }
                
        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)

        guard let playerLayer = playerLayer else { fatalError("Error creating player layer") }
        playerLayer.frame = parentLayer.bounds
        parentLayer.addSublayer(playerLayer)

        
        guard let player = self.player else { return }
        
        var durationError: NSError? = nil
        let durationStatus = playerItem?.asset.statusOfValue(forKey: ObserverContexts.playerItemDurationKey, error: &durationError)
        guard durationStatus == .loaded else { fatalError("Failed to load duration property with error: \(durationError)") }
        
        self.playerLooper = AVPlayerLooper(player: player, templateItem: playerItem!)
        self.startObserving()
        player.play()
        
        delegate?.playbackStarted()
    }
    
    func showThumbnail(layer: CALayer) {
        start(layer: layer)
        player?.pause()
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }

    func stop() {
        player?.pause()
        stopObserving()

        playerLooper?.disableLooping()
        playerLooper = nil

        playerLayer?.removeFromSuperlayer()
        playerLayer = nil

        player = nil
    }

    // MARK: Convenience

    private func startObserving() {
        guard let playerLooper = playerLooper, !isObserving else { return }

        playerLooper.addObserver(self, forKeyPath: ObserverContexts.isLoopingKey, options: .new, context: &ObserverContexts.isLooping)
        playerLooper.addObserver(self, forKeyPath: ObserverContexts.loopCountKey, options: .new, context: &ObserverContexts.loopCount)

        playerLooper.addObserver(self, forKeyPath: "status", options: [.old, .initial, .new], context: nil)
        
        isObserving = true
    }

    private func stopObserving() {
        guard let playerLooper = playerLooper, isObserving else { return }

        playerLooper.removeObserver(self, forKeyPath: ObserverContexts.isLoopingKey, context: &ObserverContexts.isLooping)
        playerLooper.removeObserver(self, forKeyPath: ObserverContexts.loopCountKey, context: &ObserverContexts.loopCount)
        
        playerLooper.removeObserver(self, forKeyPath: "status", context: nil)

        isObserving = false
    }

    // MARK: KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            delegate?.onPlayerStatusChanged(status: (playerLooper?.status)!)
            
            return
        }
        
        if context == &ObserverContexts.isLooping {
            if let loopingStatus = change?[.newKey] as? Bool, !loopingStatus {
                print("Looping ended due to an error")
            }
        }
        else if context == &ObserverContexts.loopCount {
            guard let playerLooper = playerLooper else { return }

            if numberOfTimesToPlay > 0 && playerLooper.loopCount >= numberOfTimesToPlay - 1 {
                print("Exceeded loop limit of \(numberOfTimesToPlay) and disabling looping");
                stopObserving()
                playerLooper.disableLooping()
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
