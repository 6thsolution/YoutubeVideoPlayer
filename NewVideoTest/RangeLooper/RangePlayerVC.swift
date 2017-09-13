//
//  RangePlayerVC.swift
//  NewVideoTest
//
//  Created by papyrus on 9/13/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class RangePlayerVC: UIViewController {
    let small = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
    let medium = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    let hd = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    
    var looper: RangeLooper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        XCDYouTubeClient.default().getVideoWithIdentifier("186oNNE6LFM") { (video, error) in
            if let streamUrl = (video?.streamURLs[self.small] ??
                video?.streamURLs[self.medium] ??
                video?.streamURLs[self.hd]){
                print("streamUrl", streamUrl.absoluteString)
                DispatchQueue.main.async {
                    self.looper = RangeLooper(videoURL: streamUrl, loopCount: -1)
                    self.looper?.start(in: self.view.layer)
                }
                
            }
        }
//        looper = RangeLooper(videoURL: URL(string: "https://r3---sn-ab5l6n67.googlevideo.com/videoplayback?ipbits=0&signature=9B02D0998AD1B03F3F154A9FB6C97EF82F9E888B.46C978EFEE4691E6580D5F353CD415729B878930&pl=26&ip=136.0.98.84&mm=31&mn=sn-ab5l6n67&itag=36&ms=au&source=youtube&mv=u&dur=367.293&id=o-AN74uKHUeaD0aaidxltsAvEXQuR9dD2bgXcIJtoYV3BO&clen=10728358&sparams=clen%2Cdur%2Cei%2Cgir%2Cid%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Crequiressl%2Csource%2Cexpire&lmt=1503546064583560&gir=yes&mime=video%2F3gpp&requiressl=yes&ei=Lc24WYiXGcal8gS65ZvIAQ&mt=1505283040&key=yt6&expire=1505304973&ratebypass=yes")!, loopCount: -1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //looper?.start(in: self.view.layer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
