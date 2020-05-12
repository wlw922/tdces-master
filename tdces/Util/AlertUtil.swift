//
//  AlertUtil.swift
//  ElectricBike
//
//  Created by 刘湘 on 2018/3/28.
//  Copyright © 2018年 gmcx. All rights reserved.
//

import Foundation
import SCLAlertView
class AlertUtil {
    
    var alert:SCLAlertViewResponder?
    
    static let sharedInstance = AlertUtil()
    private init(){
        
    }
    
    func showWaitDialog(message:String){
        if(alert == nil){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false //不显示关闭按钮
        )
        alert = SCLAlertView.init(appearance: appearance).showWait("", subTitle: message)
        }else{
            return
        }
    }
    
    func closeWaitDialog(){
        if(alert != nil){
        alert?.close()
            alert = nil
        }else{
            return
        }
    }
    /// 成功消息框类型
    var SUCCESS_TYPE = 0x01
    /// 普通消息框类型
    var INFO_TYPE = 0x02
    /// 通知消息框类型
    var NOTICE_TYPE = 0x03
    /// 警告消息框类型
    var WARNING_TYPE = 0x04
    /// 错误消息框类型
    var ERROR_TYPE = 0x05
    /// 等待消息框类型
    var WAIT_TYPE = 0x06
    
    func showWarning(message:String,DismissBlock: @escaping ()->())  {
        //自定义提示框样式
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false //不显示关闭按钮
        )
        
        //使用自定义样式的提示框
        let alert = SCLAlertView(appearance: appearance)
        alert.showWarning("警告", subTitle: message).setDismissBlock {
            DismissBlock()
        }
    }
    
    func showSuccessDialog(message:String,DismissBlock:@escaping ()->()){
        //自定义提示框样式
               let appearance = SCLAlertView.SCLAppearance(
                   showCloseButton: true //不显示关闭按钮
               )
               
               //使用自定义样式的提示框
               let alert = SCLAlertView(appearance: appearance)
               
              
               //        alert.showInfo(title, subTitle: message, timeout: timeout)
               alert.showSuccess("", subTitle: message,closeButtonTitle: "确定").setDismissBlock {
                   DismissBlock()
               }
    }
    
    func showErrorDialog(message:String,DismissBlock:@escaping ()->()){
        //自定义提示框样式
               let appearance = SCLAlertView.SCLAppearance(
                   showCloseButton: true //不显示关闭按钮
               )
               
               //使用自定义样式的提示框
               let alert = SCLAlertView(appearance: appearance)
               
              
               //        alert.showInfo(title, subTitle: message, timeout: timeout)
               alert.showError("", subTitle: message,closeButtonTitle: "确定").setDismissBlock {
                   DismissBlock()
               }
    }
    func showAutoDismissSuccessDialog(title:String,message:String,timeout:Double,DismissBlock: @escaping ()->())  {
        //自定义提示框样式
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false //不显示关闭按钮
        )
        
        //使用自定义样式的提示框
        let alert = SCLAlertView(appearance: appearance)
        
        //显示提示框
        let timeout = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeout) {
            
        }
        //        alert.showInfo(title, subTitle: message, timeout: timeout)
        alert.showSuccess(title, subTitle: message, timeout: timeout).setDismissBlock {
            DismissBlock()
        }
    }
    
    func showAutoDismissDialog(title:String,message:String,timeout:Double)  {
        //自定义提示框样式
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false //不显示关闭按钮
        )
        
        //使用自定义样式的提示框
        let alert = SCLAlertView(appearance: appearance)
        
        //显示提示框
        let timeout = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeout) {
            
        }
//        alert.showInfo(title, subTitle: message, timeout: timeout)
        alert.showWarning(title, subTitle: message, timeout: timeout)
    }
    func showAutoDismissDialog(title:String,message:String,timeout:Double,DismissBlock: @escaping ()->())  {
        //自定义提示框样式
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false //不显示关闭按钮
        )
        
        //使用自定义样式的提示框
        let alert = SCLAlertView(appearance: appearance)
        
        //显示提示框
        let timeout = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeout) {
            
        }
        //        alert.showInfo(title, subTitle: message, timeout: timeout)
        alert.showWarning(title, subTitle: message, timeout: timeout).setDismissBlock {
            DismissBlock()
        }
    }
    
    
    private func showAutoDismissDialog(alertType:Int,title:String,message:String,timeout:Double)  {
        //自定义提示框样式
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false //不显示关闭按钮
        )
        
        //使用自定义样式的提示框
        let alert = SCLAlertView(appearance: appearance)
        
        //显示提示框
        let timeout = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeout) {
            
        }
        //        alert.showInfo(title, subTitle: message, timeout: timeout)
        switch alertType {
        case SUCCESS_TYPE:
            alert.showSuccess(title, subTitle: message, timeout: timeout)
        case WARNING_TYPE:
            alert.showWarning(title, subTitle: message, timeout: timeout)
            break
        case ERROR_TYPE:
            alert.showError(title, subTitle: message,timeout: timeout)
        default:
            break
        }
        
        
    }
    
    func showWarningAutoDismissDialog(message:String){
        self.showAutoDismissDialog(alertType:self.WARNING_TYPE, title: "温馨提示", message: message, timeout: 2)
    }
    
    func showWarningAutoDismissDialog(message:String,DismissBlock: @escaping ()->()){
        self.showAutoDismissDialog(title: "温馨提示", message: message, timeout: 2) {
            DismissBlock()
        }
//        self.showAutoDismissDialog(alertType:self.WARNING_TYPE, title: "温馨提示", message: message, timeout: 2)
        
    }
    
    func showErrorAutoDismissDialog(message:String){
        self.showAutoDismissDialog(alertType:self.ERROR_TYPE, title: "温馨提示", message: message, timeout: 2)
    }
}
