//
//  BaseWebViewController.swift
//  DAPPBrowser
//
//  Created by ColdChains on 2018/9/13.
//  Copyright © 2018 ColdChains. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class BaseWebViewController: BaseViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    override var prefersStatusBarHidden: Bool {
        return UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }
    
    private struct Keys {
        static let title = "title"
        static let canGoBack = "canGoBack"
        static let estimatedProgress = "estimatedProgress"
    }
    
    var titleString: String? {
        didSet {
            navigationBar.titleLabel.text = titleString
        }
    }
    
    var urlString: String = ""
    var showNavigationBar: Bool = true
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .progress
        progressView.trackTintColor = .clear
        return progressView
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
    
    init(urlString: String = "", showNavigationBar: Bool = true) {
        super.init(nibName: nil, bundle: nil)
        self.urlString = urlString
        self.showNavigationBar = showNavigationBar
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBar()
        navigationBar.titleLabel.text = titleString
        navigationBar.style = .webview
        
        view.addSubview(webView)
        webView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(NavigationBarHeight)
            make.left.right.bottom.equalToSuperview()
        })
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(NavigationBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        })
        
        if !showNavigationBar {
            navigationBar.backgroundColor = .clear
            webView.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(StatusBarHeight)
            }
            progressView.snp.updateConstraints { (make) in
                make.top.equalToSuperview()
            }
        }
        
        webView.addObserver(self, forKeyPath: Keys.title, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: Keys.canGoBack, options: [.new, .initial], context: nil)
        webView.addObserver(self, forKeyPath: Keys.estimatedProgress, options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeStatusBarFrameAction), name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
        
        startRequest()
        
    }
    
    override func navigationBarDidSelectLeftItem() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            super.navigationBarDidSelectLeftItem()
        }
    }
    
    @objc private func didChangeStatusBarFrameAction() {
        switch UIDevice.current.orientation {
        case .portrait:
            navigationBar.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(0)
            }
            if !showNavigationBar {
                navigationBar.backgroundColor = .clear
                webView.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(StatusBarHeight)
                }
            }
        default:
            navigationBar.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(-StatusBarHeight)
            }
            if !showNavigationBar {
                navigationBar.backgroundColor = .clear
                webView.snp.updateConstraints { (make) in
                    make.top.equalToSuperview()
                }
            }
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: Keys.title)
        webView.removeObserver(self, forKeyPath: Keys.canGoBack)
        webView.removeObserver(self, forKeyPath: Keys.estimatedProgress)
        NotificationCenter.default.removeObserver(self)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else { return }
        if keyPath == Keys.estimatedProgress {
            guard let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue else { return }
            progressView.progress = progress
            progressView.isHidden = progress >= 1
        } else if keyPath == Keys.title && titleString == nil {
            navigationBar.titleLabel.text = change[NSKeyValueChangeKey.newKey] as? String
        } else if keyPath == Keys.canGoBack {
            navigationBar.closeBarButton.isHidden = !webView.canGoBack
        }
    }
    
    func startRequest() {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        webView.load(request)
    }

}

extension BaseWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
            let scheme = url.scheme,
            scheme == "tel", let resourceSpecifier = ((url) as NSURL).resourceSpecifier {
            guard let url = URL(string: "telprompt://" + resourceSpecifier) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
}

extension BaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? Dictionary<String, Any> else { return }
        print("didReceive")
        print(body)
    }
}

extension BaseWebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return webView
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: .none, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: .none, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { _ in
            completionHandler(false)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: .none, message: prompt, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { _ in
            completionHandler(nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
}
