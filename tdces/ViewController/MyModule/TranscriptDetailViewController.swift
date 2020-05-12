//
//  TranscriptDetailViewController.swift
//  tdces
//
//  Created by Str1ng on 2020/1/14.
//  Copyright © 2020 gmcx. All rights reserved.
//

import Foundation
class TranscriptDetailViewController:UIViewController{
    @IBOutlet weak var labPaperName: UILabel!
    @IBOutlet weak var labIsPassed: UILabel!
    @IBOutlet weak var labExamTime: UILabel!
    @IBOutlet weak var labEndTime:UILabel!
    @IBOutlet weak var labStaffIdNumber:UILabel!
    @IBOutlet weak var labElapsedTime:UILabel!
    @IBOutlet weak var labQuestionsCount:UILabel!
    @IBOutlet weak var labScore: UILabel!
    @IBOutlet weak var labName: UILabel!
    var examId:String?
    //    var transcriptBean:TranscriptBean?
    deinit {
        LogUtil.sharedInstance.printLog(message: "TranscriptDetailViewController 被销毁！！！！！！！！")
    }
    
    func getExamDetail(){
        TrainBiz.sharedInstance.getExamById(id: examId!) { (responseBean) in
            if(responseBean.success!){
                weak var weakSelf=self
                let transcriptBean:TranscriptBean = responseBean.result as! TranscriptBean
               
                DispatchQueue.main.async {
                    weakSelf!.labPaperName.text=transcriptBean.paper?.paperName!
                    var passedString:String=""
                    if(transcriptBean.isPassed!){
                        passedString="已通过"
                    }else{
                        
                        passedString="未通过"
                    }
                    weakSelf!.labIsPassed.text = passedString
                    weakSelf!.labExamTime.text = transcriptBean.startTime!
                    weakSelf!.labEndTime.text = transcriptBean.endTime!
                    weakSelf!.labScore.text = "\(String(transcriptBean.score!))分"
                    weakSelf!.labQuestionsCount.text="\(String(transcriptBean.rightNumber!))"+"/"+"\(String(transcriptBean.quesNumber!))"
                    var elapsedTime:String=""
                    if(transcriptBean.all!/1000>60){
                        elapsedTime="\(transcriptBean.all!/1000/60)分\(transcriptBean.all!/1000%60)秒"
                    }else{
                        elapsedTime="\(transcriptBean.all!/1000%60)秒"
                    }
                    weakSelf!.labElapsedTime.text = elapsedTime
                    weakSelf!.labName.text = transcriptBean.reg?.name!
                    weakSelf!.labStaffIdNumber.text = transcriptBean.reg?.idNumber!
                }
                
            }else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                }
            }
        }
    }
}
extension TranscriptDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = ""
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        getExamDetail()
        //        labPaperName.text=transcriptBean!.paper?.paperName!
        //        var passedString:String=""
        //        if(transcriptBean!.isPassed!){
        //            passedString="已通过"
        //        }else{
        //
        //            passedString="未通过"
        //        }
        //        labIsPassed.text = passedString
        //        labExamTime.text = transcriptBean?.startTime!
        //        labEndTime.text = transcriptBean?.endTime!
        //        labScore.text = "\(String(transcriptBean!.score!))分"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptDetailViewController viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptDetailViewController viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptDetailViewController viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptDetailViewController viewDidDisappear")
    }
    
}
