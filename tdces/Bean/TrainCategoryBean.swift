//
//  TrainCategoryBean.swift
//  tdces
//
//  Created by Str1ng on 2019/11/6.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class TrainCategoryBean: BaseBean{
    var id : Int?
    var TrainCategoryString:String?
    var isCheck:Bool=false
    required init(json: JSON) {
        super.init(json: json)
        id = json["dicValue"].int
        TrainCategoryString = json["dicLabel"].string
    }
    
    required init(){
        super.init()
    }
    
}
