//
//  examContentBean.swift
//  tdces
//
//  Created by MAC on 2020/4/28.
//  Copyright © 2020 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class ExamContentBean: BaseBean {
    
    var sn:Int?//题号
    
    var quesType:Int?//问题类型（单选/多选/判断/简答）
    var fileUrl:String?//问题图
   //
    var question:String?
    var userAnswer:Any?//单选多选判断的正确答案
    var shortOptions:Any?//简答题的options
    var shortuserAnswer:String?//简答题的用户答案
    var examContentOptionsList:[ExamContentOptionsBean]=[ExamContentOptionsBean].init()
    required init(json: JSON) {
        super.init(json: json)
        sn = json["sn"].int
        quesType = json["quesType"].int //0单选 1多选 2判断 3简答
        if (json["fileUrl"].string != nil)
        {
             fileUrl = json["fileUrl"].string
        }
        else
        {
            fileUrl = ""
        }
       
        if (quesType == 3)
        {
            let userAnswerStr = json["userAnswer"].string
            let optionsArr = json["options"].array
            if (userAnswerStr != nil)
            {
                shortuserAnswer = json["userAnswer"].string
            }
            else
            {
                shortuserAnswer = " "
            }
            
            
            if (optionsArr != nil)
            {
                shortOptions = json["options"].array
            }
            else
            {
                shortOptions = " "
            }
            
            
        }
        else
        {
            userAnswer = json["userAnswer"].array
            let optionsListJson = json["options"].array
            if(optionsListJson != nil){
                for oneJson in optionsListJson!{
                    let optionsList:ExamContentOptionsBean = ExamContentOptionsBean.init(json: oneJson)
                    examContentOptionsList.append(optionsList)

                }
            }
        }
        
        question = json["question"].string
        
        
    }
    
    required init(){
        super.init()
    }
}
