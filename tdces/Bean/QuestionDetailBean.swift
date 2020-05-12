//
//  QuestionDetailBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/29.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class QuestionDetailBean{
    var id:Int=0
    /// 1:question 2:questionImage 3:Answer
    var type:Int=0
    var question:String?
    var questionImageUrl:String?
    /// 0-单选 1-多选 2-判断 3-简答
    var quesType :Int?
    var answer:AnswerBean?
    var options:[[KnowledgePointBean]]?
    var shortAnswer:String?
}
