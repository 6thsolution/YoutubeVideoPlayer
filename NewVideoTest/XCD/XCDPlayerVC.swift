//
//  XCDPlayerVC.swift
//  NewVideoTest
//
//  Created by papyrus on 9/10/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class XCDPlayerVC: UIPageViewController {

    struct PlayerInfo {
        var lastAccess: Double!
        var controller: UIViewController!
    }
    
    var videoList: [String]!
    
    var playerBuffer = [String: PlayerInfo]()
    let bufferSize = 5
    let videoAhead = 2
    
    static let playDuration = 6 * 1000 // second * milli
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        videoList = ["186oNNE6LFM","bxajnypzxh0", "_gEjmghHkD8", "Fq94WTCBQR0", "dl_MCMMM_yg",
                     "IhX0fOUYd8Q", "fLqV5g8D2WA", "ZS-Wh5qN2E8", "1Hr3-ee5VV4",
                     "gx-9S5T_U5g"]
        
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
    

    func getViewControllerAtIndex(videoId: String, player: XCDYouTubeVideoPlayerViewController) -> UIViewController {
        let vc = XCDPlayerView(nibName: "XCDPlayerView", bundle: nil)
        vc.player = player
        vc.videoId = videoId
        
        return vc
    }
}

extension XCDPlayerVC: UIPageViewControllerDelegate {
    
}

extension XCDPlayerVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let videoId: String = (viewController as! XCDPlayerView).videoId
        let index = videoList.index(of: videoId)! + 1
        if index < 0 || index >= videoList.count {
            return nil
        }
        
        return getPlayControllerWith(videoId: videoList[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let videoId: String = (viewController as! XCDPlayerView).videoId
        let index = videoList.index(of: videoId)! - 1
        
        if index < 0 || index >= videoList.count {
            return nil
        }
        
        return getPlayControllerWith(videoId: videoList[index])
    }
}

extension XCDPlayerVC {
    func getCurrentTime() -> Double {
        return CACurrentMediaTime().truncatingRemainder(dividingBy: 1)
    }
    
    func createController(videoId: String) -> UIViewController {
        let player = XCDYouTubeVideoPlayerViewController(videoIdentifier: videoId)
        //player.preferredVideoQualities = [(XCDYouTubeVideoQuality.small240, XCDYouTubeVideoQuality.medium360)]
        player.moviePlayer.controlStyle = .none
        player.moviePlayer.scalingMode = .aspectFill
        player.moviePlayer.prepareToPlay()
        
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



