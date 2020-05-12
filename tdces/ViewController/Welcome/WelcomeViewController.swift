//
//  ViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/9/25.
//  Copyright © 2019 gmcx. All rights reserved.
//

import UIKit
import RealmSwift
/// 欢迎页
class WelcomeViewController: UIViewController {
    
    let realm = try! Realm()
    var isFirst:Bool=true
    
    func initNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(noti:)), name: NotifyLoginSuccess, object: nil)
    }
    
    @objc func getNotification(noti:Notification){
        switch noti.name {
        case NotifyLoginSuccess:
            //            self.goMainView()
            break
        default:
            break
        }
    }
    func goMainView(){
        DispatchQueue.main.async(execute: {
            let mainView=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! ContinueEducationTabViewController
            self.present(mainView, animated: true, completion: nil)
        })
    }
    
    func goLoginView(){
        DispatchQueue.main.async(execute: {
            let loginView=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView") as! LoginAndRegistViewController
            self.present(loginView, animated: true, completion: nil)
        })
    }
    
    func getAreaData(){
        let areaList = realm.objects(AreaDbBean.self)
        if(areaList.count == 0){
            CommonBiz.sharedInstance.getFullAreaList { (responseBean) in
                if(responseBean.success!){
                    let data:[AreaBean] = responseBean.result as! [AreaBean]
                    if(data.count > 0){
                        for province in data{
                            let provinceDbBean:AreaDbBean=AreaDbBean()
                            provinceDbBean.areaId = province.id!
                            provinceDbBean.areaName = province.areaName
                            provinceDbBean.areaType = 1
                            if(province.children != nil){
                                for city in province.children!{
                                    let cityDbBean:AreaDbBean=AreaDbBean()
                                    cityDbBean.areaId=city.id!
                                    cityDbBean.areaName=city.areaName
                                    cityDbBean.areaType = 2
                                    if(city.children != nil){
                                        for district in city.children!{
                                            let districtDbBean:AreaDbBean = AreaDbBean()
                                            districtDbBean.areaId = district.id!
                                            districtDbBean.areaName = district.areaName
                                            districtDbBean.areaType = 3
                                            cityDbBean.children.append(districtDbBean)
                                        }
                                    }
                                    provinceDbBean.children.append(cityDbBean)
                                }
                            }
                            DispatchQueue.main.async {
                                try! self.realm.write {
                                    self.realm.add(provinceDbBean)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    func toLogin(userName:String ,password:String) {
        UserBiz.sharedInstance.toLogin(username: userName, password: password) { (responseBean) in
            if(responseBean.success!){
                UserBiz.sharedInstance.getStaffInfo(loginId: staff!.user!.loginId!) { (getUserInfoResponseBean) in
                    if(getUserInfoResponseBean.success!){
                        DispatchQueue.main.async {
                            self.goMainView()
                        }
                    }else{
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: responseBean.message!)
                        }
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: responseBean.message!) {
                        self.goLoginView()
                    }
                }
            }
        }
    }
    deinit {
        LogUtil.sharedInstance.printLog(message: "WelcomeView 被销毁！！！！！！！！")
    }
}

extension WelcomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        LogUtil.sharedInstance.printLog(message: "WelcomeView viewDidLoad")
        self.getAreaData()
        weak var weakSelf=self
        UpdateManager.sharedInstance.delegate = weakSelf
        initNotification()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogUtil.sharedInstance.printLog(message: "WelcomeView viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogUtil.sharedInstance.printLog(message: "WelcomeView viewDidAppear")
        if(isFirst){
            isFirst = false
            LogUtil.sharedInstance.printLog(message: "UpdateManager.sharedInstance.update()")
            UpdateManager.sharedInstance.update()
        }else{
            if(staff != nil){
                goMainView()
            }
            else{
                let userName=UserDefaults.LoginInfo.string(forKey: .userName)
                let password=UserDefaults.LoginInfo.string(forKey: .password)
                if(userName != nil && password != nil){
                    self.toLogin(userName: userName!, password: password!)
                }else{
                    goLoginView()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogUtil.sharedInstance.printLog(message: "WelcomeView viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LogUtil.sharedInstance.printLog(message: "WelcomeView viewDidDisappear")
    }
    
    
}

extension WelcomeViewController:UpdateDelegate{
    func noUpdate() {
        isFirst = false
        if(staff != nil){
            goMainView()
        }
        else{
            let userName=UserDefaults.LoginInfo.string(forKey: .userName)
            let password=UserDefaults.LoginInfo.string(forKey: .password)
            if(userName != nil && password != nil){
                self.toLogin(userName: userName!, password: password!)
            }else{
                goLoginView()
            }
        }
    }
}
