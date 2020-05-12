//
//  HomeViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/12.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class HomeViewController: UIViewController {
    @IBOutlet weak var btnGoTrain:UIButton!
    @IBOutlet weak var btnGoExam:UIButton!
    @IBOutlet weak var btnGoEntry:UIButton!
    @IBOutlet weak var viewAD:UIView!
    //图片轮播组件
    var sliderGallery : SliderGalleryController!
    
    var isFirstLoad:Bool = true
    @IBAction func goTrain(){
        btnGoTrain .isEnabled = false
        DispatchQueue.main.async {
            AlertUtil.sharedInstance.showWaitDialog(message: "获取数据中，请稍等...")
        }
        TrainBiz.sharedInstance.findRegistrationList(loginId:staff!.user!.loginId!,idNumber: staff!.idNumber!) { (responseBean) in

            DispatchQueue.main.async {
                AlertUtil.sharedInstance.closeWaitDialog()
            }
            if(responseBean.success!){
                let trainList:[TrainBean] = responseBean.result as! [TrainBean]
                DispatchQueue.main.async {
                    self.goTrainView(trainList: trainList)
                }
                
            }else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                }
            }
        }
    }
    @IBAction func goEntry(){
        btnGoEntry.isEnabled = false
        DispatchQueue.main.async {
            AlertUtil.sharedInstance.showWaitDialog(message: "获取数据中，请稍等...")
        }
        EntryBiz.sharedInstance.findValidList(loginId: (staff!.user?.loginId)!, completion: { (responseBean) in
        DispatchQueue.main.async {
            AlertUtil.sharedInstance.closeWaitDialog()
        }
            if(responseBean.success!){
                let courseList:[CourseBean] = responseBean.result as! [CourseBean]
                CommonBiz.sharedInstance.getDicListByType { (getDicListByTypeResult) in
                    if(getDicListByTypeResult.success!){
                        let trainReasonList = getDicListByTypeResult.result as! [TrainReasonBean]
                        var resultList:[CourseBean] = [CourseBean].init()
                        for course in courseList{
                            let trainReasonString = trainReasonList.filter { (trainReasonBean) -> Bool in
                                if("\((trainReasonBean.dicValue)!)" == course.regReason!){
                                    return true
                                }
                                return false
                                }.first?.dicLabel
                            course.regReasonString = trainReasonString
                            resultList.append(course)
                        }
                        DispatchQueue.main.async {
                            self.goEntryView(courseList: resultList)
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                }
            }
            
            
        })
    }
    
    @IBAction func goStartExam(){
        btnGoExam.isEnabled = false
        let myExamView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyExamView") as! MyExamViewController
        self.navigationController?.pushViewController(myExamView, animated: true)
        
    }
    func goEntryView(courseList:[CourseBean]){
        let entryView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EntryView") as! EntryViewController
        entryView.courseList = courseList
        self.navigationController?.pushViewController(entryView, animated: true)
    }
    func goTrainView(trainList:[TrainBean]){
        let trainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrainView") as! TrainViewController
        trainView.trainList = trainList
        //        self.present(trainView, animated: true, completion: nil)
        self.navigationController?.pushViewController(trainView, animated: true)
    }
    
    override func viewDidLoad() {
        self.navigationController?.title = "首页"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btnGoExam.isEnabled = true
        btnGoEntry.isEnabled = true
        btnGoTrain .isEnabled = true
        if(isFirstLoad){
            isFirstLoad = false
            //初始化图片轮播组件
            sliderGallery = SliderGalleryController()
            weak var weakSelf=self
            sliderGallery.delegate = weakSelf
            sliderGallery.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth,
                                              height: self.viewAD.bounds.height)
            //将图片轮播组件添加到当前视图
            self.addChild(sliderGallery)
            self.viewAD.addSubview(sliderGallery.view)
        }
    }
}

extension HomeViewController:SliderGalleryControllerDelegate{
    func galleryDataSource() {
        let galleryDataSource:[String]=["bg_ad01","bg_ad02","bg_ad03","bg_ad04"]
        self.sliderGallery.dataSource = galleryDataSource
        DispatchQueue.main.async {
            self.sliderGallery.configureImageView()
            //设置页控制器
            self.sliderGallery.configurePageController()
            //设置自动滚动计时器
            self.sliderGallery.configureAutoScrollTimer()
            //                            self.sliderGallery.resetImageViewSource()
        }
    }
    
    func galleryScrollerViewSize() -> CGSize {
        return CGSize(width: ScreenWidth, height: self.viewAD.bounds.height)
    }
    
    
}
