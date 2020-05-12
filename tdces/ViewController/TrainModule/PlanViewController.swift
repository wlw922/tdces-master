//
//  PlanViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class PlanViewController: UIViewController {
    
    var trainBean:TrainBean?
    var planDetailList:[PlanDetailBean]!=[PlanDetailBean].init()
    
    @IBOutlet weak var labTrainTitle:UILabel!
    @IBOutlet weak var labTrainDesc:UILabel!
    @IBOutlet var tableViewPlanDetailList:UITableView?
    var startExamView:StartExamView?
    var planPeriodBean:PlanPeriodBean?
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "PlanViewController 被销毁！！！！！！！！")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf=self
        weakSelf!.navigationController?.navigationBar.tintColor = UIColor.white
        weakSelf!.navigationItem.title = "培训详情"
        var titleName:String=""
        if(trainBean!.regDate != nil){
            titleName.append(trainBean!.regDate!.substring(from: 0, to: 3))
            titleName.append("年")
            titleName.append(trainBean!.regDate!.substring(from: 5, to: 6))
            titleName.append("月报名")
        }
        weakSelf!.labTrainTitle.text =  titleName
        initTableView()
        initNotification()
        getPlanDetailData(id: String((trainBean?.plan?.id)!))
    }
    func refreshTableView(){
        weak var weakSelf=self
        DispatchQueue.main.async {
            weakSelf!.tableViewPlanDetailList?.reloadData()
        }
    }
    
    func initNotification(){
        weak var weakSelf=self
        NotificationCenter.default.addObserver(weakSelf!, selector: #selector(getNotification(noti:)), name: NotifyStartExam, object: nil)
    }
    
    @objc func getNotification(noti:Notification){
        weak var weakSelf=self
        switch noti.name {
        case NotifyStartExam:
            guard let paper=noti.object as? PaperBean else {
                return
            }
            weakSelf!.startExamView?.removeFromSuperview()
            let paperView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaperViewController") as! PaperViewController
            paperView.paper = paper
            paperView.train = trainBean
            DispatchQueue.main.async {

                self.navigationController?.present(paperView, animated: true, completion: nil)
            }
//            self.navigationController?.pushViewController(paperView, animated: true)
            break
        default:
            break
        }
    }
    func initTableView(){
        weak var weakSelf=self
        weakSelf!.tableViewPlanDetailList?.delegate=weakSelf
        weakSelf!.tableViewPlanDetailList?.dataSource=weakSelf
        let chapterTableCell = UINib.init(nibName: "ChapterTableCell", bundle: nil)
        tableViewPlanDetailList?.register(chapterTableCell, forCellReuseIdentifier: "ChapterTableCell")
        let materialTableCell = UINib.init(nibName: "MaterialTableCell", bundle: nil)
        tableViewPlanDetailList?.register(materialTableCell, forCellReuseIdentifier: "MaterialTableCell")
        let paperTableCell = UINib.init(nibName: "PaperTableCell", bundle: nil)
        tableViewPlanDetailList?.register(paperTableCell, forCellReuseIdentifier: "PaperTableCell")
    }
    func getPlanDetailData(id:String){
        weak var weakSelf=self
        TrainBiz.sharedInstance.getPlanDetailByReg(id: id) { (responseBean) in
            if(responseBean.success!){
                
                let chapterList:[ChapterBean] = responseBean.result as! [ChapterBean]
                var serialNumber:Int = 1
                for chapter in chapterList{
                    let planDetailByChapter:PlanDetailBean=PlanDetailBean.init()
                    planDetailByChapter.serialNumber = String(serialNumber)
                    planDetailByChapter.type = 1
                    planDetailByChapter.chapter = chapter
                    weakSelf!.planDetailList.append(planDetailByChapter)
                    if(chapter.chapterType == 0){
                        var secSerialNumber:Int = 1
                        for material in chapter.materialList!{
                            let planDetailByMaterial:PlanDetailBean=PlanDetailBean.init()
                            planDetailByMaterial.serialNumber = String("\(serialNumber)-\(secSerialNumber)")
                            planDetailByMaterial.type = 2
                            planDetailByMaterial.material = material
                            weakSelf!.planDetailList.append(planDetailByMaterial)
                            secSerialNumber += 1
                        }
                    }else if(chapter.chapterType == 3 && chapter.paper != nil){
                        var secSerialNumber:Int = 1
                        let planDetailByPaper:PlanDetailBean=PlanDetailBean.init()
                        planDetailByPaper.serialNumber = String("\(serialNumber)-\(secSerialNumber)")
                        planDetailByPaper.type = 3
                        planDetailByPaper.paper = chapter.paper
                        weakSelf!.planDetailList.append(planDetailByPaper)
                        secSerialNumber += 1
                    }
                    serialNumber += 1
                }
                weakSelf!.getRegistrationResult(regId: String((weakSelf!.trainBean?.id)!))
            }
        }
    }
    
    func getRegistrationResult(regId:String){
        weak var weakSelf=self
        TrainBiz.sharedInstance.getRegistrationResult(regId: regId) { (responseBean) in
            if(responseBean.success!){
                weakSelf!.planPeriodBean = responseBean.result as? PlanPeriodBean
            }else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                }
            }
            weakSelf!.refreshTableView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: NotifyCloseMediaView, object: nil)
    }
    
    func goMediaView(material:MaterialBean){
        weak var weakSelf=self
        let mediaView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CXMediaViewController") as! CXMediaViewController
        mediaView.material = material
        mediaView.train = weakSelf!.trainBean
        mediaView.planPeriodBean = weakSelf!.planPeriodBean
//        mediaView.plan = weakSelf!.trainBean?.plan!
        weakSelf!.navigationController?.pushViewController(mediaView, animated: true)
    }
    
    func goDocumentView(material:MaterialBean){
        weak var weakSelf=self
        let documentView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DocumentView") as! DocumentViewController
        documentView.material = material
        weakSelf!.navigationController?.pushViewController(documentView, animated: true)
    }
    
    func goPaperView(paper:PaperBean){
        weak var weakSelf=self
        LogUtil.sharedInstance.printLog(message: "点击开始考试时间：\(DateUtil().getDateNow(dateFormat: DateUtil.CUSTOM_PATTERN))")
        startExamView=StartExamView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        startExamView!.paper = paper
        startExamView!.labPaperName.text = paper.paperName
        startExamView!.labPaperDuration.text = String(paper.paperDuration!) + ":00"
        startExamView!.labPassCondition.text = String(paper.passCondition!)
        weakSelf!.view.addSubview(startExamView!)
    }
    
}

extension PlanViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(planDetailList != nil){
            return (planDetailList?.count)!
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf=self
        let row=indexPath.row
        let planDetail:PlanDetailBean = planDetailList[row]
        if(planDetail.type == 2){
            if(planDetail.material?.materialFormat == 0){
                DispatchQueue.main.async {
                    weakSelf!.goMediaView(material: planDetail.material!)
                }
            }else if(planDetail.material?.materialFormat == 1){
                DispatchQueue.main.async {
                    weakSelf!.goDocumentView(material: planDetail.material!)
                }
            }
        }else if(planDetail.type == 3){ //跳转到考试
            DispatchQueue.main.async {
                weakSelf!.goPaperView(paper: planDetail.paper!)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row=indexPath.row
        let planDetail:PlanDetailBean = planDetailList[row]
        if(planDetail.type == 1){
            let cellIdentifier : String = "ChapterTableCell"
            let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChapterTableCell
            cell.setupWithBean(chapterBean: planDetail.chapter!)
            cell.chapter=planDetail.chapter
            cell.setSerialNumber(serialNumber: planDetail.serialNumber!)
            return cell
        }else if(planDetail.type == 2){
            let cellIdentifier : String = "MaterialTableCell"
            let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MaterialTableCell
            cell.setupWithBean(materialBean: planDetail.material!)
            let material = planPeriodBean?.materiaPeriodList?.first(where: { (materiaPeriodBean) -> Bool in
                if(materiaPeriodBean.materialId == planDetail.material?.id){
                    return true
                }else{
                    return false
                }
            })
            if(material != nil){
                if(material!.watchDuration! > 0){
                    var watchDuration:String=""
                    if(material!.watchDuration!>3600){
                        watchDuration.append(String(describing: (material!.watchDuration!/3600)))
                        watchDuration.append("时")
                        watchDuration.append(String(describing: (material!.watchDuration!%3600/60)))
                        watchDuration.append("分")
                        watchDuration.append(String(describing: (material!.watchDuration!%60)))
                        watchDuration.append("秒")
                    }else if(material!.watchDuration!>60){
                        watchDuration.append(String(describing: (material!.watchDuration!/60)))
                        watchDuration.append("分")
                        watchDuration.append(String(describing: (material!.watchDuration!%60)))
                        watchDuration.append("秒")
                    }else{
                        watchDuration=String(describing: (material?.watchDuration)!)
                    }
                    cell.labStauts.text = "已观看：\(watchDuration)"
                }
            }else{
                cell.labStauts.text = "尚未观看。"
            }
            cell.material=planDetail.material
            cell.setSerialNumber(serialNumber: planDetail.serialNumber!)
            return cell
        }else{
            let cellIdentifier : String = "PaperTableCell"
            let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PaperTableCell
            cell.setupWithBean(paperBean: planDetail.paper!)
            cell.paper=planDetail.paper
            cell.setSerialNumber(serialNumber: planDetail.serialNumber!)
            return cell
        }
    }
    
    // 预测cell的高度
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    // 自动布局后cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
