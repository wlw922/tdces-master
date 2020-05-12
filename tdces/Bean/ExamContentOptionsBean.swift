//
//  ExamContentOptionsBean.swift
//  tdces
//
//  Created by MAC on 2020/4/28.
//  Copyright © 2020 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class ExamContentOptionsBean: BaseBean {
    var judge: Bool?
    var code :String?
    var content :String?
    
   
   
    required init(json: JSON) {
        super.init(json: json)
        
        judge = json["judge"].bool
        code = json["code"].string
        content = json["content"].string
    }
    
    required init(){
        super.init()
    }
}
