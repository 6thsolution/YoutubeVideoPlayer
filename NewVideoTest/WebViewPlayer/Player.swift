//
//  Player.swift
//  NewVideoTest
//
//  Created by Mehdi Sohrabi (mehdok@gmail.com) on 9/3/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit

protocol PlayerDelegate: class {
    // The caller view must check the api status via `isApiReady`, if it's true
    // it can proceed with loading video, if not it must listen to this method
    // call and take action upon it
    func apiIsReady()
}

class Player: UIWebView {
    
    weak var playerDelegate: PlayerDelegate? = nil
    
    fileprivate var apiReady = false
    fileprivate var currentPlayingVideo: String? = nil
    fileprivate var isPlaying = false
    fileprivate var playerStatus: PlayerStatus! = PlayerStatus.unstarted
    var duration: Int! = 5
    var quality: VideoQuality! = VideoQuality.defalt
    var videoList: [String]? = nil

    fileprivate enum ApiMessage: String {
        case bridge = "youtube_bridge://"
        case apiReady = "onYouTubeIframeAPIReady"
        case playerStatusChanged = "playerStatusChanged"
    }
    
    fileprivate enum PlayerStatus: String {
        case playing = "YT.PlayerState.PLAYING"
        case unstarted = "YT.PlayerState.UNSTARTED"
        case ended = "YT.PlayerState.ENDED"
        case paused = "YT.PlayerState.PAUSED"
        case buffering = "YT.PlayerState.BUFFERING"
        case cued = "YT.PlayerState.CUED"
        case ready = "YT.PlayerState.READY"
    }
    
    enum VideoQuality: String {
        case small = "small"
        case medium = "medium"
        case large = "large"
        case hd720 = "hd720"
        case hd1080 = "hd1080"
        case highres = "highres"
        case defalt = "default"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        localInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        localInit()
    }
    
    private func localInit() {
        isOpaque = false
        backgroundColor = .clear
        allowsInlineMediaPlayback = true
        mediaPlaybackRequiresUserAction = false
        delegate = self
        scrollView.isScrollEnabled = false
        
        loadPlayer()
    }
    
    private func loadPlayer() {
        do {
            guard let filePath = Bundle.main.path(forResource: "JSPlayer", ofType: "html") else {
                return
            }
            
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            loadHTMLString(content, baseURL: Bundle.main.resourceURL)
            
        } catch  {
            fatalError("can not load html")
        }
    }
}

extension Player: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url?.absoluteString
//        print(url)
        if let apiRange = url?.range(of: ApiMessage.bridge.rawValue) {
            print(url?.substring(from: apiRange.lowerBound) ?? "")
            if let range = url?.range(of: ApiMessage.apiReady.rawValue) {
                //let msg = url?.substring(from: range.lowerBound)
                
                apiReady = true
                if delegate != nil {
                    playerDelegate?.apiIsReady()
                }
            }
            
            return false
        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let loc = webView.stringByEvaluatingJavaScript(from: "window.location")
        print("webViewDidFinishLoad", loc)
        apiInitJSPlayer(videoList!, duration, quality)
    }
}

extension Player {
    func setVideoList(videos: [String]) {
        self.videoList = videos
    }
    
    func playVideoWithId(videoId: String) {
        currentPlayingVideo = videoId
        
        if apiReady == true {
            // play the video
            apiPlayVideoById(videoId)
        }
    }
    
    func isApiReady() -> Bool {
        return apiReady
    }
}

extension Player {
    fileprivate func apiPlayVideoById(_ videoId: String) {
        print("apiPlayVideoById", videoId, Int(self.frame.width), Int(self.frame.height))
        let query = String(format: "playVideo('%d', '%d', '%@');",
                           Int(self.frame.width),
                           Int(self.frame.height),
                           videoId)
        stringByEvaluatingJavaScript(from: query)
    }
    
    fileprivate func apiInitJSPlayer(_ videoList: [String], _ duration: Int, _ quality: VideoQuality) {
        let query = String(format: "start(%d, '%@');",
                           duration,
                           quality.rawValue)
        stringByEvaluatingJavaScript(from: query)
        
        for videoId in videoList {
            let js = String(format: "addVideoId('%@');", videoId)
            stringByEvaluatingJavaScript(from: js)
        }
    }
}
