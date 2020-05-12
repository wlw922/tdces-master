//
//  PlanBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON

/// 
class PlanBean : BaseBean{
    var isDelete:Bool?//false,
    var paper:PaperBean? //null,
    var videoCount:String? //null,
    var id:Int? //63,
    var expireDate:String? //"2019-11-09",
    var area:AreaBean?
    var org:OrganizationBean?
    var createDate:String? //"2019-10-19 17:44:27",
    var outline:String? //null,
    var state:Int? //0,
    var effectDate:String? //"2019-10-07",
    var applyReason:String? //1,
    var planName:String? //"视频+文档+考试03",
    /// 1.视频开始播放时识别 2.视频播放第x分钟识别 3.视频播放开始和播放第x分钟识别 ，为空时不需要验证
    var hourVerifyMode:String?
    /// 1识别 2不识别
    var isExamAuth:Int?
    var currentUser:String? //null,
    var onlineHour:String? //25,
    var remarks:String? //null,
    var pageNum:String? //0,
    var updateDate:String? //"2019-10-19 17:44:27",
    var applyCategory:String? //"12,13,15",
    /// 验证间隔
    var verifyPeriod:Double?
    var teachingMethod:String? //"3",
    var teacherIds:String? //null,
    var pageSize:String? //0,
    var sceneHour:String? //45,
    var videoTime:String? //null,
    var details:String? //[],
    var sortOrderBy:String? //null
    
    required init(json: JSON) {
        super.init(json: json)
        isDelete=json["isDelete"].bool //false,
        paper=PaperBean.init(json: json["paper"]) //null,
        videoCount=json["videoCount"].string //null,
        id=json["id"].int //63,
        expireDate=json["expireDate"].string //"2019-11-09",
        hourVerifyMode=json["hourVerifyMode"].string //"1",
        verifyPeriod=json["verifyPeriod"].double //2,
        //area=json[""].string //{
        //org=json[""].string //{
        isExamAuth=json["isExamAuth"].int
        createDate=json["createDate"].string //"2019-10-19 17:44:27",
        outline=json["outline"].string //null,
        state=json["state"].int //0,
        effectDate=json["effectDate"].string //"2019-10-07",
        applyReason=json["applyReason"].string //1,
        planName=json["planName"].string //"视频+文档+考试03",
        currentUser=json["currentUser"].string //null,
        onlineHour=json["onlineHour"].string //25,
        remarks=json["remarks"].string //null,
        pageNum=json["pageNum"].string //0,
        updateDate=json["updateDate"].string //"2019-10-19 17:44:27",
        applyCategory=json["applyCategory"].string //"12,13,15",
        teachingMethod=json["teachingMethod"].string //"3",
        teacherIds=json["teacherIds"].string //null,
        pageSize=json["pageSize"].string //0,
        sceneHour=json["sceneHour"].string //45,
        videoTime=json["videoTime"].string //null,
        details=json["details"].string //[],
        sortOrderBy=json["sortOrderBy"].string //null
    }
    
    required init(){
        super.init()
    }
    
}
