//
//  SystemBiz.swift
//  YiAnXing
//
//  Created by Str1ng on 5/9/19.
//  Copyright © 2019 com.gmcx. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import SwiftyJSON
import SwiftHTTP

enum HTTPRequestError:Error{
    case OK
    case GatewayTimeout
}
class SystemBiz {
    
    static let sharedInstance = SystemBiz()
    private init(){
    }
    
    func returnUnifiedorder(url:String,param:[String:String],completion: @escaping (_ responseBean : ResponseBean) -> ()){
        HTTP.POST(url, parameters: param) { (response) in
            do{
                           let responseBean:ResponseBean = ResponseBean()
                           switch (response.statusCode){
                           case 200:
                               let json:JSON = try JSON.init(data: response.data)
                               responseBean.state = json["state"].string!
                               responseBean.success = json["success"].bool!
                               responseBean.message = json["message"].string
                               responseBean.result = json["result"].description
                               completion(responseBean)
                               
                               break
                           case 408: //超时
                               responseBean.success = false
                               responseBean.message = "服务器开了会小差，请稍后再试！"
                               DispatchQueue.main.sync {
                                   AlertUtil.sharedInstance.closeWaitDialog()
                                   AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务器开了会小差，请稍后再试！")
                                   completion(responseBean)
                               }
                               break
                           case 500://服务器无法处理请求
                               responseBean.success = false
                               responseBean.message = "服务器无法处理请求！"
                               DispatchQueue.main.sync {
                                   AlertUtil.sharedInstance.closeWaitDialog()
                                   AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务器无法处理请求！")
                                   completion(responseBean)
                               }
                               break
                           case 503://服务不可用
                           responseBean.success = false
                               responseBean.message = "服务不可用！"
                               DispatchQueue.main.sync {
                                   AlertUtil.sharedInstance.closeWaitDialog()
                                   AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务不可用！")
                                   completion(responseBean)
                               }
                               break
                           default:
                           responseBean.success = false
                               responseBean.message = "未知错误，请联系技术人员！"
                               DispatchQueue.main.sync {
                                   AlertUtil.sharedInstance.closeWaitDialog()
                                   AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务不可用！")
                                   completion(responseBean)
                               }
                               break
                           }
                           
                       }
                       catch {
                           
                       }
        }
    }
    
    /// 上传照片
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - param: <#param description#>
    ///   - completion: <#completion description#>
    func uploadImage(url:String,param:[String:String],completion: @escaping (_ responseBean : ResponseBean) -> ()){
        HTTP.POST(url, parameters: param) { (response) in
            do{
                           let responseBean:ResponseBean = ResponseBean()
                           switch (response.statusCode){
                           case 200:
                               let json:JSON = try JSON.init(data: response.data)
                               responseBean.state = json["state"].string!
                               responseBean.success = json["success"].bool!
                               responseBean.message = json["message"].string
                               responseBean.result = json["result"].description
                               completion(responseBean)
                               
                               break
                           case 408: //超时
                               responseBean.success = false
                               responseBean.message = "服务器开了会小差，请稍后再试！"
                               DispatchQueue.main.sync {
                                   AlertUtil.sharedInstance.closeWaitDialog()
                                   AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务器开了会小差，请稍后再试！")
                                   completion(responseBean)
                               }
                               break
                           case 500://服务器无法处理请求
                               responseBean.success = false
                               responseBean.message = "服务器无法处理请求！"
                               DispatchQueue.main.sync {
                                   AlertUtil.sharedInstance.closeWaitDialog()
                                   AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务器无法处理请求！")
                                   completion(responseBean)
                               }
                               break
                           case 503://服务不可用
                           responseBean.success = false
                               responseBean.message = "服务不可用！"
                               DispatchQueue.main.sync {
                                   AlertUtil.sharedInstance.closeWaitDialog()
                                   AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务不可用！")
                                   completion(responseBean)
                               }
                               break
                           default:
                           responseBean.success = false
                               responseBean.message = "未知错误，请联系技术人员！"
                               DispatchQueue.main.sync {
                                   AlertUtil.sharedInstance.closeWaitDialog()
                                   AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务不可用！")
                                   completion(responseBean)
                               }
                               break
                           }
                           
                       }
                       catch {
                           
                       }
        }
    }
    
    func sendPost(url:String ,methodName:String,param:[String:String],completion: @escaping (_ responseBean : ResponseBean) -> ()){
        
        NetManager.sharedInstance.sendPost(url:url,methodName: methodName, param: param) { (response) in
            do{
                let responseBean:ResponseBean = ResponseBean()
     
                switch (response.statusCode){
                case 200:
                    let json:JSON = try JSON.init(data: response.data)
                    responseBean.state = json["state"].string!
                    responseBean.success = json["success"].bool!
                    responseBean.message = json["message"].string
                    responseBean.result = json["result"].description
                    completion(responseBean)
                    
                    break
                case 408: //超时
                    responseBean.success = false
                    responseBean.message = "服务器开了会小差，请稍后再试！"
                    DispatchQueue.main.sync {
                        AlertUtil.sharedInstance.closeWaitDialog()
                        AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务器开了会小差，请稍后再试！")
                        completion(responseBean)
                    }
                    break
                case 500://服务器无法处理请求
                    responseBean.success = false
                    responseBean.message = "服务器无法处理请求！"
                    DispatchQueue.main.sync {
                        AlertUtil.sharedInstance.closeWaitDialog()
                        AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务器无法处理请求！")
                        completion(responseBean)
                    }
                    break
                case 503://服务不可用
                responseBean.success = false
                    responseBean.message = "服务不可用！"
                    DispatchQueue.main.sync {
                        AlertUtil.sharedInstance.closeWaitDialog()
                        AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务不可用！")
                        completion(responseBean)
                    }
                    break
                default:
                responseBean.success = false
                    responseBean.message = "未知错误，请联系技术人员！"
                    DispatchQueue.main.sync {
                        AlertUtil.sharedInstance.closeWaitDialog()
                        AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: "服务不可用！")
                        completion(responseBean)
                    }
                    break
                }
                
            }
            catch {
                
            }
        }
        
    }
}
