//
//  PaperViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/25.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import Kingfisher
import SwiftyJSON

/// <#Description#>
class PaperViewController:UIViewController{
     var paper:PaperBean?
     var train:TrainBean?
    var questionIndex:Int=0
    var questionDetailList:[QuestionDetailBean] = [QuestionDetailBean].init()
    @IBOutlet weak var paperTitle:UILabel!
    @IBOutlet weak var paperPassCondition:UILabel!
    @IBOutlet weak var labPaperDuration:UILabel!
    //    @IBOutlet var questionContent:UILabel!
    //    @IBOutlet var questionImage:UIImageView!
    @IBOutlet weak var btnNextQuestion:UIButton!
    @IBOutlet weak var btnPreviousQuestion:UIButton!
    
    
    @IBOutlet weak var tableViewQuestionDetail:UITableView?
    var minute:Int=0
    var second:Int=0
//    var faceRecognitionCount:Int=0
    var secondFaceRecongnitionIndex:Int = 0
    var startTime:String=""
    var endTime:String=""
    var PaperDurationTimerName:String = "PaperDurationTimerName"
    var examId:Int?
//    var isGoFace:Bool = false
    var scoreReportingView:ScoreReportingView?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogUtil.sharedInstance.printLog(message: "PaperViewController viewDidAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogUtil.sharedInstance.printLog(message: "PaperViewController viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if(GCDTimerManager.shared.isExistTimer(WithTimerName: PaperDurationTimerName)){
            GCDTimerManager.shared.cancleTimer(WithTimerName: PaperDurationTimerName)
        }
        weak var weakSelf=self
        NotificationCenter.default.removeObserver(weakSelf!, name: NotifyAnswerChange, object: nil)
        NotificationCenter.default.removeObserver(weakSelf!, name: NotifyFaceRecognitionSuccess, object: nil)
        NotificationCenter.default.removeObserver(weakSelf!, name: NotifyExamPass, object: nil)
        NotificationCenter.default.removeObserver(weakSelf!, name: NotifyExamFailed, object: nil)
        LogUtil.sharedInstance.printLog(message: "PaperViewController viewDidDisappear")
    }
    
    deinit {
        
        //        }
//        faceRecognitionCount=0
        LogUtil.sharedInstance.printLog(message: "PaperViewController 被销毁！！！")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initTableCell()
        initNotification()
        LogUtil.sharedInstance.printLog(message: "PaperViewController viewDidLoad")
        weak var weakSelf=self
        paperTitle.text = paper?.paperName
        paperPassCondition.text = "\(String(describing: (paper?.passCondition)!)) "
        minute = paper!.paperDuration!
        //        minute = 1
        labPaperDuration.text = String(paper!.paperDuration!) + ":00"
        if((paper?.questionList.count)! > 0){
            secondFaceRecongnitionIndex = Int.randomIntNumber(lower: (paper?.questionList.count)!/3, upper: (paper?.questionList.count)!/3*2)
            LogUtil.sharedInstance.printLog(message: secondFaceRecongnitionIndex)
        }
        DispatchQueue.main.async {
            AlertUtil.sharedInstance.showWaitDialog(message: "获取数据中，请稍等...")
        }
        TrainBiz.sharedInstance.getPaperById(id: String((weakSelf!.paper?.id)!)) { (responseBean) in
            if(responseBean.success!){
                print("getPaperById running")
                weakSelf!.paper = responseBean.result as? PaperBean
                weakSelf!.startTime = DateUtil().getDateNow(dateFormat: DateUtil.CUSTOM_PATTERN)
                let isPass:String="0"
                let areaId:String=String( (weakSelf!.train?.area?.id)!)
                let regId:String=String((weakSelf!.train?.id)!)
                let paperId:String=String((weakSelf!.paper?.id)!)
                let orgId:String=String( (weakSelf!.train?.org?.id)!)
                let password:String=UserDefaults.LoginInfo.string(forKey: .password)!
                let loginId:String=(staff?.user!.loginId)!
                TrainBiz.sharedInstance.saveExam(id: "", areaId:areaId, password: password, startTime: weakSelf!.startTime, endTime: weakSelf!.endTime, paperId: paperId, quesNumber: String(
                    (weakSelf!.paper!.questionList.count)), rightNumber: "", score: "", regId: regId, orgId: orgId, result: isPass, loginId: loginId, examContent: "") { (responseBean) in
                        
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.closeWaitDialog()
                        }
                        if(responseBean.success!){
                            
                            do{
                                let examJson = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                                weakSelf!.examId = examJson["id"].int
//                                weakSelf!.isGoFace = true
                                if(weakSelf!.train?.plan?.isExamAuth!==1){
                                   DispatchQueue.main.async{
                                       weakSelf!.goFaceRecognitionView()
                                   }
                                }else{
                                   NotificationCenter.default.post(name: NotifyFaceRecognitionSuccess, object: nil)
                                }
                                
                            }catch {
                                LogUtil.sharedInstance.printLog(message: error.localizedDescription)
                            }
                        }else{
                            DispatchQueue.main.async {
                                AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                            }
                        }
                }
                
                
                
            }
            else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: responseBean.message!) {
                        weakSelf!.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        }
        
        hideKeyboardWhenTappedAround() 
        refreshTableView()
    }
    func hideKeyboardWhenTappedAround() {
//        weak var weakSelf=self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
    func initTableCell(){
        tableViewQuestionDetail?.delegate=self
        tableViewQuestionDetail?.dataSource=self
        let questionTableCell = UINib.init(nibName: "QuestionTableCell", bundle: nil)
        tableViewQuestionDetail?.register(questionTableCell, forCellReuseIdentifier: "QuestionTableCell")
        let questionImageTableCell = UINib.init(nibName: "QuestionImageTableCell", bundle: nil)
        tableViewQuestionDetail?.register(questionImageTableCell, forCellReuseIdentifier: "QuestionImageTableCell")
        let answerTableCell = UINib.init(nibName: "AnswerTableCell", bundle: nil)
        tableViewQuestionDetail?.register(answerTableCell, forCellReuseIdentifier: "AnswerTableCell")
        let shortAnswerQuestionTableCell = UINib.init(nibName: "ShortAnswerQuestionTableCell", bundle: nil)
        tableViewQuestionDetail?.register(shortAnswerQuestionTableCell, forCellReuseIdentifier: "ShortAnswerQuestionTableCell")
    }
    
    func refreshTableView(){
//        weak var weakSelf=self
        DispatchQueue.main.async {
            self.tableViewQuestionDetail?.reloadData()
        }
    }
    
    func setQuestionView(question:QuestionBean){
        weak var weakSelf=self
        weakSelf!.questionDetailList.removeAll()
        let questionContent:String = question.questContent!
        let questionDetail:QuestionDetailBean = QuestionDetailBean()
        questionDetail.type = 1
        questionDetail.id = question.id!
        questionDetail.quesType = question.quesType!
        questionDetail.question = questionContent
        weakSelf!.questionDetailList.append(questionDetail)
        
        if(question.fileUrl != nil){
            if(!question.fileUrl!.isEmpty){
                let questionImageUrl:String = PHOTO_URL + question.fileUrl!
                let questionDetailImage:QuestionDetailBean = QuestionDetailBean()
                questionDetailImage.id = question.id!
                questionDetailImage.type = 2
                questionDetailImage.questionImageUrl = questionImageUrl
                weakSelf!.questionDetailList.append(questionDetailImage)
            }
        }
        
        
        if(question.quesType == 0 || question.quesType == 1){
            for answer in question.answerList!{
                let questionAnswer:QuestionDetailBean = QuestionDetailBean()
                questionAnswer.id = question.id!
                questionAnswer.type = 3
                questionAnswer.quesType = question.quesType!
                questionAnswer.answer = answer
                weakSelf!.questionDetailList.append(questionAnswer)
            }
        }else if(question.quesType == 2){
            let questionAnswerFirst:QuestionDetailBean = QuestionDetailBean()
            
            questionAnswerFirst.id = question.id!
            questionAnswerFirst.type = 3
            questionAnswerFirst.quesType = question.quesType!
            questionAnswerFirst.answer = question.answerList?.first
            questionAnswerFirst.answer?.content = "正确"
            weakSelf!.questionDetailList.append(questionAnswerFirst)
            
            let questionAnswerlast:QuestionDetailBean = QuestionDetailBean()
            questionAnswerlast.id = question.id!
            questionAnswerlast.type = 3
            questionAnswerlast.quesType = question.quesType!
            questionAnswerlast.answer = question.answerList?.last
            questionAnswerlast.answer?.content = "错误"
            weakSelf!.questionDetailList.append(questionAnswerlast)
        }else if(question.quesType == 3){//简答题
            let shortAnswerQuestion:QuestionDetailBean = QuestionDetailBean()
            shortAnswerQuestion.id = question.id!
            shortAnswerQuestion.type = 3
            shortAnswerQuestion.quesType = question.quesType!
            shortAnswerQuestion.options = question.options
            shortAnswerQuestion.shortAnswer = question.saqAnswer
            weakSelf!.questionDetailList.append(shortAnswerQuestion)
        }
        weakSelf!.refreshTableView()
    }
    
    
    func goScoreReportingView() {
        weak var weakSelf=self
        scoreReportingView = ScoreReportingView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scoreReportingView!.paper = weakSelf!.paper
        scoreReportingView!.train = weakSelf!.train
        scoreReportingView!.startTime = weakSelf!.startTime
        scoreReportingView!.endTime = weakSelf!.endTime
        scoreReportingView!.examId = String((weakSelf!.examId)!)
        scoreReportingView!.delegate = weakSelf!
        scoreReportingView!.setView()
        weakSelf!.view.addSubview(scoreReportingView!)
        
    }
    
    func goFaceRecognitionView(){
        weak var weakSelf=self
        DispatchQueue.main.async {
            let faceRecognitionView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FaceRecognitionViewController") as! FaceRecognitionViewController
            faceRecognitionView.train=weakSelf!.train
            faceRecognitionView.paper=weakSelf!.paper
            faceRecognitionView.reconType = "2"
            faceRecognitionView.examId = String((weakSelf!.examId)!)
            weakSelf!.present(faceRecognitionView, animated: true) {
            }
        }
    }
}

// MARK: UITableViewDataSource,UITableViewDelegate
extension PaperViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weak var weakSelf=self
        if(weakSelf!.questionDetailList.count > 0){
            return weakSelf!.questionDetailList.count
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let row=indexPath.row
        //        DispatchQueue.main.async {
        //            self.goEntryDetailView(course: self.showCourseList![row])
        //        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf=self
        let row=indexPath.row
        if(weakSelf!.questionDetailList[row].type == 1){ //question
            let cellIdentifier : String = "QuestionTableCell"
            let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QuestionTableCell
            cell.setupWithBean(questionDetail: weakSelf!.questionDetailList[row])
            return cell
        }else if(weakSelf!.questionDetailList[row].type == 2){ //questionImageView
            let cellIdentifier : String = "QuestionImageTableCell"
            let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QuestionImageTableCell
            cell.setupWithBean(questionDetail: weakSelf!.questionDetailList[row])
            return cell
        }else{
            if(weakSelf!.questionDetailList[row].quesType == 3){
                let cellIdentifier : String = "ShortAnswerQuestionTableCell"
                let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ShortAnswerQuestionTableCell
                cell.setupWithBean(questionDetail: weakSelf!.questionDetailList[row])
                return cell
            }else{
                let cellIdentifier : String = "AnswerTableCell"
                let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AnswerTableCell
                cell.setupWithBean(questionDetail: weakSelf!.questionDetailList[row])
                return cell
            }
            
        }
    }
    
    // 预测cell的高度
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }
    
    // 自动布局后cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - IBAction
extension PaperViewController{
    @IBAction func nextQuestion(){
        weak var weakSelf=self
        if((weakSelf?.paper?.questionList.count)! > 0){
            if(questionIndex  == (weakSelf!.paper?.questionList.count)!-1){ //交卷
                        endTime = DateUtil().getDateNow(dateFormat: DateUtil.CUSTOM_PATTERN)
                        LogUtil.sharedInstance.printLog(message: endTime)
                        if(GCDTimerManager.shared.isExistTimer(WithTimerName: PaperDurationTimerName)){
                            GCDTimerManager.shared.cancleTimer(WithTimerName: PaperDurationTimerName)
                        }
            //            weakSelf!.isGoFace = true
                        DispatchQueue.main.async {
                            if(self.train?.plan?.isExamAuth!==1){
                               DispatchQueue.main.async{
                                   weakSelf!.goFaceRecognitionView()
                               }
                            }else{
                               NotificationCenter.default.post(name: NotifyFaceRecognitionSuccess, object: nil)
                            }
                        }
                    }else{
                        questionIndex += 1
                        if(questionIndex == (weakSelf!.paper?.questionList.count)!-1){
                            btnNextQuestion.setTitle("我要交卷", for: .normal)
                            btnNextQuestion.backgroundColor = UIColor.colorWithHex(hex: "EC625C")
                        }else{
                            btnNextQuestion.setTitle("下一题", for: .normal)
                            btnNextQuestion.backgroundColor = UIColor.colorWithHex(hex: "459AF8")
                        }
                        DispatchQueue.main.async {
                            weakSelf!.setQuestionView(question: (weakSelf!.paper?.questionList[weakSelf!.questionIndex])!)
                            if(weakSelf!.questionIndex == weakSelf!.secondFaceRecongnitionIndex){
                                if(GCDTimerManager.shared.isExistTimer(WithTimerName: weakSelf!.PaperDurationTimerName)){
                                    GCDTimerManager.shared.cancleTimer(WithTimerName: weakSelf!.PaperDurationTimerName)
                                }
            //                    weakSelf!.isGoFace = true
                                if(self.train?.plan?.isExamAuth!==1){
                                   DispatchQueue.main.async{
                                       weakSelf!.goFaceRecognitionView()
                                   }
                                }else{
                                   NotificationCenter.default.post(name: NotifyFaceRecognitionSuccess, object: nil)
                                }
                            }
                        }
                    }
        }
        
    }
    
    @IBAction func previousQuestion(){
        
        weak var weakSelf=self
        if(questionIndex-1 < 0){
            AlertUtil.sharedInstance.showAutoDismissDialog(title: "温馨提示", message: "当前为第一题", timeout: 2)
        }else {
            questionIndex -= 1
            if(questionIndex < (weakSelf!.paper?.questionList.count)!-1){
                btnNextQuestion.setTitle("下一题", for: .normal)
                btnNextQuestion.backgroundColor = UIColor.colorWithHex(hex: "459AF8")
            }else{
                btnNextQuestion.setTitle("我要交卷", for: .normal)
                btnNextQuestion.backgroundColor = UIColor.colorWithHex(hex: "EC625C")
            }
            DispatchQueue.main.async {
                weakSelf!.setQuestionView(question: (weakSelf!.paper?.questionList[weakSelf!.questionIndex])!)
            }
        }
    }
}

// MARK: - Notification
extension PaperViewController{
    
    /// 初始化Notification
    func initNotification(){
        
        weak var weakSelf=self
        NotificationCenter.default.addObserver(weakSelf!, selector: #selector(getNotification(noti:)), name: NotifyAnswerChange, object: nil)
        NotificationCenter.default.addObserver(weakSelf!, selector: #selector(getNotification(noti:)), name: NotifyFaceRecognitionSuccess, object: nil)
//        NotificationCenter.default.addObserver(weakSelf!, selector: #selector(getNotification(noti:)), name: NotifyExamPass, object: nil)
//        NotificationCenter.default.addObserver(weakSelf!, selector: #selector(getNotification(noti:)), name: NotifyExamFailed, object: nil)
        NotificationCenter.default.addObserver(weakSelf!, selector: #selector(getNotification(noti:)), name: NotifyExamFinished, object: nil)
    }
    
    /// Notification处理逻辑
    @objc func getNotification(noti:Notification){
        weak var weakSelf=self
        switch noti.name {
        case NotifyExamFinished:
            DispatchQueue.main.async {
                weakSelf!.dismiss(animated: true, completion: nil)
            }
//        case NotifyExamFailed:
//            DispatchQueue.main.async {
//                weakSelf!.dismiss(animated: true, completion: nil)
//            }
//            break
//        case NotifyExamPass:
//            DispatchQueue.main.async {
//                weakSelf!.dismiss(animated: true, completion: nil)
//            }
            break
        case NotifyAnswerChange:
            guard let questionDetail = noti.object as? QuestionDetailBean else{
                return
            }
            if(questionDetail.quesType == 1){//多选题
                weakSelf!.paper?.questionList.first(where: { (question) -> Bool in
                    if(question.id == questionDetail.id){
                        return true
                    }else{
                        return false
                    }
                })?.answerList?.first(where: { (answer) -> Bool in
                    if(answer.content == questionDetail.answer?.content){
                        return true
                    }else{
                        return false
                    }
                })?.isCheck = questionDetail.answer!.isCheck
                weakSelf!.questionDetailList.first { (result) -> Bool in
                    if(result.answer?.content == questionDetail.answer?.content){
                        return true
                    }else{
                        return false
                    }
                    }?.answer?.isCheck = questionDetail.answer!.isCheck
            }else if(questionDetail.quesType == 3){//简答题
                weakSelf!.paper?.questionList.first(where: { (question) -> Bool in
                    if(question.id == questionDetail.id){
                        return true
                    }else{
                        return false
                    }
                })?.saqAnswer = questionDetail.shortAnswer
            }
            else{ //单选、判断题，答案变更后
                if(questionDetail.answer!.isCheck){//选择
                    weakSelf!.paper?.questionList.first(where: { (question) -> Bool in
                        if(question.id == questionDetail.id){
                            return true
                        }else{
                            return false
                        }
                    })?.answerList?.forEach({ (answer) in
                        if(answer.content == questionDetail.answer?.content){
                            answer.isCheck = true
                        }else{
                            answer.isCheck = false
                        }
                    })
                }else{//取消选择
                    weakSelf!.paper?.questionList.first(where: { (question) -> Bool in
                        if(question.id == questionDetail.id){
                            return true
                        }else{
                            return false
                        }
                    })?.answerList?.first(where: { (answer) -> Bool in
                        if(answer.content == questionDetail.answer?.content){
                            return true
                        }else{
                            return false
                        }
                    })?.isCheck = questionDetail.answer!.isCheck
                    weakSelf!.questionDetailList.first { (result) -> Bool in
                        if(result.answer?.content == questionDetail.answer?.content){
                            return true
                        }else{
                            return false
                        }
                        }?.answer?.isCheck = questionDetail.answer!.isCheck
                }
            }
            weakSelf!.refreshTableView()
            break
        case NotifyFaceRecognitionSuccess:
            LogUtil.sharedInstance.printLog(message: "PaperViewController get NotifyFaceRecognitionSuccess")

//            weakSelf!.isGoFace = false
//            faceRecognitionCount += 1
            if(minute == 0 && second == 0){
                if(GCDTimerManager.shared.isExistTimer(WithTimerName: PaperDurationTimerName)){
                    GCDTimerManager.shared.cancleTimer(WithTimerName: PaperDurationTimerName)
                }
                DispatchQueue.main.async {
                    weakSelf!.goScoreReportingView()
                }
            }else{
                if(questionIndex == (weakSelf!.paper?.questionList.count)!-1){//最后一题，执行交卷
                    DispatchQueue.main.async {
                        weakSelf!.goScoreReportingView()
                    }
                }else if(questionIndex == 0){//第一次拍照，开始显示第一题
                    let firstQuestion:QuestionBean = (weakSelf!.paper?.questionList.first)!
                                        weakSelf!.paper?.questionList.removeFirst()
                                        let questionList:[QuestionBean] = weakSelf!.paper!.questionList
                                        weakSelf!.paper?.questionList.removeAll()
                                        TrainBiz.sharedInstance.getQuestionsById(id: String((firstQuestion.id)!), completion: { (responseBean) in
                                            if(responseBean.success!){
                                                let question:QuestionBean = (responseBean.result as? QuestionBean)!
                                                weakSelf!.paper?.questionList.append(question)
                                                DispatchQueue.main.async {
                                                    weakSelf!.setQuestionView(question: question)
                                                }
                                                
                                            }else{
                                                DispatchQueue.main.async {
                                                    AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: responseBean.message!) {
                                                        weakSelf!.dismiss(animated: true, completion: nil)
                                                    }
                                                }
                                            }
                                        })
                                        for question in questionList{
                                            TrainBiz.sharedInstance.getQuestionsById(id: String((question.id)!), completion: { (responseBean) in
                                                if(responseBean.success!){
                                                    let question:QuestionBean = (responseBean.result as? QuestionBean)!
                                                    weakSelf!.paper?.questionList.append(question)
                                                }
                                            })
                                        }
                                        
                                        if(!GCDTimerManager.shared.isExistTimer(WithTimerName: PaperDurationTimerName)){
                                            GCDTimerManager.shared.scheduledDispatchTimer(WithTimerName: PaperDurationTimerName, timeInterval: 1, queue: DispatchQueue.init(label: "ExamView"), repeats: true) {
                                                if(weakSelf!.second==0){
                                                    if(weakSelf!.minute==0){//时间到，执行人脸识别，成功后计算分数
                                                        if(GCDTimerManager.shared.isExistTimer(WithTimerName: weakSelf!.PaperDurationTimerName)){
                                                            GCDTimerManager.shared.cancleTimer(WithTimerName: weakSelf!.PaperDurationTimerName)
                                                        }
                    //                                    weakSelf!.isGoFace = true
                                                        DispatchQueue.main.async {
                                                            weakSelf!.labPaperDuration.text = "\(String(weakSelf!.minute))0:0\(String(weakSelf!.second))"
                                                            if(self.train?.plan?.isExamAuth!==1){
                                                               DispatchQueue.main.async{
                                                                   weakSelf!.goFaceRecognitionView()
                                                               }
                                                            }else{
                                                               NotificationCenter.default.post(name: NotifyFaceRecognitionSuccess, object: nil)
                                                            }
                                                        }
                                                    }else{
                                                        weakSelf!.minute -= 1
                                                        weakSelf!.second = 59
                                                        DispatchQueue.main.async {
                                                            if(weakSelf!.minute < 10){
                                                                weakSelf!.labPaperDuration.text = "0\(String(weakSelf!.minute)):\(String(weakSelf!.second))"
                                                            }else{
                                                                weakSelf!.labPaperDuration.text = "\(String(weakSelf!.minute)):\(String(weakSelf!.second))"
                                                            }
                                                            
                                                        }
                                                    }
                                                }else{
                                                    weakSelf!.second -= 1
                                                    var minuteString=""
                                                    if(weakSelf!.minute<10){
                                                        minuteString = "0\(String(weakSelf!.minute))"
                                                    }else{
                                                        minuteString = "\(String(weakSelf!.minute))"
                                                    }
                                                    var secondString=""
                                                    if(weakSelf!.second<10){
                                                        secondString = "0\(String(weakSelf!.second))"
                                                    }else{
                                                        secondString = "\(String(weakSelf!.second))"
                                                    }
                                                    DispatchQueue.main.async {
                                                        weakSelf!.labPaperDuration.text =  minuteString + ":" + secondString
                                                    }
                                                }
                                            }
                                        }
                }
                else{
                    if(!GCDTimerManager.shared.isExistTimer(WithTimerName: PaperDurationTimerName)){
                                            GCDTimerManager.shared.scheduledDispatchTimer(WithTimerName: PaperDurationTimerName, timeInterval: 1, queue: DispatchQueue.init(label: "ExamView"), repeats: true) {
                                                if(weakSelf!.second==0){
                                                    if(weakSelf!.minute==0){//时间到，执行人脸识别，成功后计算分数
                                                        
                    //                                    weakSelf!.isGoFace = true
                                                        DispatchQueue.main.async {
                                                            weakSelf!.labPaperDuration.text = "\(String(weakSelf!.minute)):\(String(weakSelf!.second))"
                                                            if(self.train?.plan?.isExamAuth!==1){
                                                               DispatchQueue.main.async{
                                                                   weakSelf!.goFaceRecognitionView()
                                                               }
                                                            }else{
                                                               NotificationCenter.default.post(name: NotifyFaceRecognitionSuccess, object: nil)
                                                            }
                                                        }
                                                    }else{
                                                        weakSelf!.minute -= 1
                                                        weakSelf!.second = 59
                                                        DispatchQueue.main.async {
                                                            weakSelf!.labPaperDuration.text = "\(String(weakSelf!.minute)):\(String(weakSelf!.second))"
                                                        }
                                                    }
                                                }else{
                                                    weakSelf!.second -= 1
                                                    DispatchQueue.main.async {
                                                        weakSelf!.labPaperDuration.text = "\(String(weakSelf!.minute)):\(String(weakSelf!.second))"
                                                    }
                                                }
                                            }
                                        }
                }
//                if(faceRecognitionCount == 1 ){
//
//                }else if(faceRecognitionCount == 2){
//
//                }else{
//                    DispatchQueue.main.async {
//                        weakSelf!.goScoreReportingView()
//                    }
//                }
            }
            
            break
        default:
            break
        }
    }
}


extension PaperViewController:ScoreReportingDelegate{
    func btnActionClick() {
        NotificationCenter.default.post(name: NotifyExamFinished, object: nil)
//        self.dismiss(animated: true, completion: nil)
//        DispatchQueue.main.async {
//            weakSelf?.scoreReportingView.removeFromSuperview()
//        }
        
    }
}
