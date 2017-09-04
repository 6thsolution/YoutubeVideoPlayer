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

        self.view.addSubview(player)
        
        player.playVideoWithId(videoId: videoId)
        
        print(videoId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
