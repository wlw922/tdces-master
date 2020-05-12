//
//  MyExamViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/11/13.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class MyExamViewController:UIViewController{
    var trainList:[TrainBean]!
    
    var trainBeanSelected:TrainBean?
    @IBOutlet var tableViewTrainList:UITableView?
    var startExamView:StartExamView?
    deinit {
        LogUtil.sharedInstance.printLog(message: "MyExamViewController 被销毁！！！！！！！！")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewTrainList?.delegate = self
        self.tableViewTrainList?.dataSource = self
        initTableCell()
        initNotification()
        if(trainList != nil){
            DispatchQueue.main.async {
                self.tableViewTrainList?.reloadData()
            }
        }else{
            TrainBiz.sharedInstance.findRegistrationList(loginId:staff!.user!.loginId!,idNumber: staff!.idNumber!) { (responseBean) in
                if(responseBean.success!){
                    let trainList:[TrainBean] = responseBean.result as! [TrainBean]
                    self.trainList = trainList
                    DispatchQueue.main.async {
                        self.tableViewTrainList?.reloadData()
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                    }
                }
            }
        }
    }
    func initTableCell(){
        let trainCell = UINib.init(nibName: "TrainTableCell", bundle: nil)
        tableViewTrainList?.register(trainCell, forCellReuseIdentifier: "TrainTableCell")
    }
    
    func initNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(noti:)), name: NotifyStartExam, object: nil)
    }
    
    @objc func getNotification(noti:Notification){
        switch noti.name {
        case NotifyStartExam:
            guard let paper=noti.object as? PaperBean else {
                return
            }
            self.startExamView?.removeFromSuperview()
            
           
            let paperView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaperViewController") as! PaperViewController
            paperView.paper = paper
            paperView.train = trainBeanSelected
            self.present(paperView, animated: true, completion: nil)
//            self.navigationController?.pushViewController(paperView, animated: true)
            break
        default:
            break
        }
    }
    
    func goPaperView(paper:PaperBean){
        LogUtil.sharedInstance.printLog(message: "点击开始考试时间：\(DateUtil().getDateNow(dateFormat: DateUtil.CUSTOM_PATTERN))")
        startExamView=StartExamView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        startExamView!.paper = paper
        startExamView!.labPaperName.text = paper.paperName
        startExamView!.labPaperDuration.text = String(paper.paperDuration!) + ":00"
        startExamView!.labPassCondition.text = String(paper.passCondition!)
        self.view.addSubview(startExamView!)
    }
}

extension MyExamViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(trainList != nil){
            return (trainList?.count)!
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.trainBeanSelected = self.trainList[indexPath.row]
        TrainBiz.sharedInstance.getPlanDetailByReg(id: String((trainBeanSelected?.plan!.id)!)) { (responseBean) in
            if(responseBean.success!){
                let chapterList:[ChapterBean] = responseBean.result as! [ChapterBean]
                let chapter=chapterList.first { (chapterBean) -> Bool in
                    if(chapterBean.chapterType == 3 && chapterBean.paper != nil){
                        return true
                    }else{
                        return false
                    }
                }
                if(chapter != nil){
                    self.trainBeanSelected?.plan?.paper = chapter!.paper
                    DispatchQueue.main.async {
                        self.goPaperView(paper: (self.trainBeanSelected?.plan!.paper)!)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier : String = "TrainTableCell"
        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrainTableCell
        let row=indexPath.row
        let trainBean : TrainBean = trainList![row]
        
        cell.setupWithBean(trainBean: trainBean)
        return cell
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
