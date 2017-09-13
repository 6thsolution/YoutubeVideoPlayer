//
//  RangePlayerVC.swift
//  NewVideoTest
//
//  Created by papyrus on 9/13/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class RangePlayerVC: UIPageViewController {
    @IBOutlet weak var status: UILabel!
    
    let small = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
    let medium = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    let hd = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    
    var videoUrls = [URL]()
    
    let videoAhead = 2
    var controllerList = [URL: RangePlayerView]()
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self

        let videoList = ["186oNNE6LFM","bxajnypzxh0", "_gEjmghHkD8", "Fq94WTCBQR0", "dl_MCMMM_yg",
                         "IhX0fOUYd8Q", "fLqV5g8D2WA", "ZS-Wh5qN2E8", "1Hr3-ee5VV4",
                         "gx-9S5T_U5g"]
        
        
        for videoId in videoList {
                        
            XCDYouTubeClient.default().getVideoWithIdentifier(videoId, completionHandler: { (video, error) in
                if let streamUrl = (video?.streamURLs[self.small] ??
                    video?.streamURLs[self.medium] ??
                    video?.streamURLs[self.hd]) {
                    
                    print("url received: ", videoId)
                    self.videoUrls.append(streamUrl)
                    
                    if self.videoUrls.count == videoList.count {
                        DispatchQueue.main.async {
                            self.startShowingVideos()
                        }
                    }
                }
            })
        }
    }
    
    func startShowingVideos() {
        
        let firstController = getPlayControllerWith(videoUrl: videoUrls[0])
        
        self.setViewControllers([firstController],
                                direction: .forward,
                                animated: false,
                                completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //looper?.start(in: self.view.layer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RangePlayerVC: UIPageViewControllerDelegate {
    
}

extension RangePlayerVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let videoUrl: URL = (viewController as! RangePlayerView).videoUrl
        let index = videoUrls.index(of: videoUrl)! + 1
        if index < 0 || index >= videoUrls.count {
            return nil
        }
        
        return getPlayControllerWith(videoUrl: videoUrls[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let videoUrl: URL = (viewController as! RangePlayerView).videoUrl
        let index = videoUrls.index(of: videoUrl)! - 1
        
        if index < 0 || index >= videoUrls.count {
            return nil
        }
        
        return getPlayControllerWith(videoUrl: videoUrls[index])
    }

}

extension RangePlayerVC {
    func getPlayControllerWith(videoUrl: URL) -> RangePlayerView {
        if controllerList[videoUrl] != nil {
            bufferNextItems(currentUrl: videoUrl)
            
            return controllerList[videoUrl]!
        }
        
        let vc = createPlayer(videoUrl: videoUrl)
        
        controllerList[videoUrl] = vc
        
        // buffer next looper
        bufferNextItems(currentUrl: videoUrl)
        
        return vc
    }
    
    func createLooper(videoUrl: URL) -> RangeLooper {
        return RangeLooper(videoURL: videoUrl, loopCount: -1)
    }
    
    func createPlayer(videoUrl: URL) -> RangePlayerView {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "range_player_view") as! RangePlayerView
        
        vc.videoUrl = videoUrl
        vc.looper = createLooper(videoUrl: videoUrl)
        vc.prepare()
        
        return vc
    }

    func bufferNextItems(currentUrl: URL) {
        for index in 1...videoAhead {
            let videoIndex = videoUrls.index(of: currentUrl)
            let nextIndex = videoIndex! + index
            if nextIndex >= videoUrls.count {
                continue
            }
            
            let nextUrl = videoUrls[nextIndex]
            
            if controllerList[nextUrl] != nil {
                continue
            }
            
            controllerList[nextUrl] = createPlayer(videoUrl: nextUrl)
        }
    }

}
