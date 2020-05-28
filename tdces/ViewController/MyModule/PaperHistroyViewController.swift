//
//  PaperHistroyViewController.swift
//  tdces
//
//  Created by Str1ng on 2020/1/17.
//  Copyright © 2020 gmcx. All rights reserved.
//

import Foundation
class PaperHistroyViewController: UIViewController {
    var transcriptList:[TranscriptBean]!
    @IBOutlet weak var tableViewTranscriptList:UITableView?
    
    func initTableCell(){
        let scoreTableCell = UINib.init(nibName: "ScoreTableCell", bundle: nil)
        tableViewTranscriptList?.register(scoreTableCell, forCellReuseIdentifier: "ScoreTableCell")
    }
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "TranscriptViewControllers 被销毁！！！！！！！！")
    }
}

extension PaperHistroyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf=self
        weakSelf!.tableViewTranscriptList?.delegate = weakSelf!
        weakSelf!.tableViewTranscriptList?.dataSource = weakSelf!
        initTableCell()
        
        if(transcriptList != nil){
            DispatchQueue.main.async {
                weakSelf!.tableViewTranscriptList?.reloadData()
            }
        }else{
            TrainBiz.sharedInstance.findExamList(idNumber: (staff?.idNumber)!) { (responseBean) in
                if(responseBean.success!){
                    let transcriptList:[TranscriptBean] = responseBean.result as! [TranscriptBean]
                    weakSelf!.transcriptList = transcriptList
                    DispatchQueue.main.async {
                        weakSelf!.tableViewTranscriptList?.reloadData()
                    }
                }else{
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                    }
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptViewControllers viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptViewControllers viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptViewControllers viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LogUtil.sharedInstance.printLog(message: "TranscriptViewControllers viewDidDisappear")
    }
    
}

extension PaperHistroyViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        weak var weakSelf=self
        if(weakSelf!.transcriptList != nil){
            return (weakSelf!.transcriptList?.count)!
        }
        else{
            DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "没有数据")
            }
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf=self
        DispatchQueue.main.async {
            
        //原调用
           /*
            let paperHistroyDetailView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaperHistroyDetailView") as! PaperHistroyDetailViewController
 
            paperHistroyDetailView.examId = String((weakSelf?.transcriptList[indexPath.row].id)!)
            
//不知啥用    weakSelf?.present(transcriptDetailView, animated: true, completion: nil)
            weakSelf?.navigationController?.pushViewController(paperHistroyDetailView, animated: true)
           */
          
         //新调用
             let paperHistroyDetail1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaperHistroyDetail1") as! PaperHistroyDetail1
             paperHistroyDetail1.examId = String((weakSelf?.transcriptList[indexPath.row].id)!)
             weakSelf?.navigationController?.pushViewController(paperHistroyDetail1, animated: true)
             
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cellIdentifier : String = "ScoreTableCell"
        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ScoreTableCell
        let row=indexPath.row
        
        let transcriptBean : TranscriptBean = transcriptList![row]
       
          cell.setupWithBean(transcriptBean: transcriptBean)
      

        
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
