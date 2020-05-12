//
//  UpdateUtil.swift
//  CarManagement
//
//  Created by Str1ng on 2018/11/20.
//  Copyright © 2018 gmcx. All rights reserved.
//

import Foundation
import SCLAlertView

protocol UpdateDelegate {
    func noUpdate()
}

class UpdateManager{
    
    static let sharedInstance = UpdateManager()
    var delegate:UpdateDelegate!
    
    private init(){
    }
    /// app版本更新检测
    ///
    /// - Parameter appId: apple ID - 开发者帐号对应app处获取
    func update(){
        
        //获取当前手机安装使用的版本号
        let localVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let localVersion_Float:Float = Float(localVersion)!
        let appId:String = "1487748708"
        //获取appstore上的最新版本号

        let appUrl = URL.init(string: "http://itunes.apple.com/lookup?id=" + appId)
        guard let appMsg = try? String.init(contentsOf: appUrl!, encoding: .utf8) else{
            return
        }
        let appMsgDict:NSDictionary = getDictFromString(jString: appMsg)
        let appResultsArray:NSArray = (appMsgDict["results"] as? NSArray)!
        if(appResultsArray.count > 0){
            let appResultsDict:NSDictionary = appResultsArray.lastObject as! NSDictionary
            if(appResultsDict.count > 0){
                var appStoreVersion:String = appResultsDict["version"] as! String
                if(appStoreVersion.first == "V"){
                    appStoreVersion.remove(at: appStoreVersion.firstIndex(of: "V")!)
                }
                let appStoreVersion_Float:Float = Float(appStoreVersion)!
                //appstore上的版本号大于本地版本号 - 说明有更新
                if appStoreVersion_Float > localVersion_Float {
                    let appearance = SCLAlertView.SCLAppearance.init(showCloseButton: false)
                    let alert = SCLAlertView(appearance:appearance)
                    let timeout = SCLAlertView.SCLTimeoutConfiguration.init(timeoutValue: 3) {
                        self.updateApp(appId:appId)
                    }
                    alert.showNotice("版本更新了！", subTitle: "",timeout:timeout).setDismissBlock {
                        exit(0)
                    }
                }else{
                    delegate.noUpdate()
                    LogUtil.sharedInstance.printLog(message: "已经是最新版本了哦")
                }
            }else{
                delegate.noUpdate()
            }
        }else{
            delegate.noUpdate()
        }
        
        
        
        

        
        
    }
    
    //去更新
    private func updateApp(appId:String) {
        let updateUrl:URL = URL.init(string: "http://itunes.apple.com/app/id" + appId)!
//        UIApplication.shared.openURL(updateUrl)
         UIApplication.shared.open(updateUrl, options: [:], completionHandler: nil)
    }
    
    //不再提示
    private func noAlertAgain() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "NOT_ALERT_AGAIN")
        userDefaults.synchronize()
    }
    
    //JSONString转字典
    private func getDictFromString(jString:String) -> NSDictionary {
        let jsonData:Data = jString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        
        return NSDictionary()
    }
    
    
}
