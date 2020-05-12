//
//  UserInformationViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/11/1.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class UserInformationViewController: UIViewController {
    @IBOutlet weak var labUserName:UILabel!
    @IBOutlet weak var labSex:UILabel!
    @IBOutlet weak var labMobile:UILabel!
    @IBOutlet weak var labBirthday:UILabel!
    @IBOutlet weak var labIdNumber:UILabel!
    @IBOutlet weak var labOrganization:UILabel!
    @IBOutlet weak var labCertificateId:UILabel!
//    @IBOutlet weak var labFirstDate:UILabel!
//    @IBOutlet weak var labEffectDate:UILabel!
//    @IBOutlet weak var labExpireDate:UILabel!
    @IBOutlet weak var imgStaffImage:UIImageView!
    deinit {
        LogUtil.sharedInstance.printLog(message: "UserInformationViewController 被销毁！！！！！！！！")
    }
}
extension UserInformationViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "个人信息"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        labUserName.text = staff?.name!
        if(staff!.sex != nil){
            if(staff!.sex == 0){
                labSex.text = "男"
            }else{
                labSex.text = "女"
            }
        }
        labMobile.text = staff!.mobile
        labBirthday.text = staff!.birthday
        labIdNumber.text = (staff?.idNumber!.substring(from: 0, to: 3))! + "****" + (staff?.idNumber!.substring(from: (staff?.idNumber!.count)!-4, to: (staff?.idNumber!.count)!-1))!
        labCertificateId.text = staff!.staffCert?.certNo
//        labFirstDate.text = staff?.staffCert?.firstApplyTime
//        labExpireDate.text = staff?.staffCert?.expireDate
        let staffImageUrl:String = PHOTO_URL + (staff?.attachments?.first(where: { (attachmentBean) -> Bool in
            if(attachmentBean.category == 2){
                return true
            }else{
                return false
            }
        })!.fileUrl)!
        imgStaffImage.kf.setImage(with: URL.init(string: staffImageUrl), placeholder: UIImage.init(named: "head_portrait_default"), options: nil, progressBlock: nil) { (result) in
            do{
                self.imgStaffImage.image = try result.get().image.roundCornersToCircle(withBorder: 2, color: UIColor.white)
            }catch{
                print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
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
