//
//  SinglePlayerVC.swift
//  NewVideoTest
//
//  Created by papyrus on 9/5/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit

class SinglePlayerVC: UIPageViewController {

    var videoList: [String]!
//    var playerList: [SinglePlayerWebView]! = [SinglePlayerWebView]()
    var playerList: [YouTubePlayerView]! = [YouTubePlayerView]()
    var controllerList = [SinglePlayerView] ()
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoList = ["OmQEsGcwVZY", "186oNNE6LFM"]//, "DEySgiwoMpA", "SdKqR_CBRBk"]
        
//        for id in videoList {
//            let player = YouTubePlayerView(frame: self.view.bounds)
//            player.playerVars["autoplay"] = 1 as AnyObject
//            player.playerVars["controls"] = 0 as AnyObject
//            player.playerVars["playsinline"] = 1 as AnyObject
//            player.playerVars["showinfo"] = 0 as AnyObject
//            player.loadVideoID(id)
////            player.setVId(id)
////            player.loadPlayer()
//            playerList.append(player)
//            
//        }
        
        for index in 0...(videoList.count-1) {
            let player = YouTubePlayerView(frame: self.view.bounds)
            player.playerVars["autoplay"] = 1 as AnyObject
            player.playerVars["controls"] = 0 as AnyObject
            player.playerVars["playsinline"] = 1 as AnyObject
            player.playerVars["showinfo"] = 0 as AnyObject
            player.loadVideoID(videoList[index])
            playerList.append(player)
            
            controllerList.append(getViewControllerAtIndex(index: index) as! SinglePlayerView)
        }
        
        self.delegate = self
        self.dataSource = self

        let initialViewController = getViewControllerAtIndex(index: 0)
        self.setViewControllers([initialViewController!],
                                direction: .forward,
                                animated: false,
                                completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getViewControllerAtIndex(index: Int) -> UIViewController? {
        if index < 0 || index >= videoList.count {
            return nil
        }
        
        let vc = SinglePlayerView(nibName: "SinglePlayerView", bundle: nil)
//        vc.player = webviewPlayer
        vc.index = index
        vc.player = playerList[index]
        vc.videoId = videoList[index]
        
        return vc
    }
   
}

extension SinglePlayerVC: UIPageViewControllerDelegate {
    
}

extension SinglePlayerVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index: Int = (viewController as! SinglePlayerView).index + 1
        if index < 0 || index >= videoList.count {
            return nil
        }
        
        return controllerList[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index: Int = (viewController as! SinglePlayerView).index - 1
        if index < 0 || index >= videoList.count {
            return nil
        }
        
        return controllerList[index]
    }
}
