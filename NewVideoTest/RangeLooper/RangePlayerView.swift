//
//  RangePlayerView.swift
//  NewVideoTest
//
//  Created by papyrus on 9/13/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit

class RangePlayerView: UIViewController {

    @IBOutlet weak var playerStatus: UILabel!
    var looper: RangeLooper?
    var videoUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var url = videoUrl.absoluteString
        url = String(url.characters.suffix(20))
        print("load controller for: ", url)
    }

    override func viewDidAppear(_ animated: Bool) {
        looper?.start(in: view.layer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        looper?.stop()
    }
    
    func prepare() {
        
    }
}
