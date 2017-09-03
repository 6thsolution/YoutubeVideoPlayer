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
    fileprivate var videoList: [String]? = nil
    fileprivate var currentPlayingVideo: String? = nil
    fileprivate var isPlaying = false
    fileprivate var playerStatus: PlayerStatus! = PlayerStatus.unstarted

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
            guard let filePath = Bundle.main.path(forResource: "youtube", ofType: "html") else {
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
        
        if (url?.range(of: ApiMessage.bridge.rawValue)) != nil {
            if url?.range(of: ApiMessage.apiReady.rawValue) != nil {
                apiReady = true
                if delegate != nil {
                    playerDelegate?.apiIsReady()
                }
            }
            
            return false
        }
        
        return true
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
        var query = String(format: "playVideo('&d', '&d', '&@');",
                           Int(self.frame.width),
                           Int(self.frame.height),
                           videoId)
    }
}
