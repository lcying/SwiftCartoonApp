//
//  LCYWebViewController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/16.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import WebKit

class LCYWebViewController: LCYBaseViewController {

    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        webView.load(URLRequest.init(url: URL.init(string: urlString ?? "")!))
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"), target: self, action: #selector(reloadAction))
    }
    
    @objc func reloadAction() {
        self.webView.reload()
    }
    
    // MARK: - lazy loading -----------
    lazy var webView: WKWebView = {
        let webview = WKWebView()
        webview.uiDelegate = self
        webview.navigationDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webview
    }()
    
    lazy var progressView: UIProgressView = {
        let progress = UIProgressView.init()
        progress.trackImage = UIImage.init(named: "nav_bg")
        progress.progressTintColor = .white
        return progress
    }()

}

extension LCYWebViewController: WKUIDelegate, WKNavigationDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            //进度条
            progressView.isHidden = webView.estimatedProgress >= 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        self.title = (webView.title ?? webView.url?.host)
    }
}
