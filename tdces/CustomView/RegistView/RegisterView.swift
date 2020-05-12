//
//  RegisterView.swift
//  tdces
//
//  Created by Str1ng on 2019/11/5.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import RealmSwift

protocol RegisterViewDelegate {
    func imgPhotoClick()
    func imgIdNumberPhotoClick()
    func imgCertificatePhotoClick()
    func btnRegisterClick()
//    func btnShowTrainCategoryViewClick()
    func btnShowOrganizationViewClick()
}

class RegisterView: UIView {
    @IBOutlet weak var textFieldIdNumber:UITextField!
//    @IBOutlet weak var textFieldPassword:UITextField!
//    @IBOutlet weak var textFieldRepeatPassword:UITextField!
    @IBOutlet weak var textFieldUserName:UITextField!
//    @IBOutlet weak var btnSexMale:UIButton!
//    @IBOutlet weak var btnSexFeMale:UIButton!
//    @IBOutlet weak var textFieldBirthday:SelectionTextField!
//    @IBOutlet weak var textFieldMobile:UITextField!
    @IBOutlet weak var textFieldAddressArea:SelectionTextField!
//    @IBOutlet weak var textFieldAddress:UITextField!
    @IBOutlet weak var textFieldOrganization:UITextField!
//    @IBOutlet weak var textFieldCertificateId:UITextField!
//    @IBOutlet weak var textFieldTrainCategory:SelectionTextField!
//    @IBOutlet weak var textFieldFirstDate:SelectionTextField!
//    @IBOutlet weak var textFieldEffectDate:SelectionTextField!
//    @IBOutlet weak var textFieldExpireDate:SelectionTextField!
    @IBOutlet weak var textFieldArea:SelectionTextField!
    @IBOutlet weak var imgPhoto:UIImageView!
    @IBOutlet weak var imgIdNumberPhoto:UIImageView!
    @IBOutlet weak var imgCertificatePhoto:UIImageView!
    @IBOutlet weak var btnRegister:UIButton!
//    @IBOutlet weak var btnShowTrainCategoryView:UIButton!
    @IBOutlet weak var btnShowOrganizationView:UIButton!
    
    var delegate:RegisterViewDelegate?
//    var isMale:Bool=false
//    var isFeMale:Bool=false
//    var sex:String=""
//    var birthday:String=""
//    var firstDate:String=""
//    var effectDate:String=""
//    var expireDate:String=""
    var addressRegion:String=""
    var addressRegionList:[String]=[String].init()
    var areaId:String=""
    var areaData:[String]=[String].init()
    var textFieldAreaSelectedIndex:Int?
    
    let realm = try! Realm()
    
    //初始化默认属性配置
    func initialSetup(){

        weak var weakSelf = self
//        self.textFieldBirthday.showDatePicker("日期" ,autoSetSelectedText: false) { (textfield, date) in
//            self.birthday=DateUtil().dateConvertString(date: date, dateFormat: DateUtil.DATE_PATTERN)
//            textfield.text=self.birthday
//        }
//        self.textFieldFirstDate.showDatePicker("日期",autoSetSelectedText: false) { (textfield, date) in
//            self.firstDate=DateUtil().dateConvertString(date: date, dateFormat: DateUtil.DATE_PATTERN)
//            textfield.text=self.firstDate
//        }
//        self.textFieldEffectDate.showDatePicker("日期",autoSetSelectedText: false) { (textfield, date) in
//            self.effectDate=DateUtil().dateConvertString(date: date, dateFormat: DateUtil.DATE_PATTERN)
//            textfield.text=self.effectDate
//        }
//        self.textFieldExpireDate.showDatePicker("日期",autoSetSelectedText: false) { (textfield, date) in
//            self.expireDate=DateUtil().dateConvertString(date: date, dateFormat: DateUtil.DATE_PATTERN)
//            textfield.text=self.expireDate
//        }
        //获取注册的区域列表
        CommonBiz.sharedInstance.getLicensedFullArea { (responseBean) in
            if(responseBean.success!){
                 
                let areaList = responseBean.result as! [AreaBean]
               
                for area in areaList{
                  
                    weakSelf!.areaData.append(area.areaName!)
                    
                }
                print("所属区域列表：\(weakSelf!.areaData)")
                               weakSelf!.textFieldArea.showSingleColPicker("所在区域", data: weakSelf!.areaData, defaultSelectedIndex: nil, autoSetSelectedText: true) { (txtf, selectedIndex, selectedValue) in
                    weakSelf!.textFieldAreaSelectedIndex=selectedIndex
                    weakSelf!.areaId=String((areaList[selectedIndex].id)!)
                    txtf.text = selectedValue
                  print("")
                }
            }
        }
        let areas = realm.objects(AreaDbBean.self).filter("areaType = 1")
        
        if(areas.count>0){
            var AreaList:[[[String: [String]?]]]=[[[String: [String]?]]].init()
            var provinceCityList:[[String: [String]?]] = [[String: [String]?]].init()
            var cityDistrictList:[[String: [String]?]] = [[String: [String]?]].init()
            for province in areas{
                var provinceCity:[String: [String]?]=[String: [String]?].init()
                var cityList:[String] = [String].init()
                
                if(province.children.count>0){
                   // print("provinceCity是：\(province.children)")
                    for city in province.children{
                       // print("city是：\(city)")
                        var cityDistrict:[String: [String]?]=[String: [String]?].init()
                        var districtList:[String] = [String].init()
                        if(city.children.count>0){
                          //  print("city.children是：\(city.children)")
                            for district in city.children{
                                districtList.append(district.areaName!)
                            }
                        }
                        cityDistrict=[city.areaName!:districtList]
                        cityDistrictList.append(cityDistrict)
                        cityList.append(city.areaName!)
                    }
                }
                provinceCity=[province.areaName!:cityList]
                provinceCityList.append(provinceCity)
            }
            AreaList.append(provinceCityList)
            AreaList.append(cityDistrictList)
            // print("所属地区省市区是：\(AreaList)")
            weakSelf!.textFieldAddressArea.showMultipleAssociatedColsPicker("请选择", data: AreaList, defaultSelectedValues: nil, autoSetSelectedText: false) { (txtf, index, value) in
                weakSelf!.addressRegionList.removeAll()
                var addressAreaString = ""
                var provinceBean:AreaDbBean?
                var cityBean:AreaDbBean?
                var districtBean:AreaDbBean?
                for areaValue in value{
                    addressAreaString.append(areaValue)
                    if(provinceBean == nil){
                        provinceBean = areas.first(where: { (areaBean) -> Bool in
                            if(areaBean.areaName == areaValue){
                                return true
                            }else{
                                return false
                            }
                        })
                        weakSelf!.addressRegionList.append(String((provinceBean?.areaId)!))
                    }
                    else{
                        if(cityBean == nil){
                            cityBean = provinceBean?.children.first(where: { (areaBean) -> Bool in
                                if(areaBean.areaName == areaValue){
                                    return true
                                }else{
                                    return false
                                }
                            })
                            weakSelf!.addressRegionList.append(String((cityBean?.areaId)!))
                        }else{
                            if(districtBean == nil){
                                districtBean = cityBean?.children.first(where: { (areaBean) -> Bool in
                                    if(areaBean.areaName == areaValue){
                                        return true
                                    }else{
                                        return false
                                    }
                                })
                                weakSelf!.addressRegion=String((districtBean?.areaId)!)
                                weakSelf!.addressRegionList.append(String((districtBean?.areaId)!))
                            }
                        }
                    }
                }
                txtf.text=addressAreaString
                print("")
            }
        }
//        DispatchQueue.main.async {
//            AlertUtil.sharedInstance.showWaitDialog(message: "获取区域数据中，请稍等")
//        }
//        CommonBiz.sharedInstance.getFullAreaList { (responseBean) in
//            DispatchQueue.main.async {
//                AlertUtil.sharedInstance.closeWaitDialog()
//            }
//            if(responseBean.success!){
//                let data:[AreaBean] = responseBean.result as! [AreaBean]
//                if(data.count > 0){
//                    var AreaList:[[[String: [String]?]]]=[[[String: [String]?]]].init()
//                    var provinceCityList:[[String: [String]?]] = [[String: [String]?]].init()
//                    var cityDistrictList:[[String: [String]?]] = [[String: [String]?]].init()
//                    for province in data{
//                        var provinceCity:[String: [String]?]=[String: [String]?].init()
//                        var cityList:[String] = [String].init()
//                        if(province.children != nil){
//                            for city in province.children!{
//                                var cityDistrict:[String: [String]?]=[String: [String]?].init()
//                                var districtList:[String] = [String].init()
//                                if(city.children != nil){
//                                    for district in city.children!{
//                                        districtList.append(district.areaName!)
//                                    }
//                                }
//                                cityDistrict=[city.areaName!:districtList]
//                                cityDistrictList.append(cityDistrict)
//                                cityList.append(city.areaName!)
//                            }
//                        }
//                        provinceCity=[province.areaName!:cityList]
//                        provinceCityList.append(provinceCity)
//                    }
//                    AreaList.append(provinceCityList)
//                    AreaList.append(cityDistrictList)
//                    self.textFieldAddressArea.showMultipleAssociatedColsPicker("请选择", data: AreaList, defaultSelectedValues: nil, autoSetSelectedText: false) { (txtf, index, value) in
//
//                        var addressAreaString = ""
//                        var provinceBean:AreaBean?
//                        var cityBean:AreaBean?
//                        var districtBean:AreaBean?
//                        for areaValue in value{
//                            addressAreaString.append(areaValue)
//                            if(provinceBean == nil){
//                                provinceBean = data.first(where: { (areaBean) -> Bool in
//                                    if(areaBean.areaName == areaValue){
//                                        return true
//                                    }else{
//                                        return false
//                                    }
//                                })
//                                self.addressRegionList.append(String((provinceBean?.id)!))
//                            }
//                            else{
//                                if(cityBean == nil){
//                                    cityBean = provinceBean?.children?.first(where: { (areaBean) -> Bool in
//                                        if(areaBean.areaName == areaValue){
//                                            return true
//                                        }else{
//                                            return false
//                                        }
//                                    })
//                                    self.addressRegionList.append(String((cityBean?.id)!))
//                                }else{
//                                    if(districtBean == nil){
//                                        districtBean = cityBean?.children?.first(where: { (areaBean) -> Bool in
//                                            if(areaBean.areaName == areaValue){
//                                                return true
//                                            }else{
//                                                return false
//                                            }
//                                        })
//                                        self.addressRegion=String((districtBean?.id)!)
//                                        self.addressRegionList.append(String((districtBean?.id)!))
//                                    }
//                                }
//                            }
//                        }
//                        txtf.text=addressAreaString
//                    }
//                }
//
//            }
//        }
//        self.getAreaData()
    }
    var contentView:UIView!
    
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        //初始化属性配置
        initialSetup()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        //初始化属性配置
        initialSetup()
    }
    //加载xib
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle.init(for: className)
        let name =  NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    
    //设置好xib视图约束
    func addConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: contentView as Any, attribute: .leading,
                                            relatedBy: .equal, toItem: self, attribute: .leading,
                                            multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView as Any, attribute: .trailing,
                                        relatedBy: .equal, toItem: self, attribute: .trailing,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView as Any, attribute: .top, relatedBy: .equal,
                                        toItem: self, attribute: .top, multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView as Any, attribute: .bottom,
                                        relatedBy: .equal, toItem: self, attribute: .bottom,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
    }
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "RegisterView 被销毁！！！！！！！！")
    }

    
}
// MARK: IBAction
extension RegisterView{
    @IBAction func viewClick(sender: AnyObject) {
        textFieldUserName?.resignFirstResponder()
//        textFieldPassword?.resignFirstResponder()
//        textFieldRepeatPassword?.resignFirstResponder()
        textFieldUserName?.resignFirstResponder()
//        textFieldBirthday?.resignFirstResponder()
//        textFieldMobile?.resignFirstResponder()
//        textFieldAddressArea?.resignFirstResponder()
//        textFieldAddress?.resignFirstResponder()
//        textFieldCertificateId?.resignFirstResponder()
//        textFieldTrainCategory?.resignFirstResponder()
//        textFieldFirstDate?.resignFirstResponder()
//        textFieldEffectDate?.resignFirstResponder()
//        textFieldExpireDate?.resignFirstResponder()
        textFieldArea?.resignFirstResponder()
    }
    
//    @IBAction func btnFeMaleClick(){
//        if(isFeMale){
//            isMale=true
//            isFeMale=false
//            btnSexMale.setImage(UIImage.init(named: "icon_checkbox_check"), for: .normal)
//            btnSexFeMale.setImage(UIImage.init(named: "icon_checkbox_blank"), for: .normal)
//            self.sex="0"
//        }else{
//            isMale=false
//            isFeMale=true
//            btnSexMale.setImage(UIImage.init(named: "icon_checkbox_blank"), for: .normal)
//            btnSexFeMale.setImage(UIImage.init(named: "icon_checkbox_check"), for: .normal)
//            self.sex="1"
//        }
//    }
    
    @IBAction func btnRegisterClick(){
        delegate?.btnRegisterClick()
    }
    
    @IBAction func btnUserPhotoClick(){
        delegate?.imgPhotoClick()
    }
    @IBAction func btnIdNumberPhotoClick(){
        delegate?.imgIdNumberPhotoClick()
    }
    @IBAction func btnCertificatePhotoClick(){
        delegate?.imgCertificatePhotoClick()
    }
    
//    @IBAction func btnMaleClick(){
//        if(isMale){
//            isMale=false
//            isFeMale=true
//            btnSexMale.setImage(UIImage.init(named: "icon_checkbox_blank"), for: .normal)
//            btnSexFeMale.setImage(UIImage.init(named: "icon_checkbox_check"), for: .normal)
//            self.sex="1"
//        }else{
//            isMale=true
//            isFeMale=false
//            btnSexMale.setImage(UIImage.init(named: "icon_checkbox_check"), for: .normal)
//            btnSexFeMale.setImage(UIImage.init(named: "icon_checkbox_blank"), for: .normal)
//            self.sex="0"
//        }
//    }
    
//    @IBAction func btnShowTrainCategoryViewClick(){
//        delegate?.btnShowTrainCategoryViewClick()
//    }
    
    @IBAction func btnShowOrganizationViewClick(){
        delegate?.btnShowOrganizationViewClick()
    }
}
