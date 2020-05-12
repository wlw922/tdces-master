//
//  PaperBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class PaperBean: BaseBean {
    var paperName:String?
    var id:Int?
    var questionList:[QuestionBean]=[QuestionBean].init()
    var passCondition:Int?
    var scoreSetList:[ScoreSetBean]=[ScoreSetBean].init()
    var paperDuration:Int?
    var org:OrganizationBean?
    var area:AreaBean?
    required init(json: JSON) {
        super.init(json: json)
        id=json["id"].int
        paperName = json["paperName"].string
        passCondition=json["passCondition"].int
        let questionListJson = json["quesForm"].array
        if(questionListJson != nil){
            for questionJson in questionListJson!{
                let question:QuestionBean = QuestionBean.init()
                question.id = questionJson.int
                questionList.append(question)
            }
        }
        let scoreSetListJson = json["scoreSet"].array
       // print("数组结果：\(String(describing: scoreSetListJson))")
        if(scoreSetListJson != nil){
            for scoreSetJson in scoreSetListJson!{
                let scoreSetBean:ScoreSetBean = ScoreSetBean.init(json: scoreSetJson)
                scoreSetList.append(scoreSetBean)
                
               
            }
        }
        paperDuration = json["paperDuration"].int
        org = OrganizationBean.init(json: json["org"])
        area = AreaBean.init(json: json["area"])
//        materialList=[MaterialBean].init()
//        let materialBean = MaterialBean.init(json: json["material"])
//        materialList?.append(materialBean)
    }
    
    required init(){
        super.init()
    }
}
