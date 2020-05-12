//
//  UserAnswerBean.swift
//  tdces
//
//  Created by Str1ng on 2019/11/8.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class UserAnswerBean: BaseModel{
    required init() {}
    var correctAnswer : Any?
    var isCorrect:Any?
    var isGot:Bool=false
    var isSubjective:Bool=false
    var options : Any?
    var quesId:Int?
    var quesType:Int?
    var sn:Int?
    var userAnswer:Any?

}
class Option: BaseModel {
    var content : String?
    var judge:Bool?
    var code:String=""
        
        required init(){
    //        fatalError("init() has not been implemented")
        }

}
