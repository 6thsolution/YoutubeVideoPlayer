//
//  Looper.swift
//  NewVideoTest
//
//  Created by papyrus on 9/11/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import AVFoundation

protocol Looper {
    init(videoURL: URL, loopCount: Int, timeRange:CMTimeRange)
    
    func start(in layer: CALayer)
    
    func stop()

}
