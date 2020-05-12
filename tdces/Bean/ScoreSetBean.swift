//
//  ScoreSetBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/31.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class ScoreSetBean: BaseBean{
    //abc
    //var grade : Int?
   var grade : Float?
    var number:Int?
    var type:Int?
    
    
    required init(json: JSON) {
        super.init(json: json)
         //abc
        //grade = json["grade"].int
         grade = json["grade"].float
         number = json["number"].int
         type = json["type"].int
    }
    
    required init(){
        super.init()
//        fatalError("init() has not been implemented")
    }
    
}
