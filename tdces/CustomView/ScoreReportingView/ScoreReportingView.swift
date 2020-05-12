//
//  ScoreReportingView.swift
//  tdces
//
//  Created by Str1ng on 2019/11/12.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ScoreReportingDelegate {
    func btnActionClick()
}

class ScoreReportingView: UIView {
    @IBOutlet weak var labScore:UILabel!
    @IBOutlet weak var labTopicCount:UILabel!
    @IBOutlet weak var labCorrectCount:UILabel!
    @IBOutlet weak var labFaultCount:UILabel!
    @IBOutlet weak var labScoreTitle:UILabel!
    @IBOutlet weak var btnAction:UIButton!
    //abc
    
    var SingleSelectgrade : Float = 0.0
    var MultipleSelectgrade : Float = 0.0
    var YorNgrade : Float = 0.0
    var ShortanswerScore = 0.0 //简答题总分
       
    var Score:Float=0
    var TopicCount:Int=0
    var CorrectCount:Int=0
    var FaultCount:Int=0
    var train:TrainBean?
    var paper:PaperBean?
    var questionSn:Int=0
    var startTime:String=""
    var endTime:String=""
    var examId:String?
    var optionString:[String]=["A","B","C","D","E","F","G","H"]
    var delegate:ScoreReportingDelegate?
    //初始化默认属性配置
    func initialSetup(){
        
    }
    var contentView:UIView!
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        //初始化属性配置
        initialSetup()
    }
    
//    @IBAction func btnStartExamAction(_ sender: UIButton) {
//        NotificationCenter.default.post(name: NotifyStartExam, object: paper)
//    }
//    
//    @IBAction func btnDismissAction(_ sender: UIButton) {
//        DispatchQueue.main.async {
//            self.removeFromSuperview()
//        }
//    }
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        //初始化属性配置
        initialSetup()
    }
    //加载xib
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle.init(for: className)
        let name =  NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func setView(){
        weak var weakSelf=self
        TopicCount=(paper?.questionList.count)!
        labTopicCount.text = String(describing: TopicCount)
        
        var examList:[JSON]=[JSON].init()
        for question in self.paper!.questionList{
            questionSn += 1
            let userAnswer:UserAnswerBean = UserAnswerBean.init()
            var options:[Option] = [Option].init()
            userAnswer.quesId = question.id
            userAnswer.quesType = question.quesType
            userAnswer.sn = questionSn
            var correctAnswers:[String]=[String].init()
            var userAnswers:[String]=[String].init()
            if(question.quesType == 0){//单选题
                var optionCode:Int=0
                for answerOption in question.answerList!{
                    let option:Option = Option.init()
                    option.content = answerOption.content
                    option.judge = answerOption.judge
                    option.code = optionString[optionCode] //String(optionCode)
                    options.append(option)
                    if(answerOption.judge!){
                        correctAnswers.append(optionString[optionCode])
                    }
                    if(answerOption.isCheck){
                        userAnswers.append(optionString[optionCode])
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
                    userAnswer.isCorrect = true
                    //abc
                    let grade:Float =  (self.paper?.scoreSetList.first(where: { (scoreSetBean) -> Bool in
                        if(scoreSetBean.type == question.quesType){
                            return true
                        }else{
                            return false
                        }
                    })!.grade)!
                    SingleSelectgrade = grade
                    print("单选分值：\(SingleSelectgrade)")
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
                    option.code = optionString[optionCode]
                    options.append(option)
                    if(answerOption.judge!){
                        correctAnswers.append(optionString[optionCode])
                    }
                    if(answerOption.isCheck){
                        userAnswers.append(optionString[optionCode])
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
                
                   let grade:Float =  (self.paper?.scoreSetList.first(where: { (scoreSetBean) -> Bool in
                    if(scoreSetBean.type == question.quesType){
                         return true
                    }else{
                         return false
                    }
                    })!.grade)!
                    MultipleSelectgrade = grade
                    print("多选分值：\(MultipleSelectgrade)")
                    Score += grade
                    userAnswer.isCorrect = true
                    CorrectCount+=1

                }
            }else if(question.quesType == 2){//判断题
                var optionCode:Int=0
                for answerOption in question.answerList!{
                    let option:Option = Option.init()
                    option.content = answerOption.content
                    option.judge = answerOption.judge
                    option.code = optionString[optionCode]
                    options.append(option)
                    if(answerOption.judge!){
                        correctAnswers.append(optionString[optionCode])
                    }
                    if(answerOption.isCheck){
                        userAnswers.append(optionString[optionCode])
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

                    
                    YorNgrade = grade
                    print("判断分值：\(YorNgrade)")
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
                    //abc
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
                 
                    print("简答分值：\(shortAnswerQuestionScore)")
                    Score += Float(shortAnswerQuestionScore)
                
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
        
        //总成绩展示
        labScore.text = String(describing: Score)
      

        
        
        
        var isPass:String="0"
        //abc
        
        if(Score>Float(paper!.passCondition!)){
            isPass = "1"
            labScoreTitle.text = "恭喜您！通过了！"
        }else{
            labScoreTitle.text = "很遗憾！没通过！"
        }
        
        
      
        
        let areaId:String=String( (self.train?.area?.id)!)
        let regId:String=String((self.train?.id)!)
        let paperId:String=String((self.paper?.id)!)
        let orgId:String=String( (self.train?.org?.id)!)
        let password:String=UserDefaults.LoginInfo.string(forKey: .password)!
        let loginId:String=(staff?.user!.loginId)!
        TrainBiz.sharedInstance.saveExam(id: examId!, areaId:areaId, password: password, startTime: startTime, endTime: endTime, paperId: paperId, quesNumber: String(describing: TopicCount), rightNumber: String(describing: CorrectCount), score: String(describing: Score), regId: regId, orgId: orgId, result: isPass, loginId: loginId, examContent: examList.description) { (responseBean) in
            DispatchQueue.main.async {
                weakSelf!.btnAction.isEnabled=true
            }

        }
    }
    
    //设置好xib视图约束
    func addConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: contentView as Any, attribute: .leading,
                                            relatedBy: .equal, toItem: self, attribute: .leading,
                                            multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView as Any, attribute: .trailing,
                                        relatedBy: .equal, toItem: self, attribute: .trailing,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView as Any, attribute: .top, relatedBy: .equal,
                                        toItem: self, attribute: .top, multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView as Any, attribute: .bottom,
                                        relatedBy: .equal, toItem: self, attribute: .bottom,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
    }
    
    @IBAction func toButtonClick(){
        weak var weakSelf=self
        weakSelf?.removeFromSuperview()
        delegate?.btnActionClick()
        //            if(responseBean.success!){
        //            }else{
        //                NotificationCenter.default.post(name: NotifyExamFailed, object: nil)
        //            }
    }
}
