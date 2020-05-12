//
//  CommonBiz.swift
//  tdces
//
//  Created by Str1ng on 2019/10/28.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import SwiftyJSON
import SwiftHTTP
class CommonBiz{
    static let sharedInstance=CommonBiz()
    private init(){
    }
    
    /// 区域列表
    /// - Parameter completion: <#completion description#>
    public func getLicensedFullArea(completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["areaType" : "2"]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getLicensedFullArea", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    //                        LogUtil.sharedInstance.printLog(message: responseBean.result)
                    
                    var areaList:[AreaBean]=[AreaBean].init()
                    let resultJson:[JSON] = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!).array!
                    for areaJson in resultJson{
                        let area:AreaBean = AreaBean.init(json: areaJson)
                        areaList.append(area)
                    }
                    
                    result.result=areaList
                }else{
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    public func getFullAreaList(completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["areaType" : "3"]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getFullAreaList", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    var areaList:[AreaBean]=[AreaBean].init()
                    let resultJson:[JSON] = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!).array!
                    for areaJson in resultJson{
                        let area:AreaBean = AreaBean.init(json: areaJson)
                        areaList.append(area)
                    }
//                                            LogUtil.sharedInstance.printLog(message: responseBean.result)
//                    [[String: [String]?]]
                    
                    result.result=areaList
                }else{
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    /// 继续教育原因列表
    /// - Parameter completion: <#completion description#>
    public func getDicListByType(completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["dicType" : "TRAIN_REASON"]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getDicListByType", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
//                    LogUtil.sharedInstance.printLog(message: responseBean.result)
                    var trainReasonList:[TrainReasonBean]=[TrainReasonBean].init()
                    let resultJson:[JSON] = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!).array!
                    for trainReasonJson in resultJson{
                        let trainReason:TrainReasonBean = TrainReasonBean.init(json: trainReasonJson)
                        trainReasonList.append(trainReason)
                    }
                    result.result=trainReasonList
                }else{
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    /// 培训类型列表
    /// - Parameter areaId: 区域ID
    /// - Parameter completion: <#completion description#>
    public func getDicListByType(areaId:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["areaId":areaId,"dicType" : "CERT_TYPE"]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getDicListByType", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
//                    LogUtil.sharedInstance.printLog(message: responseBean.result)
                    var trainCategoryList:[TrainCategoryBean]=[TrainCategoryBean].init()
                    let resultJson:[JSON] = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!).array!
                    for trainCategoryJson in resultJson{
                        let trainCategory:TrainCategoryBean = TrainCategoryBean.init(json: trainCategoryJson)
                        trainCategoryList.append(trainCategory)
                    }
                    
                    result.result=trainCategoryList
                }else{
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    /// 获取企业列表
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - completion: <#completion description#>
    public func findEnterprisePage(name:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
            
            let params =  ["name":name]
            SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "findEnterprisePage", param: params) { (responseBean) in
                do{
                    let result:ResponseBean = responseBean
                    if(responseBean.success!){
//                        LogUtil.sharedInstance.printLog(message: responseBean.result)
                        var organizationList:[OrganizationBean]=[OrganizationBean].init()
                        let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                        let organizationListJson:[JSON] = resultJson["list"].array!
                        for organizationJson in organizationListJson{
                            let organization:OrganizationBean = OrganizationBean.init(json: organizationJson)
                            organizationList.append(organization)
                        }
                        result.result=organizationList
                    }else{
                    }
                    completion(result)
                }
                catch{
                    
                }
            }
        }
    
    public func uploadBase64Img(imgStr:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        let params = ["imgStr": "data:image/jpg;base64,"+imgStr]
        SystemBiz.sharedInstance.uploadImage(url: UPLOAD_IMAGE_URL, param: params) { (responseBean) in
                let result:ResponseBean = responseBean
                completion(result)
        }
    }
}
