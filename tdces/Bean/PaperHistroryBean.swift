//
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class PaperHistroryBean: BaseBean {
    
//    var questionList:[QuestionBean]=[QuestionBean].init()
//    var passCondition:Int?
    var scoreSetList:[ScoreSetBean]=[ScoreSetBean].init()
//    var paperDuration:Int?
//    var org:OrganizationBean?
//    var area:AreaBean?
    
    var startTime:String?
    var score:Int?
    var result:Int?
    var reg:RegBean?
  
    var examContentList:[ExamContentBean]=[ExamContentBean].init()
    required init(json: JSON) {
        super.init(json: json)
        startTime = json["startTime"].string
        score = json["score"].int
        result = json["result"].int
        reg=RegBean.init(json: json["reg"])
        
//        paperName = json["paperName"].string
//        passCondition=json["passCondition"].int
//        let questionListJson = json["quesForm"].array
//        if(questionListJson != nil){
//            for questionJson in questionListJson!{
//                let question:QuestionBean = QuestionBean.init()
//                question.id = questionJson.int
//                questionList.append(question)
//            }
//        }
        let examListJson = json["examContent"].array
       // print("数组结果：\(String(describing: scoreSetListJson))")
        if(examListJson != nil){
            for scoreSetJson in examListJson!{
                let scoreSetBean:ExamContentBean = ExamContentBean.init(json: scoreSetJson)
                examContentList.append(scoreSetBean)

            }
        }
//        paperDuration = json["paperDuration"].int
//        org = OrganizationBean.init(json: json["org"])
//        area = AreaBean.init(json: json["area"])

    }
    
    required init(){
        super.init()
    }
}
