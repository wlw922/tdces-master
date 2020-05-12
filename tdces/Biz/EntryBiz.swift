//
//  EntryBiz.swift
//  tdces
//
//  Created by Str1ng on 2019/10/26.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import SwiftyJSON
class EntryBiz{
    static let sharedInstance=EntryBiz()
    private init(){
    }
    
    /// 获取有效的课程信息
    /// - Parameter loginId: <#loginId description#>
    /// - Parameter completion: <#completion description#>
    public func findValidList(loginId:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["loginId" : loginId]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "findValidList", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    //                    LogUtil.sharedInstance.printLog(message: responseBean.result)
                    var courseList:[CourseBean]=[CourseBean].init()
                    let resultJson:[JSON] = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!).array!
                    for courseJson in resultJson{
                        let course:CourseBean = CourseBean.init(json: courseJson)
                        courseList.append(course)
                    }
                    
                    result.result=courseList
                }else{
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    /// 提交网络报名
    /// - Parameter courseId: <#courseId description#>
    /// - Parameter loginId: <#loginId description#>
    /// - Parameter staffId: <#staffId description#>
    /// - Parameter payMethod: <#payMethod description#>
    /// - Parameter completion: <#completion description#>
    public func submitRegister(courseId:String,loginId:String,staffId:String,payMethod:String,paymentId:String,isDelete:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["loginId" : loginId,"courseId" : courseId,"staffId" : staffId,"payMethod" : payMethod,"paymentId":paymentId,"isDelete":isDelete]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "submitRegister", param: params) { (responseBean) in
            
            let result:ResponseBean = responseBean
            completion(result)
            
        }
    }
}
