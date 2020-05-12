//
//  TranscriptBean.swift
//  tdces
//
//  Created by Str1ng on 2020/1/14.
//  Copyright © 2020 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class TranscriptBean: BaseBean{
    
    var id:Int?
    var score:Int?
    var reg:RegBean?
    var startTime:String?
    var endTime:String?
    var paper:PaperBean?
    /// 考试结果  0代表未通过，1代表通过
    var isPassed:Bool?
    /// 耗费时间，单位毫秒
    var all:Int?
    /// 答对的题目数
    var rightNumber:Int?
    /// 总题目数
    var quesNumber:Int?
    
    required init(json: JSON) {
        super.init(json: json)
        id = json["id"].int
        score=json["score"].int
        startTime=json["startTime"].string
        endTime=json["endTime"].string
        reg=RegBean.init(json: json["reg"])
        paper=PaperBean.init(json: json["paper"])
        if(json["result"].int==0){
            isPassed=false
        }else{
            isPassed=true
        }
        all=json["all"].int
        rightNumber=json["rightNumber"].int
        quesNumber=json["quesNumber"].int
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}
