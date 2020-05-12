//
//  TrainViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class TrainViewController:UIViewController{
    var trainList:[TrainBean]!
    @IBOutlet weak var tableViewTrainList:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf=self
        weakSelf!.tableViewTrainList?.delegate = weakSelf!
        weakSelf!.tableViewTrainList?.dataSource = weakSelf!
//        self.navigationController?.title = "我的培训"
        initTableCell()
        if(trainList != nil){
            DispatchQueue.main.async {
                weakSelf!.tableViewTrainList?.reloadData()
            }
        }else{
            TrainBiz.sharedInstance.findRegistrationList(loginId:staff!.user!.loginId!,idNumber: staff!.idNumber!) { (responseBean) in
                if(responseBean.success!){
                    let trainList:[TrainBean] = responseBean.result as! [TrainBean]
                    weakSelf!.trainList = trainList
                    DispatchQueue.main.async {
                        weakSelf!.tableViewTrainList?.reloadData()
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
    
    func goPlanView(train:TrainBean){
//        weak var weakSelf=self
        let planView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlanView") as! PlanViewController
        planView.trainBean = train
//        planView.planId = planId
//        self.navigationController?.present(planView, animated: true, completion: nil)
        self.navigationController?.pushViewController(planView, animated: true)
    }
    deinit {
        LogUtil.sharedInstance.printLog(message: "TrainViewController 被销毁！！！！！！！！")
    }
}

extension TrainViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        weak var weakSelf=self
        if(weakSelf!.trainList != nil){
            return (weakSelf!.trainList?.count)!
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

     weak var weakSelf=self
//        AlertUtil.sharedInstance.showWaitDialog(message: "努力加载数据中...")
//        AlertUtil.sharedInstance.closeWaitDialog()
        DispatchQueue.main.async {
            self.goPlanView(train: weakSelf!.trainList[indexPath.row])
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
