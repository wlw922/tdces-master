//
//  ScoreReportingViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/30.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class ScoreReportingViewController: UIViewController {
    @IBOutlet weak var  labScore:UILabel!//labScore成绩
    @IBOutlet weak var  labTopicCount:UILabel!//labTopicCount总题数
    @IBOutlet weak var labCorrectCount:UILabel!//labCorrectCount对题数
    @IBOutlet weak var labFaultCount:UILabel!//labFaultCount错题数
   
  //  var dansuangrade : Float = 2.5
  //  var danxuancount : Int=5
  //  var duoxuancount : Int=0
  //  var panduancount : Int=0
   
    //var Score:Int=0
    var Score:Float=0.0
    var TopicCount:Int=0
    var CorrectCount:Int=0 //正确计数
    var FaultCount:Int=0 //错误计数
    var train:TrainBean?
    var paper:PaperBean?
    var questionSn:Int=0
    var startTime:String=""
    var endTime:String=""
    var examId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TopicCount=(paper?.questionList.count)!
        
      //labTopicCount总题数
        labTopicCount.text = String(describing: TopicCount)
        print("总题数  \(TopicCount)")
        var examList:[JSON]=[JSON].init()
        for question in self.paper!.questionList{
       
            questionSn += 1
            let userAnswer:UserAnswerBean = UserAnswerBean.init()
            var options:[Option] = [Option].init()
            userAnswer.quesId = question.id
            userAnswer.quesType = question.quesType
            userAnswer.sn = questionSn
            
            //correctAnswers正确答案
            var correctAnswers:[String]=[String].init()
            //userAnswers学生答案
            var userAnswers:[String]=[String].init()
            
            if(question.quesType == 0){//单选题
                var optionCode:Int=0
                for answerOption in question.answerList!{
                    let option:Option = Option.init()
                    option.content = answerOption.content
                    option.judge = answerOption.judge
                    option.code = String(optionCode)
                    print(" \(option.code)")
                    options.append(option)
                    if(answerOption.judge!){
                        correctAnswers.append(String(optionCode))
                    }
                    if(answerOption.isCheck){
                        userAnswers.append(String(optionCode))
                    }
                    optionCode += 1
                }
                userAnswer.correctAnswer = correctAnswers
                userAnswer.userAnswer = userAnswers
                userAnswer.options = options
                let answer = question.answerList?.first(where: { (answer) -> Bool in
                    
                    
                    if(answer.isCheck){
                        userAnswer.isGot = true
                        if(answer.isCheck == answer.judge!){
                            return true
                        }else{
                            return false
                        }
                    }else{
                        return false
                    }
                })
                if(answer != nil){
                    userAnswer.isCorrect = true//用户答案正确
                    
                    //abc
                    let grade:Float =  (self.paper?.scoreSetList.first(where: { (scoreSetBean) -> Bool in
                        if(scoreSetBean.type == question.quesType){
                            return true
                        }else{
                            return false
                        }
                    })!.grade)!
                    //abc
                    
                    Score += grade
        
                    CorrectCount+=1
                }else{
                    
                    userAnswer.isCorrect = false
                    FaultCount+=1
                }
               
            }
            else if(question.quesType == 1){//多选题
                var optionCode:Int=0
                for answerOption in question.answerList!{
                    let option:Option = Option.init()
                    option.content = answerOption.content
                    option.judge = answerOption.judge
                    option.code = String(optionCode)
                    options.append(option)
                    if(answerOption.judge!){
                        correctAnswers.append(String(optionCode))
                    }
                    if(answerOption.isCheck){
                        userAnswers.append(String(optionCode))
                    }
                    optionCode += 1
                }
                userAnswer.correctAnswer = correctAnswers
                userAnswer.userAnswer = userAnswers
                userAnswer.options = options
                
                let answer = question.answerList?.first(where: { (answer) -> Bool in
                    if(answer.isCheck){
                        userAnswer.isGot = true
                        if(answer.judge == false){
                            return true
                        }else{
                            return false
                        }
                    }else{
                        if(answer.judge == true){
                            return true
                        }else{
                            return false
                        }
                    }
                })
                if(answer != nil){
                     userAnswer.isCorrect = false
                    FaultCount+=1
                }else{
                    //abc
                    let grade:Float =  (self.paper?.scoreSetList.first(where: { (scoreSetBean) -> Bool in
                        if(scoreSetBean.type == question.quesType){
                            return true
                        }else{
                            return false
                        }
                    })!.grade)!
                    //abc
                    Score += grade
                   
                    print("多选题中Score = \(Score)")
                    userAnswer.isCorrect = true
                    
         
                    CorrectCount+=1
                }
            }else if(question.quesType == 2){//判断题
                var optionCode:Int=0
                for answerOption in question.answerList!{
                    let option:Option = Option.init()
                    option.content = answerOption.content
                    option.judge = answerOption.judge
                    option.code = String(optionCode)
                    options.append(option)
                    if(answerOption.judge!){
                        correctAnswers.append(String(optionCode))
                    }
                    if(answerOption.isCheck){
                        userAnswers.append(String(optionCode))
                    }
                    optionCode += 1
                }
                userAnswer.correctAnswer = correctAnswers
                userAnswer.userAnswer = userAnswers
                userAnswer.options = options
                let answer = question.answerList?.first(where: { (answer) -> Bool in
                    if(answer.isCheck == true){
                        userAnswer.isGot = true
                        if(answer.isCheck == answer.judge!){
                            return true
                        }else{
                            return false
                        }
                    }else{
                        return false
                    }
                })
                if(answer != nil){
                    //abc
                    let grade:Float =  (self.paper?.scoreSetList.first(where: { (scoreSetBean) -> Bool in
                        if(scoreSetBean.type == question.quesType){
                            return true
                        }else{
                            return false
                        }
                    })!.grade)!
                    //abc
                    Score += grade
                    CorrectCount+=1
                    userAnswer.isCorrect = true
                    
                }else{
                    userAnswer.isCorrect = false
                    FaultCount+=1
                }
            }else if(question.quesType == 3){//简答题
                
                userAnswer.isSubjective = true
                var knowledgePointList:[[String]]?=[[String]].init()
                
                userAnswer.options = options
                if(question.saqAnswer != nil){
                    userAnswer.isGot = true
                    var shortAnswerQuestionScore:Double=0
                    //abc
                    let grade:Float =  (self.paper?.scoreSetList.first(where: { (scoreSetBean) -> Bool in
                        if(scoreSetBean.type == question.quesType){
                            return true
                        }else{
                            return false
                        }
                    })!.grade)!
                    
                    let userAnswerString:String = question.saqAnswer!
                    let KnowledgePointGrade:Double = Double(grade/Float((question.options?.count)!))
                    var knowledgePointScore:[Double] = [Double].init()
                    for knowledgePoints in question.options!{
                        var littleKnowledgePointList:[String]=[String].init()
                        let kpg:Double = KnowledgePointGrade/Double(knowledgePoints.count)
                        var kps:Double = 0
                        for kp in knowledgePoints{
                            let kpString:String = kp.knowledgePoint!
                            littleKnowledgePointList.append(kpString)
                            if(userAnswerString.contains(kpString)){
                                shortAnswerQuestionScore += kpg
                                kps += kpg
                            }
                        }
                        knowledgePointList?.append(littleKnowledgePointList)
                        knowledgePointScore.append(kps)
                    }
                    userAnswer.options = knowledgePointList
                    userAnswer.userAnswer = userAnswerString
                    userAnswer.isCorrect = knowledgePointScore
                    if(shortAnswerQuestionScore > 1){
                        CorrectCount+=1
                    }else{
                        FaultCount+=1
                    }
                    Score += Float(shortAnswerQuestionScore)
                    print("简答题中Score = \(Score)")
                }else{
                    userAnswer.isGot = false
                    FaultCount+=1
                }

            }
            examList.append(JSON.init(parseJSON: JsonUtil.modelToJson(userAnswer)))
            
            
        }
        
//        LogUtil.sharedInstance.printLog(message: examList)
        labCorrectCount.text = String(describing: CorrectCount)
        labFaultCount.text = String(describing: FaultCount)

        //abc
        labScore.text = String(describing: Score)
       // labScore.text = "100"
        var isPass:String="0"
        
        if(Score>Float(paper!.passCondition!)){
            isPass = "1"
        }
        let areaId:String=String( (self.paper?.area?.id)!)
        let regId:String=String((self.train?.id)!)
        let paperId:String=String((self.paper?.id)!)
        let orgId:String=String( (paper?.org?.id)!)
        let password:String=UserDefaults.LoginInfo.string(forKey: .password)!
        let loginId:String=(staff?.user!.loginId)!
        //abc
        TrainBiz.sharedInstance.saveExam(id: examId!, areaId:areaId, password: password, startTime: startTime, endTime: endTime, paperId: paperId, quesNumber: String(describing: TopicCount), rightNumber: String(describing: CorrectCount), score: String(describing: Score), regId: regId, orgId: orgId, result: isPass, loginId: loginId, examContent: String(examList.description)) { (responseBean) in
            if(responseBean.success!){
                
            }else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                }
            }
        }
    }
    
    
//    func getJSONStringFromArray(array:NSArray) -> String {
//         
//        if (!JSONSerialization.isValidJSONObject(array)) {
//            print("无法解析出JSONString")
//            return ""
//        }
//         
//        let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData?
//        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
//        return JSONString! as String
//    }
}
