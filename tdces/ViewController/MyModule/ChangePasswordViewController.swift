//
//  ChangePasswordViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/11/27.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class ChangePasswordViewController: UIViewController {
    @IBOutlet var txtfOldPassword:UITextField?
    @IBOutlet var txtfNewPassword:UITextField?
    
    @IBAction func toChangePassword(){
        let userId:String=String((staff?.user?.id)!)
        let newPassword:String=(txtfNewPassword?.text)!
        let oldPassword:String=(txtfOldPassword?.text)!
        let loginId:String=(staff?.user!.loginId)!
        UserBiz.sharedInstance.changePassword(id: userId, newPassword: newPassword, loginId: loginId, oldPassword: oldPassword) { (responseBean) in
            if(responseBean.success!){
                UserDefaults.LoginInfo.set(value: newPassword, forKey: .password)
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showSuccessDialog(message: "修改成功") {
                        self.dismiss(animated: true) {
                            
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                }
            }
        }
    }
    deinit {
        LogUtil.sharedInstance.printLog(message: "ChangePasswordViewController 被销毁！！！！！！！！")
    }
}
extension ChangePasswordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "修改密码"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogUtil.sharedInstance.printLog(message: "WelcomeView viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogUtil.sharedInstance.printLog(message: "WelcomeView viewDidAppear")
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
