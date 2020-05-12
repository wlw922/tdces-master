//
//  StaffCertBean.swift
//  tdces
//
//  Created by Str1ng on 2019/11/1.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class StaffCertBean: BaseBean{
    var id:Int? //61,
    var state:Int? //0,
    var firstApplyTime:String? //"2019-08-01",
    var updateDate:String? //"2019-10-30 15:29:51",
    var createDate:String? //"2019-10-30 15:29:51",
    var certCategory:String? //"11",
    var expireDate:String? //"2025-07-31",
    var isDelete:Bool? //false,
    var remarks:String? //null,
    var certNo:String? //"360501199001017426",
    var staffId:Int? //61,
    var effectDate:String? //"2019-08-01"
    required init(json: JSON) {
        super.init(json: json)
        id = json["id"].int
        state = json["state"].int
        firstApplyTime = json["firstApplyTime"].string
        updateDate = json["updateDate"].string
        createDate = json["createDate"].string
        certCategory = json["certCategory"].string
        expireDate = json["expireDate"].string
        isDelete = json["isDelete"].bool
        remarks  = json["remarks"].string
        certNo  = json["certNo"].string
        staffId  = json["staffId"].int
        effectDate  = json["effectDate"].string
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}
