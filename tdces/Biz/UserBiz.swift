//
//  UserBiz.swift
//  CarManagement
//
//  Created by Str1ng on 2019/8/27.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import SwiftyJSON
class UserBiz{
    static let sharedInstance=UserBiz()
    private init(){
    }
    
    /// 登录接口
    ///
    /// - Parameters:
    ///   - UserName: 用户名
    ///   - Password: 密码
    ///   - completion:
    public func toLogin(username:String,password:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["username" : username,"password":password]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "login", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    //                    LogUtil.sharedInstance.printLog(message: responseBean.result)
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                    let userBean:UserBean = UserBean.init(json: resultJson)
                    staff = StaffBean.init()
                    staff?.user = userBean
                    UserDefaults.LoginInfo.set(value: username, forKey: .userName)
                    UserDefaults.LoginInfo.set(value: password, forKey: .password)
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    /// 注册
    /// - Parameter name: 姓名
    /// - Parameter password: 密码
    /// - Parameter repeatPassword: 确认密码
    /// - Parameter sex: 性别（1：女，0：男）
    /// - Parameter mobile: 手机号
    /// - Parameter idNumber: 身份证
    /// - Parameter idcardPath: 身份证照片
    /// - Parameter photoPath: 免冠照片
    /// - Parameter firstApplyTime: 初次申领时间
    /// - Parameter expireDate: 有效期限
    /// - Parameter effectDate: 有效期开始时间
    /// - Parameter certPath: 从业资格证照片
    /// - Parameter certNo: 从业资格证编号
    /// - Parameter birthday: 出生年月
    /// - Parameter areaId: 从业区域ID
    /// - Parameter addressRegion: 地址 区ID
    /// - Parameter address: 详细地址
    /// - Parameter addressRegionList: 地址省市区ID
    /// - Parameter certCategory: 从业资格类型
    /// - Parameter completion: <#completion description#>
    public func register(name:String,password:String,repeatPassword:String,sex:String,mobile:String,idNumber:String,idcardPath:String,photoPath:String,firstApplyTime:String,expireDate:String,effectDate:String,certPath:String?,certNo:String,birthday:String,areaId:String,addressRegion:String,address:String,addressRegionList:[String],orgId:String,certCategoryList:[TrainCategoryBean]?,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        var params =  ["name" : name,"password":password,"repeatPassword":repeatPassword,"sex":sex,"mobile":mobile,"idNumber":idNumber,"idcardPath":idcardPath,"photoPath":photoPath,"firstApplyTime":firstApplyTime,"expireDate":expireDate,"effectDate":effectDate,"certNo":certNo,"birthday":birthday,"area.id":areaId,"addressRegion":addressRegion,"address":address,"staffCert.certNo":certNo,"sysOrg.id":orgId,"staffCert.effectDate":effectDate,"staffCert.expireDate":expireDate,"staffCert.firstApplyTime":firstApplyTime]
        if(certPath != nil){
            params["certPath"]=certPath
        }
        var staffCert:String=""
        var certCategory:[Int]=[Int].init()
        if(certCategoryList != nil){
            if(certCategoryList!.count > 0){
                for trainCategory in certCategoryList!{
                    staffCert.append(String((trainCategory.id)!))
                    staffCert.append(",")
                    certCategory.append((trainCategory.id)!)
                }
                staffCert = staffCert.substring(from: 0, to: staffCert.count-2)
                params["staffCert.certCategory"]=staffCert
            }
        }
        if(addressRegionList.count > 0){
            for i in 0..<addressRegionList.count{
                params["addressRegionList[\(i)]"]=addressRegionList[i]
//                params = ["addressRegionList[\(i)]":addressRegionList[i]]
            }
        }
        if(certCategory.count > 0){
            for i in 0..<certCategory.count{
                params["certCategory[\(i)]"]=String(certCategory[i])
//                params = ["certCategory[\(i)]":String(certCategory[i])]
            }
        }
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "register", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    //                    LogUtil.sharedInstance.printLog(message: responseBean.result)
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                    staff = StaffBean.init(json: resultJson)
                    UserDefaults.LoginInfo.set(value: idNumber, forKey: .userName)
                    UserDefaults.LoginInfo.set(value: password, forKey: .password)
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    /// 获取用户信息
    /// - Parameters:
    ///   - loginId: 登录ID
    ///   - completion: <#completion description#>
    public func getStaffInfo(loginId:String ,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["loginId" : loginId ]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getStaffInfo", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    //                    LogUtil.sharedInstance.printLog(message: responseBean.result)
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                    staff=StaffBean.init(json: resultJson)
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    /// 提交人脸识别记录
    /// - Parameter loginId: 登录ID
    /// - Parameter regId: 报名ID
    /// - Parameter orgId: 机构ID
    /// - Parameter areaId: 区域ID
    /// - Parameter relatedId: 关联ID（如果是学时类型，关联学时表   如果是上课签到，关联上课签到表）
    /// - Parameter reconType: 0-视频学时识别 1-上课签到识别 2-考试
    /// - Parameter fileUrl: 人脸识别拍照
    /// - Parameter photo: 报名免冠照片
    /// - Parameter completion: <#completion description#>
    public func videoFaceVerification(loginId:String ,regId:String,orgId:String,areaId:String,relatedId:String,reconType:String,fileUrl:String,photo:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["loginId" : loginId,"regId" : regId ,"orgId" : orgId,"areaId" : areaId,"relatedId" : relatedId,"reconType" : reconType,"fileUrl" : fileUrl,"photo" : photo]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "videoFaceVerification", param: params) { (responseBean) in

                let result:ResponseBean = responseBean
                completion(result)
        }
    }
    
    /// 修改密码
    /// - Parameters:
    ///   - id: 用户ID
    ///   - newPassword: <#newPassword description#>
    ///   - loginId: <#loginId description#>
    ///   - oldPassword: <#oldPassword description#>
    ///   - completion: <#completion description#>
    public func changePassword(id:String ,newPassword:String ,loginId:String ,oldPassword:String ,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  [ "id" : id,"newPassword" : newPassword,"loginId" : loginId,"oldPassword" : oldPassword ]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "changePassword", param: params) { (responseBean) in
//            do{
                let result:ResponseBean = responseBean
//                if(responseBean.success!){
//                    //                    LogUtil.sharedInstance.printLog(message: responseBean.result)
//                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
//                    staff=StaffBean.init(json: resultJson)
//                }
                completion(result)
//            }
//            catch{
//
//            }
        }
    }
}
