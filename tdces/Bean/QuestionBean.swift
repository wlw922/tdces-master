//
//  QuestionBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/25.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class QuestionBean: BaseBean{
    var id:Int?
    var questContent : String?
    var fileUrl :String?
    
    /// 0-单选 1-多选 2-判断 3-简答
    var quesType :Int?
    var answerList:[AnswerBean]?
    var options:[[KnowledgePointBean]]?
    var saqAnswer:String?
    required init(json: JSON) {
        super.init(json: json)
        id = json["id"].int
        questContent  = json["questContent"].string
        fileUrl  = json["fileUrl"].string
        quesType  = json["quesType"].int
        if(quesType == 3){
            options=[[KnowledgePointBean]].init()
            let optionsJson=json["options"].array
            for optionJson in optionsJson!{
                var option:[KnowledgePointBean]=[KnowledgePointBean].init()
                for stringJson in optionJson.array!{
                    let knowledgePointBean:KnowledgePointBean=KnowledgePointBean.init()
                    knowledgePointBean.knowledgePoint=stringJson.string!
                    option.append(knowledgePointBean)
                }
                options?.append(option)
            }
        }else{
            answerList = [AnswerBean].init()
            let answerListJson = json["options"].array
            for answerJson in answerListJson!{
                let answer:AnswerBean = AnswerBean.init(json: answerJson)
                answerList?.append(answer)
            }
        }
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}
