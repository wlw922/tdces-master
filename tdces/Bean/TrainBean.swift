//
//  TrainBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/18.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class TrainBean : BaseBean{
    var id : Int?
    var type : Int?
    var regDate : String?
    var trainName :String?
    var courseDuration :Int?
    var durations:String?
    var attachments:[AttachmentBean]?
    var regReason:String?
    var org:OrganizationBean?
    var area:AreaBean?
    var plan:PlanBean?
    /// 有效期开始时间
    var effectDate:String?
    /// 有效期限
    var expireDate:String?
    /// 周
    var period:Int?
    /// 培训方式
    var teachingMethodStr:String?
    /// 培训类型
    var trainCategoryStr:String?
    var liveline:String?
    var deadline:String?
    
    required init(json: JSON) {
        super.init(json: json)
        id = json["id"].int
        type = json["type"].int
        regDate  = json["regDate"].string
        trainName  = json["trainName"].string
        courseDuration  = json["courseDuration"].int
        durations  = json["durations"].string
        regReason  = json["regReason"].string
        period  = json["period"].int
        effectDate = json["effectDate"].string
        expireDate = json["expireDate"].string
        org = OrganizationBean.init(json: json["org"])
        area = AreaBean.init(json: json["area"])
        teachingMethodStr = json["teachingMethodStr"].string
        trainCategoryStr = json["trainCategoryStr"].string
        liveline = json["liveline"].string
        deadline = json["deadline"].string
        plan = PlanBean.init(json: json["plan"])
        
        attachments=[AttachmentBean].init()
        
        let attachmentsJson = json["attachments"].array
        for attachmentJson in attachmentsJson!{
            let attachmentBean = AttachmentBean.init(json: attachmentJson)
            attachments?.append(attachmentBean)
        }
    }
    
    required init(){
        super.init()
    }
    
}
