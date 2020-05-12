//
//  MyViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/11/1.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class MyViewController: UIViewController {
    
    @IBOutlet weak var labUserName:UILabel!
    @IBOutlet weak var labIdNumber:UILabel!
    @IBOutlet weak var imgStaffImage:UIImageView!
    deinit {
        LogUtil.sharedInstance.printLog(message: "MyViewController 被销毁！！！！！！！！")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "我的"
        labUserName.text = staff?.name!
        labIdNumber.text = (staff?.idNumber!.substring(from: 0, to: 3))! + "****" + (staff?.idNumber!.substring(from: (staff?.idNumber!.count)!-4, to: (staff?.idNumber!.count)!-1))!
        if(staff?.attachments != nil){
            if((staff?.attachments!.count)! > 0){
                let staffPhotoUrl:AttachmentBean = ((staff?.attachments?.first(where: { (attachmentBean) -> Bool in
                    if(attachmentBean.category == 2){
                        return true
                    }else{
                        return false
                    }
                }))!)
                if(staffPhotoUrl.fileUrl != ""){
                    let staffImageUrl:String = PHOTO_URL + (staff?.attachments?.first(where: { (attachmentBean) -> Bool in
                        if(attachmentBean.category == 2){
                            return true
                        }else{
                            return false
                        }
                    })!.fileUrl)!
                    imgStaffImage.kf.setImage(with: URL.init(string: staffImageUrl), placeholder: UIImage.init(named: "head_portrait_default"), options: nil, progressBlock: nil) { (result) in
                        do{
                            self.imgStaffImage.image = try result.get().image.toCircle()
                            self.imgStaffImage.layer.borderWidth = 2
                            self.imgStaffImage.layer.borderColor = UIColor.white.cgColor
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.title = "我的"
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension MyViewController{
    
    @IBAction func toLogOut(){
        staff = nil
        UserDefaults.LoginInfo.remove(forKey: .userName)
        UserDefaults.LoginInfo.remove(forKey: .password)
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func toAbout(){
        DispatchQueue.main.async(execute: {
            let aboutView=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutView") as! AboutViewController
            self.navigationController!.pushViewController(aboutView, animated: true)
        })
    }
    
    @IBAction func toUserInfomation(){
        DispatchQueue.main.async(execute: {
            let userInformationView=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInformationViewController") as! UserInformationViewController
            self.navigationController!.pushViewController(userInformationView, animated: true)
        })
    }
    
    @IBAction func toChangePassword(){
        DispatchQueue.main.async(execute: {
            let changePasswordView=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordView") as! ChangePasswordViewController
            self.navigationController!.pushViewController(changePasswordView, animated: true)
        })
        
    }
}
