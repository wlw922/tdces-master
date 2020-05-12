//
//  UserBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/26.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class UserBean: BaseBean{
    var id : Int?
    var loginId:String?
    var userName:String?
    var mobile:String?
    var state:Int?
    var area:AreaBean?
    var org:OrganizationBean?
    required init(json: JSON) {
        super.init(json: json)
        id = json["id"].int
        userName = json["userName"].string
        loginId  = json["loginId"].string
        state = json["state"].int
        mobile  = json["mobile"].string
        area = AreaBean.init(json: json["area"])
        org = OrganizationBean.init(json: json["org"])
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}
