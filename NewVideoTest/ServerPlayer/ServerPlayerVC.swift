//
//  ServerPlayerVC.swift
//  NewVideoTest
//
//  Created by papyrus on 9/12/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit

class ServerPlayerVC: UIPageViewController {
    var videoList:[String]!
    let videoAhead = 2
    var controllerList = [String: ServerPlayerView]()
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        videoList = ["http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-35-13.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-35-21.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-35-26.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-35-56.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-35-57.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-37-39.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-37-40.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-38-32.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-38-33.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-40-09.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-40-10.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-40-50.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-40-51.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-41-33.mp4",
                         "http://mehdi.6thsolution.com/youtube/video_2017-09-11_22-41-34.mp4"]
        
        self.delegate = self
        self.dataSource = self
        
        let firstController = getPlayControllerWith(videoId: videoList[0])
        
        self.setViewControllers([firstController],
                                direction: .forward,
                                animated: false,
                                completion: nil)
        
    }

    func getPlayControllerWith(videoId: String) -> ServerPlayerView {
        if controllerList[videoId] != nil {
            return controllerList[videoId]!
        }
        
        let vc = createPlayer(videoId: videoId)
        
        controllerList[videoId] = vc
        
        // buffer next looper
        bufferNextItems(currentId: videoId)
        
        //vc.looper = QueuePlayerLooper(videoURL: URL(string: videoId)!, loopCount: -1)
        //vc.looper = PlayerLooper(videoURL: URL(string: videoId)!, loopCount: -1)
        
        return vc
    }
    
    func createLooper(videoId: String) -> PlayerLooper {
        return PlayerLooper(videoURL: URL(string: videoId)!, loopCount: -1)
    }
    
    func createPlayer(videoId: String) -> ServerPlayerView {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "server_player_view") as! ServerPlayerView
        
        vc.videoId = videoId
        vc.looper = createLooper(videoId: videoId)
        vc.prepare()
        
        return vc
    }
    
    func bufferNextItems(currentId: String) {
        for index in 1...videoAhead {
            let videoIndex = videoList.index(of: currentId)
            let nextIndex = videoIndex! + index
            if nextIndex >= videoList.count {
                return
            }
            
            let nextId = videoList[nextIndex]
            
            if controllerList[nextId] != nil {
                return
            }
            
            controllerList[nextId] = createPlayer(videoId: nextId)
        }
    }
}

extension ServerPlayerVC: UIPageViewControllerDelegate {
    
}

extension ServerPlayerVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let videoId: String = (viewController as! ServerPlayerView).videoId
        let index = videoList.index(of: videoId)! + 1
        if index < 0 || index >= videoList.count {
            return nil
        }
        
        return getPlayControllerWith(videoId: videoList[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let videoId: String = (viewController as! ServerPlayerView).videoId
        let index = videoList.index(of: videoId)! - 1
        
        if index < 0 || index >= videoList.count {
            return nil
        }
        
        return getPlayControllerWith(videoId: videoList[index])
    }
}

