//
//  XCDPlayerView.swift
//  NewVideoTest
//
//  Created by papyrus on 9/10/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import MediaPlayer

class XCDPlayerView: UIViewController {
    var videoId: String!
    var player: XCDYouTubeVideoPlayerViewController!
    
    var isViewVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        NotificationCenter.default.addObserver(self, selector: "", name: MPMoviePlayerPlaybackStateDidChangeNorification, object: nil)
        
        player.present(in: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        player.moviePlayer.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player.moviePlayer.pause()
    }
}
