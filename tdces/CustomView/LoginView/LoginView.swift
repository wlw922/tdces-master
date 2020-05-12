//
//  LoginView.swift
//  tdces
//
//  Created by Str1ng on 2019/10/16.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation

protocol LoginViewDelegate {
    func btnLoginClick()
}
class LoginView: UIView {
    @IBOutlet weak var textFieldUserName:UITextField!
    @IBOutlet weak var textFieldPassword:UITextField!
    @IBOutlet weak var btnLogin:UIButton!
    //    var btnLoginCallBack:(()->())?
    var delegate:LoginViewDelegate?
    //初始化默认属性配置
    func initialSetup(){
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
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        delegate?.btnLoginClick()
    }
    @IBAction func viewClick(sender: AnyObject) {
        textFieldUserName.resignFirstResponder()
        
        textFieldPassword.resignFirstResponder()
    }
    
    @IBAction func btnShowUserAgreement(){
        let userAgreement=UserAgreementView.init(frame: CGRect.init(x: 0, y: 0, width: (self.superview?.superview?.bounds.width)!, height: (self.superview?.superview?.bounds.height)!))
        
        self.superview?.superview?.addSubview(userAgreement)
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
        LogUtil.sharedInstance.printLog(message: "LoginView 被销毁！！！！！！！！")
    }
}
