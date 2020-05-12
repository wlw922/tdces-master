//
//  EntryViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/26.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class EntryViewController: UIViewController {
    var courseList:[CourseBean]!
    var showCourseList:[CourseBean]!
    var txtfAreaSelectedIndex:Int=0
    @IBOutlet var tableViewCourseList:UITableView?
    @IBOutlet var txtfArea:SelectionTextField!
    
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "EntryViewController 被销毁！！！！！！！！")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var weakSelf = self
        weakSelf!.showCourseList = weakSelf!.courseList
        CommonBiz.sharedInstance.getLicensedFullArea { (responseBean) in
            if(responseBean.success!){
                var cityData:[String]=[String].init()
                cityData.append("全部")
                let areaList = responseBean.result as! [AreaBean]
                for area in areaList{
                    cityData.append(area.areaName!)
                }
                weakSelf!.txtfArea.showSingleColPicker("所在区域", data: cityData, defaultSelectedIndex: nil, autoSetSelectedText: true) { (txtf, selectedIndex, selectedValue) in
                    weakSelf!.txtfAreaSelectedIndex=selectedIndex
                    if(selectedIndex == 0){
                        weakSelf!.showCourseList = weakSelf!.courseList
                        DispatchQueue.main.async {
                            weakSelf!.refreshTableView()
                        }
                    }else{
                        weakSelf!.showCourseList.removeAll()
                        weakSelf!.showCourseList = weakSelf!.courseList.filter({ (courseBean) -> Bool in
                            if(courseBean.area?.areaName == selectedValue){
                                return true
                            }
                            return false
                        })
                        DispatchQueue.main.async {
                            weakSelf!.refreshTableView()
                        }
                    }
                    
                }
            }
            
            
        }
        
        initTableCell()
        refreshTableView()
    }
    func initTableCell(){
        weak var weakSelf = self
        weakSelf!.tableViewCourseList?.delegate=weakSelf
        weakSelf!.tableViewCourseList?.dataSource=weakSelf
        let courseCell = UINib.init(nibName: "EntryTableCell", bundle: nil)
        tableViewCourseList?.register(courseCell, forCellReuseIdentifier: "EntryTableCell")
    }
    
    func refreshTableView(){
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf!.tableViewCourseList?.reloadData()
        }
    }
    
    func goEntryDetailView(course:CourseBean){
        weak var weakSelf = self
        let entryDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EntryDetailView") as! EntryDetailViewController
        entryDetailView.course = course
        weakSelf!.navigationController?.pushViewController(entryDetailView, animated: true)
    }
}

extension EntryViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(showCourseList != nil){
            return (showCourseList?.count)!
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf = self
        let row=indexPath.row
        DispatchQueue.main.async {
            weakSelf!.goEntryDetailView(course: weakSelf!.showCourseList![row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier : String = "EntryTableCell"
        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EntryTableCell
        let row=indexPath.row
        let courseBean : CourseBean = showCourseList![row]
        
        cell.setupWithBean(courseBean: courseBean)
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
