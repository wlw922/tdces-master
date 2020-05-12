//
//  ContinueEducationTabViewController.swift
//  ContinueEducation
//
//  Created by Str1ng on 2017/4/20.
//  Copyright © 2017年 gmcx. All rights reserved.
//


import UIKit
import SwiftHTTP

class ContinueEducationTabViewController: UITabBarController,ConditionDelegate,UITabBarControllerDelegate{
    
    var showCarViewIndex = 0 // 0 OnlineCarView 1 OfflineCarView 2 AlertCarView
    
    var mDelegate:ConditionDelegate?
//    var locationManager:AMapLocationManager=AMapLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.delegate = self
//        initAMapLocationManager()
        initNotification()
        self.delegate=self
        if(!isLogin){
//            let mainView=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
//            self.present(mainView, animated: true, completion: nil)
        }
    }
    
    func initNotification() {
//                NotificationCenter.default.addObserver(self, selector: #selector(getNotification(noti:)), name: NotifyPushLogin, object: nil)
    }
    
    @objc func getNotification(noti: Notification)  {
        switch noti.name {
        
        default:
            break
        }
        
    }
    
    func initAMapLocationManager(){
//        locationManager.distanceFilter = 200
//        locationManager.locatingWithReGeocode = true
//        //iOS 9（不包含iOS 9） 之前设置允许后台定位参数，保持不会被系统挂起
//        locationManager.pausesLocationUpdatesAutomatically = false
//        //iOS 9（包含iOS 9）之后新特性：将允许出现这种场景，同一app中多个locationmanager：一些只能在前台定位，另一些可在后台定位，并可随时禁止其后台定位。
//        if UIDevice.current.systemVersion._bridgeToObjectiveC().doubleValue >= 9.0 {
//            locationManager.pausesLocationUpdatesAutomatically = true
//        }
//        //开始持续定位
//        locationManager.startUpdatingLocation()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!isLogin){
            self.selectedIndex=0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //记录上一次的index
    var _lastSelectedIndex: NSInteger!
    var lastSelectedIndex: NSInteger {
        if _lastSelectedIndex == nil {
            _lastSelectedIndex = NSInteger()
            //判断是否相等,不同才设置
            if (self.selectedIndex != selectedIndex) {
                //设置最近一次
                _lastSelectedIndex = self.selectedIndex;
            }
            //调用父类的setSelectedIndex
            super.selectedIndex = selectedIndex
        }
        return _lastSelectedIndex
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //获取选中的item
        item.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        let tabIndex = tabBar.items?.firstIndex(of: item)
        if tabIndex != self.selectedIndex {
            //设置最近一次变更
            _lastSelectedIndex = self.selectedIndex
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
//        if !isLogin {
//            self.selectedIndex = _lastSelectedIndex
//            let login=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
//            self.viewControllers![selectedIndex].present(login, animated: true, completion: nil)
//            return false
//        } else {
            return true
//        }
    }
    
    
}

//extension ContinueEducationTabViewController:AMapLocationManagerDelegate{
//    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
//        //        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy);};");
//        aMapLocation = location
//        if let reGeocode = reGeocode {
//            //            NSLog("reGeocode:%@", reGeocode)
//            aMapLocationReGeocode = reGeocode
//            NotificationCenter.default.post(name: NotifyLocationChange, object: nil)
//        }
//    }
//    
//    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
//    }
//}
