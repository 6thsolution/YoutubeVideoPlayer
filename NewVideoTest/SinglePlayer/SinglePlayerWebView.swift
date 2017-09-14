//
//  SinglePlayerWebView.swift
//  NewVideoTest
//
//  Created by Mehdi Sohrabi (mehdok@gmail.com) on 9/5/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit

class SinglePlayerWebView: UIWebView {

    var videoId: String!
    
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
        
    }
    
    func setVId(_ vid: String) {
        videoId = vid
    }
    
    func loadPlayer() {
        do {
            guard let filePath = Bundle.main.path(forResource: "SingleJSPlayer", ofType: "html") else {
                return
            }
            
            var content = try String(contentsOfFile: filePath, encoding: .utf8)
//            content = content.replacingOccurrences(of: "@@@",
//                                                   with: String(format: "height: '%d',width:'%d',videoId: '%@'",
//                                                                Int(self.bounds.height),
//                                                                Int(self.bounds.width),
//                                                                videoId))
            content = content.replacingOccurrences(of: "@@@",
                                                   with: String(format: "height: '%d',width:'%d'",
                                                                200,
                                                                300))
            
            content = content.replacingOccurrences(of: "@@id@@", with: videoId);

            loadHTMLString(content, baseURL: Bundle.main.resourceURL)
            
        } catch  {
            fatalError("can not load html")
        }
    }
}

extension SinglePlayerWebView: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url?.absoluteString
        if let apiRange = url?.range(of: "youtube_bridge") {
            print(url?.substring(from: apiRange.lowerBound) ?? "")
                        
            return false
        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let loc = webView.stringByEvaluatingJavaScript(from: "window.location")
        print("webViewDidFinishLoad", loc)
    }
}

extension SinglePlayerWebView {
    func play() {
        stringByEvaluatingJavaScript(from: "play();")
    }
    
    func pause() {
        stringByEvaluatingJavaScript(from: "pause();")
    }
    
    func stop() {
        
    }
}

