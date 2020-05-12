//
//  EntryDetailViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/28.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SCLAlertView
class EntryDetailViewController:UIViewController{
    
    @IBOutlet weak var labCourseName:UILabel!
    @IBOutlet weak var labTrainCategory:UILabel!
    @IBOutlet weak var labRegReason:UILabel!
    @IBOutlet weak var labTrainOrganization:UILabel!
    @IBOutlet weak var labTrainAddress:UILabel!
    @IBOutlet weak var labCouresDesc:UILabel!
    @IBOutlet weak var labCouresDuration:UILabel!
    @IBOutlet weak var labCouresPrice:UILabel!
    
    @IBOutlet weak var viewPrice:UIView!
    var course:CourseBean?
    deinit {
        LogUtil.sharedInstance.printLog(message: "EntryDetailViewController 被销毁！！！！！！！！")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = course?.courseName!
        initNotification()
        labCourseName.text = course?.courseName!
        labTrainCategory.text = course?.str!
        labRegReason.text = course?.regReasonString!
        labTrainOrganization.text = course?.organization?.name!
        labTrainAddress.text = course?.organization?.address!
        labCouresDesc.text = course?.courseDesc!
        if(WXApi.isWXAppInstalled()){
            viewPrice.isHidden = false
            labCouresDuration.text = "\(String(describing: (course?.courseDuration)!))学时"
            labCouresPrice.text = "¥\(String(describing: (course?.price)!))元"
        }else{
            viewPrice.isHidden = true
        }
        
        
    }
    
    func returnUnifiedorder(payMethod:String){
        let productId:String=String((course?.id)!)
        let body:String=(course?.courseName)!
        let loginId:String=(staff?.user?.loginId)!
        let totalFee:String=String(describing: (course?.price)!)
        if(payMethod == "22"){
            WXPayBiz.sharedInstance.returnUnifiedorder(productId: productId, body: body, totalFee: totalFee, payMethod: payMethod, loginId: loginId) { (responseBean) in
                if(responseBean.success!){
                    let prePayBean = responseBean.result as! PrePayBean
                    
                    self.toSubmitRegister(payMethod: payMethod, prePayBean: prePayBean)
                    
                    
                    
                }else{
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                    }
                }
            }
        }
        

    }
    
    func toSubmitRegister(payMethod:String,prePayBean:PrePayBean?=nil){
        var paymentId:String = ""
        if(prePayBean != nil){
            paymentId = String((prePayBean?.paymentId)!)
        }
        EntryBiz.sharedInstance.submitRegister(courseId: String((course?.id)!), loginId: (staff?.user?.loginId!)!, staffId: String((staff?.id)!), payMethod: payMethod, paymentId: paymentId, isDelete: "1") { (responseBean) in
                    if( responseBean.success!){
                        if(prePayBean != nil){
                            let request = PayReq.init()
                            request.partnerId = prePayBean!.mchId!
                            request.prepayId = prePayBean!.prepayId!
                            request.package = "Sign=WXPay"
                            request.nonceStr=prePayBean!.nonceStr!
                            
                            let timeStamp = Int(Date().timeIntervalSince1970)
                            request.timeStamp = UInt32(timeStamp)
                            let signString:String="appid=\(WX_APPID)&noncestr=\(prePayBean!.nonceStr!)&package=\(request.package)&partnerid=\(prePayBean!.mchId!)&prepayid=\(String((prePayBean!.prepayId)!))&timestamp=\(timeStamp)&key=\(WX_APP_KEY)"
                            request.sign = signString.md5()
                            DispatchQueue.main.async {
                                WXApi.send(request) { (result) in
                                    if(result){
                                    }else{
                                    }
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                AlertUtil.sharedInstance.showAutoDismissSuccessDialog(title: "成功", message: "报名成功，等待审核通过即可开始培训！", timeout: 2) {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                        
                    }else{
                        AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                    }
                }
    }
}


extension EntryDetailViewController{
    @IBAction func toSubmitRegister(){
        //自定义提示框样式
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: false  //隐藏头部图标
        )
        let alertView = SCLAlertView.init(appearance: appearance)
        var payMethod:String=""
//        alertView.addButton("支付宝") {
//            payMethod = "21"
//        }
        if(WXApi.isWXAppInstalled()){
            alertView.addButton("微信") {
                payMethod = "22"
                self.returnUnifiedorder(payMethod: payMethod)
            }
        }else{
            alertView.addButton("确定") {
                payMethod = "1"
                self.toSubmitRegister(payMethod: payMethod,prePayBean:PrePayBean.init())
            }
        }
//        alertView.addButton("现场付款") {
//            payMethod = "1"
//            self.submitRegister(payMethod: payMethod)
//        }
        alertView.showNotice("报名", subTitle: "请确认是否报名？",closeButtonTitle: "取消")
    }
}

extension EntryDetailViewController{
    func initNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(noti:)), name: NotifyWXPaySuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(noti:)), name: NotifyWXPayFailed, object: nil)
    }
    
    @objc func getNotification(noti:Notification){
        switch noti.name {
        case NotifyWXPaySuccess:
            DispatchQueue.main.async {
                AlertUtil.sharedInstance.showAutoDismissSuccessDialog(title: "成功", message: "报名成功，等待审核通过即可开始培训！", timeout: 2) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            break
        case NotifyWXPayFailed:
            DispatchQueue.main.async {
                AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "报名失败，请重新报名！") {
                }
                
            }
            break
        default:
            break
        }
    }
}
