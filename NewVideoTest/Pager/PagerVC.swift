//
//  PagerVC.swift
//  NewVideoTest
//
//  Created by Mehdi Sohrabi (mehdok@gmail.com) on 9/3/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit

class PagerVC: UIPageViewController {
    
    var videoList: [String]!
    var webviewPlayer: Player!

    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webviewPlayer = Player(frame: self.view.bounds)
        //TODO fill video list for test
        videoList = ["OmQEsGcwVZY", "186oNNE6LFM", "DEySgiwoMpA", "SdKqR_CBRBk"]

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
    
        let vc = PlayerView(nibName: "PlayerView", bundle: nil)
        vc.player = webviewPlayer
        vc.videoId = videoList[index]
        
        return vc
    }
}

extension PagerVC: UIPageViewControllerDelegate {
    
}

extension PagerVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let videoId = (viewController as! PlayerView).videoId
        let videoIndex = videoList.index(of: videoId!)
        
        return getViewControllerAtIndex(index: videoIndex! + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let videoId = (viewController as! PlayerView).videoId
        let videoIndex = videoList.index(of: videoId!)
        
        return getViewControllerAtIndex(index: videoIndex! - 1)
    }
}
