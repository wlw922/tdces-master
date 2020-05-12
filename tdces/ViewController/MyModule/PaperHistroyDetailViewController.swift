//
//  PaperHistroyDetailViewController.swift
//  tdces
//
//  Created by Str1ng on 2020/1/17.
//  Copyright © 2020 gmcx. All rights reserved.
//

import Foundation
import WebKit
import SwiftyXMLParser
import SwiftyJSON
class PaperHistroyDetailViewController:UIViewController{
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "TranscriptDetailViewController 被销毁！！！！！！！！")
    }
    var webView: WKWebView!
    
    var examId:String?
    
    override func loadView() {
        weak var weakSelf=self
        //创建网页加载的偏好设置
        let prefrences = WKPreferences()
        prefrences.javaScriptEnabled = true
        
        //配置网页视图
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = prefrences
        weakSelf!.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        weakSelf!.webView.navigationDelegate = weakSelf
        view = weakSelf!.webView
    }
}
extension PaperHistroyDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = ""
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
       
//        weak var weakSelf=self
//        //                let UrlString:String = "https://114.116.157.104/client/#/Register/Agreement"
//        var UrlString:String = PAPER_URL
//        UrlString.append(examId!)
//        UrlString=UrlString.replacingOccurrences(of: "\\", with: "/")
//        let myURL = URL(string:   UrlString)
//        let myRequest = URLRequest(url: myURL!)
//        weakSelf!.webView.load(myRequest)
        
        getExamAllByDetail()
        print("examId = \(String(describing: examId))")
    }
    
    func getExamAllByDetail(){
           TrainBiz.sharedInstance.getExamAllById(id: examId!) { (responseBean) in
               if(responseBean.success!){
                 //  weak var weakSelf=self
                 //  let transcriptBean:TranscriptBean = responseBean.result as! TranscriptBean
              
               DispatchQueue.main.async {
//                       weakSelf!.labPaperName.text=transcriptBean.paper?.paperName!
//                       var passedString:String=""
//                       if(transcriptBean.isPassed!){
//                           passedString="已通过"
//                       }else{
//                           
//                           passedString="未通过"
//                       }
//                       weakSelf!.labIsPassed.text = passedString
//                       weakSelf!.labExamTime.text = transcriptBean.startTime!
//                       weakSelf!.labEndTime.text = transcriptBean.endTime!
//                       weakSelf!.labScore.text = "\(String(transcriptBean.score!))分"
//                       weakSelf!.labQuestionsCount.text="\(String(transcriptBean.rightNumber!))"+"/"+"\(String(transcriptBean.quesNumber!))"
//                       var elapsedTime:String=""
//                       if(transcriptBean.all!/1000>60){
//                           elapsedTime="\(transcriptBean.all!/1000/60)分\(transcriptBean.all!/1000%60)秒"
//                       }else{
//                           elapsedTime="\(transcriptBean.all!/1000%60)秒"
//                       }
//                       weakSelf!.labElapsedTime.text = elapsedTime
//                       weakSelf!.labName.text = transcriptBean.reg?.name!
//                       weakSelf!.labStaffIdNumber.text = transcriptBean.reg?.idNumber!
                   }
                   
               }else{
                   DispatchQueue.main.async {
                       AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                   }
               }
           }
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptDetailViewController viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptDetailViewController viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptDetailViewController viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptDetailViewController viewDidDisappear")
    }
    
}
extension PaperHistroyDetailViewController:WKNavigationDelegate{
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
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        LogUtil.sharedInstance.printLog(message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        LogUtil.sharedInstance.printLog(message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        // 判断是否是信任服务器证书
        if challenge.protectionSpace.authenticationMethod
            == NSURLAuthenticationMethodServerTrust {
            // 告诉服务器，客户端信任证书
            // 创建凭据对象
            let card = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            // 告诉服务器信任证书
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, card)
        }
    }
}
