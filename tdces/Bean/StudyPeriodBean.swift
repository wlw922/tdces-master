//
//  StudyPeriodBean.swift
//  tdces
//
//  Created by Str1ng on 2019/11/14.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class StudyPeriodBean: BaseBean{
    var id : Int?
    var periodId:Int?
    
    required init(json: JSON) {
        super.init(json: json)
        id = json["id"].int
        periodId = json["periodId"].int
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}
