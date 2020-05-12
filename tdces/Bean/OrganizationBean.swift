//
//  OrganizationBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/18.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class OrganizationBean : BaseBean{
    var id:Int?//35,
    var instDesc:String?//"机构的学习环境良好，非常的好，非常的好 非常的好 非常的好",
    var attachments:String?//null,
    var institutionPhoto:String?//"",
    var orgType:String?//null,
    var myRegion:String?//null,
    var name:String?//"南昌驾校01",
    var areaId:String?//360100,
    var shortName:String?//"驾校01",
    var state:String?//0,
    var address:String?//"南昌市的联系地址",
    var orgCode:String?//"培训机构",
    var currentUser:String?//null,
    var isDelete:String?//false,
    var telephone:String?//"18963585696",
    var sortOrderBy:String?//null,
    var area:String?//null,
    var updateDate:String?//"2019-10-14 10:28:09",
    var parent:String?//null,
    var children:String?//null,
    var pageSize:String?//0,
    var pageNum:String?//0,
    var number:String?//null,
    var createDate:String?//"2019-10-14 10:28:09",
    var remarks:String?//null
    
    required init(json: JSON) {
        super.init(json: json)
        id=json["id"].int
        name=json["name"].string
        address=json["address"].string
    }
    
    required init(){
        super.init()
    }
    
}
