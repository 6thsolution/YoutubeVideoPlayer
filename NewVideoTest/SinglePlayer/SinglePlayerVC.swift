//
//  SinglePlayerVC.swift
//  NewVideoTest
//
//  Created by papyrus on 9/5/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit

class SinglePlayerVC: UIPageViewController {

    struct PlayerInfo {
        var lastAccess: Double!
        var controller: UIViewController!
    }
    
    var videoList: [String]!
    
    var playerBuffer = [String: PlayerInfo]()
    let bufferSize = 4
    
    static let playDuration = 6 * 1000 // second * milli
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoList = ["OmQEsGcwVZY", "186oNNE6LFM", "DEySgiwoMpA", "SdKqR_CBRBk",
                     "AmV8bp1h-3I", "SJj0qYNN1lU", "iHlczxoNBrA", "sjzzdkUvKhk",
                     "axVR2-2-G4Y", "WPRKKbDMWIU", "vMI8m2rlaSM"]
        
        fillBuffer()
        
        self.delegate = self
        self.dataSource = self
        
        let firstController = playerBuffer[videoList[0]]?.controller
        
        self.setViewControllers([firstController!],
                                direction: .forward,
                                animated: false,
                                completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getViewControllerAtIndex(videoId: String, player: YouTubePlayerView) -> UIViewController {
        let vc = SinglePlayerView(nibName: "SinglePlayerView", bundle: nil)
        vc.player = player
        vc.videoId = videoId
        
        return vc
    }
   
}

extension SinglePlayerVC {
    func fillBuffer() {
        playerBuffer.removeAll()
        
        for index in 0...(bufferSize - 1) {
            if index >= videoList.count { return }
            
            let controller = createController(videoId: videoList[index])
            addPlayerToBuffer(videoList[index], PlayerInfo(lastAccess: getCurrentTime(),
                                                           controller: controller))
        }
    }
    
    func getCurrentTime() -> Double {
        return CACurrentMediaTime().truncatingRemainder(dividingBy: 1)
    }
    
    func createController(videoId: String) -> UIViewController {
        let player = YouTubePlayerView(frame: self.view.bounds)
        player.playerVars["autoplay"] = 1 as AnyObject
        player.playerVars["controls"] = 0 as AnyObject
        player.playerVars["playsinline"] = 1 as AnyObject
        player.playerVars["showinfo"] = 0 as AnyObject
        player.playerVars["rel"] = 0 as AnyObject
        player.playerVars["start"] = 0 as AnyObject
        player.playerVars["end"] = SinglePlayerVC.playDuration as AnyObject
        
        player.loadVideoID(videoId)
        
        return getViewControllerAtIndex(videoId: videoId, player: player)
    }
    
    func getPlayControllerWith(videoId: String) -> UIViewController {
        var playerInfo = playerBuffer[videoId]
        
        if playerInfo == nil {
            playerInfo = PlayerInfo(lastAccess: getCurrentTime(),
                                    controller: createController(videoId: videoId))
            
            addPlayerToBuffer(videoId, playerInfo!)
        }
        
        return (playerInfo?.controller)!
    }
    
    func addPlayerToBuffer(_ videoId: String, _ playerInfo: PlayerInfo) {
        if playerBuffer.count >= bufferSize {
            removeLastUsedControllerFromBuffer()
        }
        
        playerBuffer[videoId] = playerInfo
    }
    
    func removeLastUsedControllerFromBuffer() {
        var lastTime = getCurrentTime()
        var lastVideoId: String? = nil
        
        for (videoId, playerInfo) in playerBuffer {
            if playerInfo.lastAccess <= lastTime {
                lastTime = playerInfo.lastAccess
                lastVideoId = videoId
            }
        }
        
        if lastVideoId != nil {
            playerBuffer.removeValue(forKey: lastVideoId!)
        }
    }
}

extension SinglePlayerVC: UIPageViewControllerDelegate {
    
}

extension SinglePlayerVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let videoId: String = (viewController as! SinglePlayerView).videoId
        let index = videoList.index(of: videoId)! + 1
        if index < 0 || index >= videoList.count {
            return nil
        }
        
        return getPlayControllerWith(videoId: videoList[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let videoId: String = (viewController as! SinglePlayerView).videoId
        let index = videoList.index(of: videoId)! - 1

        if index < 0 || index >= videoList.count {
            return nil
        }
        
        return getPlayControllerWith(videoId: videoList[index])
    }
}
