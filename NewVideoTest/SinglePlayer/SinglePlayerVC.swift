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
    let bufferSize = 15
    let videoAhead = 1
    
    static let playDuration = 20 // second * milli
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoList = ["186oNNE6LFM","bxajnypzxh0", "_gEjmghHkD8", "Fq94WTCBQR0", "dl_MCMMM_yg",
                     "IhX0fOUYd8Q", "fLqV5g8D2WA", "ZS-Wh5qN2E8", "1Hr3-ee5VV4",
                     "gx-9S5T_U5g"]
        //fillBuffer()
        
        self.delegate = self
        self.dataSource = self
        
        let firstController = getPlayControllerWith(videoId: videoList[0])
        
        self.setViewControllers([firstController],
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
        vc.player.delegate = vc
        vc.player.loadVideoID(videoId)
        
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
        
        //player.loadVideoID(videoId)
        
        return getViewControllerAtIndex(videoId: videoId, player: player)
    }
    
    func getPlayControllerWith(videoId: String) -> UIViewController {
        var playerInfo = playerBuffer[videoId]
        
        if playerInfo == nil {
            playerInfo = PlayerInfo(lastAccess: getCurrentTime(),
                                    controller: createController(videoId: videoId))
            
            addPlayerToBuffer(videoId, playerInfo!)
        }
        
        // add next videos to buffer
        let videoIndex = videoList.index(of: videoId)
        refillBuffer(videoIndex: videoIndex!)
        
        return (playerInfo?.controller)!
    }
    
    func addPlayerToBuffer(_ videoId: String, _ playerInfo: PlayerInfo) {
        if playerBuffer.count >= bufferSize {
            removeLastUsedControllerFromBuffer()
        }
        
        playerBuffer[videoId] = playerInfo
    }
    
    func refillBuffer(videoIndex: Int) {
        for index in 1...videoAhead {
            let nextIndex = videoIndex + index
            
            // if there is no more video after this break
            if nextIndex >= videoList.count {
                break
            }
            
            // if player exist in buffer break
            if playerBuffer[videoList[nextIndex]] != nil {
                break
            }
            
            let info = PlayerInfo(lastAccess: getCurrentTime(),
                                  controller: createController(videoId: videoList[nextIndex]))
            
            if playerBuffer.count >= bufferSize {
                removeLastUsedControllerFromBuffer()
            }
            
            print("add video \(nextIndex) to buffer")
            playerBuffer[videoList[nextIndex]] = info
        }
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
