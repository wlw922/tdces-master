//
//  PaperHistroyDetail1.swift
//  tdces
//
//  Created by MAC on 2020/4/23.
//  Copyright © 2020 gmcx. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import SwiftyJSON

 class PaperHistroyDetail1: UIViewController {
    var examList:[ExamContentBean]!
    
    var PaperHistroryBeanList:PaperHistroryBean!
       @IBOutlet weak var tableViewTranscriptList:UITableView?
        var examId:String?

       func initTableCell(){
        //判断cell
           let YOrNTableCell = UINib.init(nibName: "YOrNTableCell", bundle: nil)
        tableViewTranscriptList?.register(YOrNTableCell.self, forCellReuseIdentifier: "YOrNTableCell")

        //单选多选一起cell
        let alltogetherCell = UINib.init(nibName: "alltogetherCell", bundle: nil)
        tableViewTranscriptList?.register(alltogetherCell.self, forCellReuseIdentifier: "alltogetherCell")
        //带图
        let alltogetherImageCell = UINib.init(nibName: "alltogetherImageCell", bundle: nil)
        tableViewTranscriptList?.register(alltogetherImageCell.self, forCellReuseIdentifier: "alltogetherImageCell")
        
        //简答cell
        let shortAnswerTableCell = UINib.init(nibName: "shortAnswerTableCell", bundle: nil)
        tableViewTranscriptList?.register(shortAnswerTableCell.self, forCellReuseIdentifier: "shortAnswerTableCell")
       //考试信息cell
        let paperHistroyInformationTableCell = UINib.init(nibName: "paperHistroyInformationTableCell", bundle: nil)
        tableViewTranscriptList?.register(paperHistroyInformationTableCell.self, forCellReuseIdentifier: "paperHistroyInformationTableCell")
        
       }
       deinit {
           LogUtil.sharedInstance.printLog(message: "TranscriptViewControllers 被销毁！！！！！！！！")
       }
    
    
   }

   extension PaperHistroyDetail1 {
       override func viewDidLoad() {
           super.viewDidLoad()
        
         self.navigationController?.title = ""
         self.navigationController?.navigationBar.isHidden = false
         self.navigationController?.navigationBar.tintColor = UIColor.white
        
         
        
           weak var weakSelf=self
           weakSelf!.tableViewTranscriptList?.delegate = weakSelf!
           weakSelf!.tableViewTranscriptList?.dataSource = weakSelf!
        
          initTableCell()
        weakSelf!.tableViewTranscriptList?.reloadData()

        weakSelf!.tableViewTranscriptList?.estimatedRowHeight = 100
        weakSelf!.tableViewTranscriptList?.rowHeight = UITableView.automaticDimension;
        
        
           if(PaperHistroryBeanList != nil){
               DispatchQueue.main.async {
                   weakSelf!.tableViewTranscriptList?.reloadData()
               }
           }else{
          
            //请求单张试卷数据
           TrainBiz.sharedInstance.getExamAllById(id: examId!) { (responseBean) in
                            if(responseBean.success!){
                               
                                weakSelf!.PaperHistroryBeanList = responseBean.result as? PaperHistroryBean

                                print("接收score---\(weakSelf!.PaperHistroryBeanList.score!)")
                                print("接收startTime---\(weakSelf!.PaperHistroryBeanList.startTime!)")
                                
                                weakSelf!.examList = weakSelf!.PaperHistroryBeanList.examContentList
                                print("examListCount = \(weakSelf!.examList.count)")
                              
                               
                             
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

   extension PaperHistroyDetail1:UITableViewDataSource,UITableViewDelegate{
       func numberOfSections(in tableView: UITableView) -> Int {
           return 2
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
//           weak var weakSelf=self
//           if(weakSelf!.transcriptList != nil){
//               return (weakSelf!.transcriptList?.count)!
//           }
//           else{
//               return 0
//           }
        
        if (section == 0)
        {
           
           
            weak var weakSelf=self
            if(weakSelf!.PaperHistroryBeanList != nil){
                return 1
            }
            else{
                return 0
            }
        }
        else if(section == 1)
        {
           weak var weakSelf=self
            if(weakSelf!.examList != nil){
                return (weakSelf!.examList?.count)!
            }
            else{
                return 0
            }
           
        }
        else
        {
            return 0
        }
           
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          // weak var weakSelf=self
           DispatchQueue.main.async {
               
           }
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

           weak var weakSelf=self
      
      
           let row=indexPath.row
        if (indexPath.section == 0) {
            let cellIdentifier : String = "paperHistroyInformationTableCell"
            let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! paperHistroyInformationTableCell
            // 禁止cell点击选中
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            

             if(PaperHistroryBeanList != nil)
             {
                let transcriptBean : PaperHistroryBean = weakSelf!.PaperHistroryBeanList!
                cell.setupWithBean(transcriptBean: transcriptBean)
              
             }
           
             return cell
        }
        else
        {
            
           // if (indexPath.row==0)//单选和获选cell
            if (weakSelf!.examList != nil)
            {
                let exam : ExamContentBean = examList![row]
                if (exam.quesType == 0 || exam.quesType == 1)//单选和多选cell
                {
                    if(exam.fileUrl! == "")
                    {
                        let cellIdentifier : String = "alltogetherCell"
                        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! alltogetherCell
                                                // 禁止cell点击选中
                                                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                                               
                                                cell.setupWithBean(examContentBean: exam)
                                                return cell
                    }
                    else
                    {
                        let cellIdentifier : String = "alltogetherImageCell"
                         let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! alltogetherImageCell
                         // 禁止cell点击选中
                         cell.selectionStyle = UITableViewCell.SelectionStyle.none
                        
                         cell.setupWithBean(examContentBean: exam)
                         return cell
                    }
                    
                }
                else if (exam.quesType == 2)//判断题cell
                {
                    let cellIdentifier : String = "YOrNTableCell"
                    let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! YOrNTableCell
                    // 禁止cell点击选中
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.setupWithBean(examContentBean : exam)
                     return cell
                }
                else//简答题
                {
                    let cellIdentifier : String = "shortAnswerTableCell"
                    let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! shortAnswerTableCell
                    // 禁止cell点击选中
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.setupWithBean(examContentBean : exam)
                    return cell
                }
            }
            else
            {
                let cellIdentifier : String = "shortAnswerTableCell"
                let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! shortAnswerTableCell
                // 禁止cell点击选中
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
              //  cell.setupWithBean()
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
          
       //  return UITableView.automaticDimension
       
        if (indexPath.section==0) {
           return 180
        }
        else{
            
            return UITableView.automaticDimension
            
           
        }

       }

 
   }
