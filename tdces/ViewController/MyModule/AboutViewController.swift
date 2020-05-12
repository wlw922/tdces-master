//
//  AboutViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/11/22.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class AboutViewController: UIViewController {
    @IBOutlet var labAppDisplayName:UILabel?
    @IBOutlet var labAppDescription:UILabel?
    @IBOutlet var labAppVersion:UILabel?
    deinit {
        LogUtil.sharedInstance.printLog(message: "AboutViewController 被销毁！！！！！！！！")
    }
}
extension AboutViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "关于我们"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
       let infoDictionary = Bundle.main.infoDictionary!
       labAppVersion?.text = "V" + (infoDictionary["CFBundleShortVersionString"] as? String)!//主程序版本号
       labAppDisplayName?.text = infoDictionary["CFBundleDisplayName"] as? String //程序名称
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
