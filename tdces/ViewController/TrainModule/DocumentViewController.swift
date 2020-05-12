//
//  DocumentViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/29.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import WebKit
class DocumentViewController: UIViewController {
    
    var webView: WKWebView!
    
    var material:MaterialBean?
    
    override func loadView() {
        weak var weakSelf=self
        //创建网页加载的偏好设置
        let prefrences = WKPreferences()
        prefrences.javaScriptEnabled = false
        
        //配置网页视图
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = prefrences
        weakSelf!.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        weakSelf!.webView.navigationDelegate = weakSelf
        view = weakSelf!.webView
    }
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "DocumentViewController 被销毁！！！！！！！！")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf=self
        if(material?.medium != nil){
            if((material?.medium!.count)! > 0){
//                let UrlString:String = "https://114.116.157.104/client/#/Register/Agreement"
                var UrlString:String = PHOTO_URL
                UrlString.append((material?.medium?.first!.url)!)
                
                UrlString=UrlString.replacingOccurrences(of: "\\", with: "/")
                let myURL = URL(string:   UrlString)
                let myRequest = URLRequest(url: myURL!)
                weakSelf!.webView.load(myRequest)
            }
        }
        
    }
}
extension DocumentViewController:WKNavigationDelegate{
    //视图开始载入的时候显示网络活动指示器
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    //载入结束后，关闭网络活动指示器
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //阻止链接被点击
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(.cancel)
            
            let alertController = UIAlertController(title: "Action not allowed", message: "Tapping on links is not allowed. Sorry!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
            
        }
        
        decisionHandler(.allow)
    }

}
