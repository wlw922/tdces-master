//
//  regBean.swift
//  tdces
//
//  Created by MAC on 2020/4/28.
//  Copyright © 2020 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class RegBean: BaseBean{
    var id:Int?
    var name : String?
    var idNumber :String?
    
    required init(json: JSON) {
        super.init(json: json)
        id = json["id"].int
        idNumber  = json["idNumber"].string
        name  = json["name"].string
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}
