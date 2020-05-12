//
//  AnswerBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/25.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
/// <#Description#>
class AnswerBean: BaseBean{
    var content : String?
    var judge:Bool?
    var isCheck:Bool=false
    required init(json: JSON) {
        super.init(json: json)
         content = json["content"].string
         judge  = json["judge"].bool
    }
    
    required init(){
        super.init()
//        fatalError("init() has not been implemented")
    }
    
}
