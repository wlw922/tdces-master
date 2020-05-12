//
//  CourseBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/26.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class CourseBean: BaseBean{
    var id : Int?
    var price:Double?
    var courseName:String?
    var str:String?
    var regReason:String?
    var regReasonString:String?
    var coursePhoto:String?
    var courseDesc:String?
    var courseDuration:Int?
    var area:AreaBean?
    var organization:OrganizationBean?
    required init(json: JSON) {
        super.init(json: json)
        id = json["id"].int
        price = json["price"].double
        courseName = json["courseName"].string
        str  = json["str"].string
        regReason  = json["regReason"].string
        coursePhoto  = json["coursePhoto"].string
        courseDesc = json["courseDesc"].string
        courseDuration = json["courseDuration"].int
        area = AreaBean.init(json: json["area"])
        organization = OrganizationBean.init(json: json["org"])
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}
