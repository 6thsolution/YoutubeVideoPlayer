//
//  PlayerView.swift
//  NewVideoTest
//
//  Created by papyrus on 9/3/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit

class PlayerView: UIViewController {
    var player: Player!
    var videoId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        player.playerDelegate = self
        
        self.view.addSubview(player)
        
        if player.isApiReady() {
            play()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func play() {
        player.playVideoWithId(videoId: videoId)
        
        print("play ", videoId)
    }
}

extension PlayerView: PlayerDelegate {
    func apiIsReady() {
        play()
    }
}
