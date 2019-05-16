//
//  AuthViewController.swift
//  KitchenCatalogue
//
//  Created by iniad on 2019/04/25.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class AuthWebViewController: BaseViewController {
    let toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.black
        return toolbar
    }()
    
    let webView: WKWebView = {
        let view = WKWebView()
        view.allowsBackForwardNavigationGestures = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.webView)
        self.setupLayout()
        self.setToolbar()
        self.webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.webView.load(URLRequest(url: UnsplashAuth.shared.generateAuthorizeFullPath(keys: [.public, .writeUser])!))
    }
    
    private func setupLayout() {
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.webView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func setToolbar() {
        let backbutton = UIBarButtonItem(image: UIImage(named: "round-navigate_before"), style: .plain, target: self, action: #selector(self.webView.goBack))
        let nextButton = UIBarButtonItem(image: UIImage(named: "round-navigate_next"), style: .plain, target: self, action: #selector(self.webView.goForward))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "round-refresh"), style: .plain, target: self, action: #selector(self.webView.reload))
        self.toolBar.setItems([backbutton, nextButton, refreshButton], animated: false)
    }
    
    private func presentTimeLine() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            if self.navigationController != nil {
                self.navigationController?.pushViewController(TimeLineViewController(), animated: true)
            }else{
                self.present(UINavigationController(rootViewController: TimeLineViewController()), animated: true, completion: nil)
            }
        }
    }
}

extension AuthWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url?.absoluteURL
        if UnsplashAuth.isMatchRedirectURI(uri: url) {
            let code = try! parseCode(url: url)
            fetchTokenAndPresentingTimeLine(code: code)
            decisionHandler(WKNavigationActionPolicy.cancel)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
    
    func fetchTokenAndPresentingTimeLine(code: String) {
        UnsplashAuth.shared.fetchAndRegistToken(code: code) { [weak self] (result) in
            guard case .failure(let error) = result else {
                self?.presentTimeLine()
                return
            }
            debugLog(items: error)
            return
        }
    }
    
    private func parseCode(url: URL?) throws -> String {
        guard let url = url else {
            throw NSError(domain: "define url ", code: 0, userInfo: nil)
        }
        return try parseCode(query: url.parseQuery())
    }
    
    private func parseCode(query: [String: String?]) throws -> String {
        guard let code: String = query["code"] as? String else {
            throw NSError(domain: "define code", code: 0, userInfo: nil)
        }
        return code
    }
}
