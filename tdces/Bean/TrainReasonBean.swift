//
//  TrainReasonBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/28.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class TrainReasonBean: BaseBean{
    var id : Int?
    var dicLabel:String?
    var dicValue : Int?
    
    
    required init(json: JSON) {
        super.init(json: json)
         id = json["id"].int
         dicValue = json["dicValue"].int
         dicLabel = json["dicLabel"].string
    }
    
    required init(){
        super.init()
//        fatalError("init() has not been implemented")
    }
    
}
