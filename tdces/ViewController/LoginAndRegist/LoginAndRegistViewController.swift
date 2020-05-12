//
//  LoginAndRegistViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/17.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class LoginAndRegistViewController: UIViewController {
    @IBOutlet weak var labLoginTitle:UILabel!
    @IBOutlet weak var labRegistTitle:UILabel!
    @IBOutlet weak var viewContent:UIView!
    @IBOutlet weak var viewScrollbar:UIView!
    
    var loginView:LoginView?
    var registerView:RegisterView?
    ///相机
    var cameraPicker: UIImagePickerController!
    /// 相册
    var photoPicker: UIImagePickerController!
    var isFirstLoad:Bool=true
    
    /// 1:免冠照 2:从业资格证 3:身份证
    var imgClickType:Int=0
    var photoFileUrl:String?
    var idNumberPhotoFileUrl:String?
    var certificatePhotoFileUrl:String?
    var idNumber:String?
    var password:String?
    var repeatPassword:String?
    var userName:String?
    var sex:String?
    var birthday:String?
    var mobile:String?
//    var addressArea:[String]?
    var address:String?
    var certificateId:String?
    var trainCategoryList:[TrainCategoryBean]?
    var firstDate:String?
    var effectDate:String?
    var expireDate:String?
    var areaId:String?
    var addressRegion:String?
    var addressRegionList:[String]?
    var orgId:String?
    
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "LoginAndRegistViewController 被销毁！！！！！！！！")

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround();
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(isFirstLoad){
            isFirstLoad = false
            weak var weakSelf=self
            loginView = LoginView.init(frame: CGRect.init(x: 0, y: 0, width: weakSelf!.viewContent.bounds.width, height: weakSelf!.viewContent.bounds.height))
            loginView!.delegate = weakSelf!
            weakSelf!.viewContent.addSubview(loginView!)
           
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
protocol textFieldDelegate:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    func textFieldDidBeginEditing(_ textField: UITextField)
}

extension LoginAndRegistViewController:textFieldDelegate{
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        //view弹起跟随键盘，高可根据自己定义
        if(textField.frame.origin.y-150>0){
            UIView.animate(withDuration: 0.4, animations: {
                self.view.frame.origin.y = -150
            })
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y=0
        })
    }
    
    
}

extension LoginAndRegistViewController{
    
    @IBAction func toShowLoginView(){
        
        if(viewScrollbar.frame.minX != 0){
            UIView.animate(withDuration: 0.2, delay: 0, options: .allowAnimatedContent, animations: {
                self.viewScrollbar.frame = CGRect.init(x: 0, y: self.viewScrollbar.bounds.minY, width: self.viewScrollbar.bounds.width, height: self.viewScrollbar.bounds.height)
            }) { (result) in
                self.labLoginTitle.textColor = UIColor.colorWithHex(hex: "247EED")
                self.labRegistTitle.textColor = UIColor.lightGray
                if(self.registerView != nil){
                self.registerView!.removeFromSuperview()
                    self.registerView=nil
                }
                LogUtil.sharedInstance.printLog(message: "执行LoginView init()")
                self.loginView = LoginView.init(frame: CGRect.init(x: 0, y: 0, width: self.viewContent.bounds.width, height: self.viewContent.bounds.height))
                
                LogUtil.sharedInstance.printLog(message: "完成LoginView init()")

                weak var weakSelf=self
                self.loginView!.textFieldUserName.delegate = weakSelf!
                self.loginView!.delegate =  weakSelf!
                self.loginView!.textFieldPassword.delegate =  weakSelf!
                self.viewContent.addSubview(self.loginView!)
            }
            
        }
        
        
    }
    
    @IBAction func toShowRegistView(){
        if(viewScrollbar.frame.minX == 0){
            UIView.animate(withDuration: 0.2, delay: 0, options: .allowAnimatedContent, animations: {
                self.viewScrollbar.frame = CGRect.init(x: self.viewScrollbar.bounds.width, y: self.viewScrollbar.bounds.minY, width: self.viewScrollbar.bounds.width, height: self.viewScrollbar.bounds.height)
            }) {(result) in
                self.labRegistTitle.textColor = UIColor.colorWithHex(hex: "247EED")
                self.labLoginTitle.textColor = UIColor.lightGray
                if(self.loginView != nil){
                    self.loginView!.removeFromSuperview()
                    self.loginView=nil
                }
                weak var weakSelf=self
                self.registerView = RegisterView.init(frame: CGRect.init(x: 0, y: 0, width: self.viewContent.bounds.width, height: self.viewContent.bounds.height))
                self.registerView!.delegate =  weakSelf!
                self.viewContent.addSubview(self.registerView!)
           }
        }
    }
}
extension LoginAndRegistViewController:OrganizationSelectViewDelegate{
    func tableViewSelectedAction(organization: OrganizationBean) {
        self.orgId=String((organization.id)!)
        self.registerView?.textFieldOrganization.text = organization.name
    }
    
    
}

extension LoginAndRegistViewController:RegisterViewDelegate,TrainCategoryViewDelegate{
    func btnShowOrganizationViewClick() {
        
        let alert = OrganizationSelectView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        alert.delegate = self
        self.view.addSubview(alert)
        
    }
    
    func btnCommitClick(trainCategoryCheckList: [TrainCategoryBean]) {
        //        self.trainCategoryList=trainCategoryCheckList
        //        if(self.trainCategoryList!.count > 0){
        //            var trainCategoryString=""
        //            for trainCategory in self.trainCategoryList!{
        //                trainCategoryString.append(trainCategory.TrainCategoryString!)
        //                trainCategoryString.append(",")
        //            }
        //            trainCategoryString=trainCategoryString.substring(from: 0, to: trainCategoryString.count-2)
        //            DispatchQueue.main.async {
        //                self.registerView?.textFieldTrainCategory.text = trainCategoryString
        //            }
        //        }
    }
    
    func btnShowTrainCategoryViewClick() {
        CommonBiz.sharedInstance.getDicListByType(areaId: "") { (responseBean) in
            if(responseBean.success!){
                DispatchQueue.main.async {
                    let trainCategoryList:[TrainCategoryBean]=responseBean.result as! [TrainCategoryBean]
                    let alert = TrainCategoryView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                    alert.refreshTableView(trainCategoryList: trainCategoryList)
                    alert.delegate = self
                    self.view.addSubview(alert)
                }
            }
        }
    }
    
    func imgPhotoClick() {
        self.imgClickType = 1//1是免冠照
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel , handler: nil)
        let takePhotoAction = UIAlertAction.init(title: "拍照", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            
            //判断是否能进行拍照，可以的话打开相机
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.cameraPicker = UIImagePickerController()
                self.cameraPicker.delegate = self
                self.cameraPicker.sourceType = .camera
                self.present(self.cameraPicker, animated: true, completion: nil)
            }
            else
            {
                print("模拟其中无法打开照相机,请在真机中使用");
            }
            
        })
        let fromAlbumAction = UIAlertAction.init(title: "从相册选取", style: .default, handler:  {
            (action:UIAlertAction)
            -> Void in
            //调用相册功能，打开相册
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                self.photoPicker =  UIImagePickerController()
                self.photoPicker.delegate = self
                self.photoPicker.sourceType = .photoLibrary
                self.present(self.photoPicker, animated: true, completion: nil)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(fromAlbumAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imgIdNumberPhotoClick() {
        self.imgClickType = 3//1是身份证
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel , handler: nil)
        let takePhotoAction = UIAlertAction.init(title: "拍照", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            
            //判断是否能进行拍照，可以的话打开相机
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.cameraPicker = UIImagePickerController()
                self.cameraPicker.delegate = self
                self.cameraPicker.sourceType = .camera
                self.present(self.cameraPicker, animated: true, completion: nil)
            }
            else
            {
                print("模拟其中无法打开照相机,请在真机中使用");
            }
            
        })
        let fromAlbumAction = UIAlertAction.init(title: "从相册选取", style: .default, handler:  {
            (action:UIAlertAction)
            -> Void in
            //调用相册功能，打开相册
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                self.photoPicker =  UIImagePickerController()
                self.photoPicker.delegate = self
                self.photoPicker.sourceType = .photoLibrary
                self.present(self.photoPicker, animated: true, completion: nil)
            }
            
            
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(fromAlbumAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imgCertificatePhotoClick() {
        self.imgClickType = 2//1是从业资格证
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel , handler: nil)
        let takePhotoAction = UIAlertAction.init(title: "拍照", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            
            //判断是否能进行拍照，可以的话打开相机
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.cameraPicker = UIImagePickerController()
                self.cameraPicker.delegate = self
                self.cameraPicker.sourceType = .camera
                self.present(self.cameraPicker, animated: true, completion: nil)
            }
            else
            {
                print("模拟其中无法打开照相机,请在真机中使用");
            }
            
        })
        let fromAlbumAction = UIAlertAction.init(title: "从相册选取", style: .default, handler:  {
            (action:UIAlertAction)
            -> Void in
            //调用相册功能，打开相册
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                self.photoPicker =  UIImagePickerController()
                self.photoPicker.delegate = self
                self.photoPicker.sourceType = .photoLibrary
                self.present(self.photoPicker, animated: true, completion: nil)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(fromAlbumAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func btnRegisterClick() {
        idNumber = (registerView!.textFieldIdNumber.text)!
        
        password = idNumber?.substring(from: idNumber!.count-6, to: idNumber?.count)
        repeatPassword = password
        sex = ""
        userName = (registerView!.textFieldUserName.text)!
        birthday = idNumber!.substring(from: 6, to: 9)+"-"+idNumber!.substring(from: 10, to: 11)+"-"+idNumber!.substring(from: 12, to: 13)
        mobile = "13888888888"
//        addressArea = ["360000","361000","361002"]
        address = ""
        certificateId = idNumber
        firstDate = ""
        effectDate = ""
        expireDate = ""
        areaId = registerView?.areaId
        addressRegionList = registerView?.addressRegionList
        addressRegion = registerView?.addressRegion
        
        if(idNumber != nil){
            if(idNumber!.isEmpty){
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "身份证号不能为空")
                }
            }else{
                if(idNumber!.isIDCardNumber){
                    if(userName != nil){
                        if(userName!.isEmpty){
                            DispatchQueue.main.async {
                                AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "学员姓名不能为空")
                            }
                        }else{
                            if(addressRegionList != nil){
                                if(addressRegionList!.count>0){
                                    
                                    if(areaId != nil){
                                        if(areaId!.isEmpty){
                                            DispatchQueue.main.async {
                                                AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "请选择从业区域")
                                            }
                                        }else{
                                            if(photoFileUrl != nil){
                                                if(photoFileUrl!.isEmpty){
                                                    DispatchQueue.main.async {
                                                        AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "请选择免冠照")
                                                    }
                                                }else{
                                                            if(idNumberPhotoFileUrl != nil){
                                                                if(idNumberPhotoFileUrl!.isEmpty){
                                                                    DispatchQueue.main.async {
                                                                        AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "请选择身份证照")
                                                                    }
                                                                }else{
                                                                    if(self.orgId != nil){
                                                                        self.toRegister()
                                                                    }else{
                                                                        DispatchQueue.main.async {
                                                                            AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "请选择所属企业")
                                                                        }
                                                                    }
                                                                }
                                                            }else{
                                                                DispatchQueue.main.async { AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "请选择身份证照")
                                                                }
                                                            }
                                                }
                                            }else{
                                                DispatchQueue.main.async {
                                                    AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "请选择免冠照")
                                                }
                                            }
                                        }
                                    }else{
                                        DispatchQueue.main.async {
                                            AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "请选择从业区域")
                                        }
                                    }
                                    
                                    
                                }else{
                                    DispatchQueue.main.async {
                                        AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "请选择区域")
                                    }
                                    
                                }
                            }
                            else{
                                DispatchQueue.main.async {
                                    AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "请选择区域")
                                }
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "学员姓名不能为空")
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "请输入正确的身份证号")
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "身份证号不能为空")
            }
        }
        
        
    }
    func toRegister(){
        weak var weakSelf=self
        DispatchQueue.main.async {
            AlertUtil.sharedInstance.showWaitDialog(message: "注册中，请稍等...")
        }
        
        UserBiz.sharedInstance.register(name: userName!, password: password!, repeatPassword: repeatPassword!, sex: sex!, mobile: mobile!, idNumber: idNumber!, idcardPath: idNumberPhotoFileUrl!, photoPath: photoFileUrl!, firstApplyTime: firstDate!, expireDate: expireDate!, effectDate: effectDate!, certPath: certificatePhotoFileUrl, certNo: certificateId!, birthday: birthday!, areaId: areaId!, addressRegion: addressRegion!, address: address!, addressRegionList: addressRegionList!, orgId: weakSelf!.orgId!, certCategoryList: trainCategoryList) { (responseBean) in
            
            if(responseBean.success!){
                UserBiz.sharedInstance.toLogin(username: weakSelf!.userName!, password: weakSelf!.password!) { (loginResponseBean) in
                    if(responseBean.success!){
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.closeWaitDialog()
                            if(weakSelf?.registerView != nil){
                                weakSelf!.registerView?.removeFromSuperview()
                                weakSelf?.registerView=nil
                            }
                            weakSelf!.dismiss(animated: true) {
                                NotificationCenter.default.post(name: NotifyLoginSuccess, object: nil)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.closeWaitDialog()
                            AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.closeWaitDialog()
                    AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                }
            }
        }
    }
    
}

extension LoginAndRegistViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        let type:String = (info[UIImagePickerController.InfoKey.mediaType] as! String
        )
        //当选择的类型是图片
        if (type == "public.image")
        {
            //修正图片的位置
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            self.updatePhoto(image: image)
        }
    }
    
    func updatePhoto(image: UIImage){
        //先把图片转成NSData
        let fileData = image.jpegData(compressionQuality: 0.3)
        let fileBase64String = fileData?.base64EncodedString()
        DispatchQueue.main.async {
            AlertUtil.sharedInstance.showWaitDialog(message: "上传照片中，请稍等")
        }
        CommonBiz.sharedInstance.uploadBase64Img(imgStr: fileBase64String!) { (responseBean) in
            DispatchQueue.main.async {
                AlertUtil.sharedInstance.closeWaitDialog()
            }
            if(responseBean.success!){
                DispatchQueue.main.async {
                    switch self.imgClickType {
                    case 1:
                        self.registerView!.imgPhoto.image = image
                        self.photoFileUrl = (responseBean.result as! String)
                        break
                    case 2:
                        self.registerView!.imgCertificatePhoto.image = image
                        self.certificatePhotoFileUrl = (responseBean.result as! String)
                        break
                    case 3:
                        self.registerView!.imgIdNumberPhoto.image = image
                        self.idNumberPhotoFileUrl = (responseBean.result as! String)
                        break
                    default:
                        break
                    }
                }
            }else{
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                }
            }
        }
    }
}

extension LoginAndRegistViewController:LoginViewDelegate{
    func btnLoginClick() {
        weak var weakSelf=self
        let userName:String = (weakSelf!.loginView!.textFieldUserName.text)!
        let password:String = (weakSelf!.loginView!.textFieldPassword.text!)
        if(userName.isEmpty){
            print("当前线程 LoginViewController_toLogin \(Thread.current)")
            AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "手机号不能为空")
        }
        else if(password.isEmpty){
            AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "密码不能为空")
        }
        else{
            AlertUtil.sharedInstance.showWaitDialog(message: "正在登录中...")
            UserBiz.sharedInstance.toLogin(username: userName, password: password) { (responseBean) in
                if(responseBean.success!){
                   //getStaffInfo获取用户信息
                    UserBiz.sharedInstance.getStaffInfo(loginId: staff!.user!.loginId!) { (getUserInfoResponseBean) in
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.closeWaitDialog()//关闭提示消息
                        }
                        if(getUserInfoResponseBean.success!){
                            DispatchQueue.main.async {
                                if(weakSelf!.loginView != nil){
                                    weakSelf!.loginView?.removeFromSuperview()
                                    weakSelf!.loginView=nil
                                }
                                weakSelf!.dismiss(animated: true) {
                                    NotificationCenter.default.post(name: NotifyLoginSuccess, object: nil)
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.closeWaitDialog()
                        AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                    }
                }
            }
        }
    }
    
    
}
