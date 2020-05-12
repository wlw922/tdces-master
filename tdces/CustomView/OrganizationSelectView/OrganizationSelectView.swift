//
//  CompanySelectView.swift
//  tdces
//
//  Created by Str1ng on 2019/11/13.
//  Copyright © 2019 gmcx. All rights reserved.
//

protocol OrganizationSelectViewDelegate {
    func tableViewSelectedAction(organization:OrganizationBean)
}

class OrganizationSelectView: UIView {
    @IBOutlet weak var searchBarOrganizationName:UISearchBar!
    @IBOutlet weak var tableViewOrganization:UITableView!
    var organizationList:[OrganizationBean]!
    var allOrganizationList:[OrganizationBean]?
    var contentView:UIView!
    var preSearchText:String=""
    var delegate:OrganizationSelectViewDelegate?
    //初始化默认属性配置
    func initialSetup(){
        self.tableViewOrganization.delegate = self
        self.tableViewOrganization.dataSource = self
        self.searchBarOrganizationName.delegate = self
        initTableCell()
        initNotification()
    }
    
    @IBAction func toDismiss(){
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
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
    
    func initTableCell(){
        let organizationTableCell = UINib.init(nibName: "OrganizationTableCell", bundle: nil)
        tableViewOrganization?.register(organizationTableCell, forCellReuseIdentifier: "OrganizationTableCell")
    }
    
    func setOrganizationList(organizationList:[OrganizationBean]){
        self.allOrganizationList = organizationList
        refreshTableView(organizationList: self.allOrganizationList!)
    }
    
    func refreshTableView(organizationList:[OrganizationBean]){
        self.organizationList = organizationList
        DispatchQueue.main.async {
            self.tableViewOrganization.reloadData()
        }
    }
    
    func initNotification(){
        
    }
    
    @objc func getNotification(noti:Notification){
        switch noti.name {
            
        default:
            break
        }
    }
    
    
    
}

extension OrganizationSelectView:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.organizationList != nil){
            return (organizationList?.count)!
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableViewSelectedAction(organization: self.organizationList[indexPath.row])
        self.removeFromSuperview()
        //        AlertUtil.sharedInstance.showWaitDialog(message: "努力加载数据中...")
        //        AlertUtil.sharedInstance.closeWaitDialog()
        //        DispatchQueue.main.async {
        //            self.goPlanView(train: self.trainList[indexPath.row])
        //        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier : String = "OrganizationTableCell"
        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OrganizationTableCell
        let row=indexPath.row
        let organization : OrganizationBean = organizationList![row]
        cell.setupWithBean(organization: organization)
        return cell
    }
    
    // 预测cell的高度
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }
    
    // 自动布局后cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension OrganizationSelectView:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if(searchText.count < 3){
            if(self.allOrganizationList != nil){
//                if(self.allOrganizationList!.count > 0){
//                    self.allOrganizationList!.removeAll()
//                    self.refreshTableView(organizationList: self.allOrganizationList!)
//                }
//                self.allOrganizationList = nil
                self.organizationList = [OrganizationBean].init()
                self.refreshTableView(organizationList: self.organizationList)
            }
            
        }else if(searchText.count == 3){
            if(preSearchText == searchText){
                if(self.allOrganizationList != nil){
                    self.refreshTableView(organizationList: self.allOrganizationList!)
                }else{
                    self.endEditing(true)
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.showWaitDialog(message: "获取企业列表中，请稍等...")
                    }
                    CommonBiz.sharedInstance.findEnterprisePage(name: searchText) { (responseBean) in
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.closeWaitDialog()
                        }
                        self.preSearchText = searchText
                        if(responseBean.success!){
                            let organizationList:[OrganizationBean]=responseBean.result as! [OrganizationBean]
                            self.allOrganizationList = organizationList
                            DispatchQueue.main.async {
                                self.refreshTableView(organizationList: organizationList)
                            }
                        }else{
                            DispatchQueue.main.async {
                                AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                            }
                        }
                    }
                }
            
            }else{
                self.endEditing(true)
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showWaitDialog(message: "获取企业列表中，请稍等...")
                }
                CommonBiz.sharedInstance.findEnterprisePage(name: searchText) { (responseBean) in
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.closeWaitDialog()
                    }
                    self.preSearchText = searchText
                    if(responseBean.success!){
                        let organizationList:[OrganizationBean]=responseBean.result as! [OrganizationBean]
                        self.allOrganizationList = organizationList
                        DispatchQueue.main.async {
                            self.refreshTableView(organizationList: organizationList)
                        }
                    }else{
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                        }
                    }
                }
            }
        }else{
            if(preSearchText == ""){
                self.endEditing(true)
                DispatchQueue.main.async {
                    AlertUtil.sharedInstance.showWaitDialog(message: "获取企业列表中，请稍等...")
                }
                CommonBiz.sharedInstance.findEnterprisePage(name: searchText) { (responseBean) in
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.closeWaitDialog()
                    }
                    self.preSearchText = searchText
                    if(responseBean.success!){
                        let organizationList:[OrganizationBean]=responseBean.result as! [OrganizationBean]
                        self.allOrganizationList = organizationList
                        DispatchQueue.main.async {
                            self.refreshTableView(organizationList: organizationList)
                        }
                    }else{
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                        }
                    }
                }
            }else{
                if(searchText.contains(preSearchText)){
                    if(self.allOrganizationList != nil){
                        if(preSearchText == searchText){
                            self.refreshTableView(organizationList: self.allOrganizationList!)
                        }else{
                            if(self.allOrganizationList!.count > 0){
                                self.organizationList = self.allOrganizationList!.filter({ (organizationBean) -> Bool in
                                    if((organizationBean.name?.contains(searchText))!){
                                        return true
                                    }else{
                                        return false
                                    }
                                })
                                self.refreshTableView(organizationList: organizationList)
                            }else{
                                DispatchQueue.main.async {
                                    AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "未查询到此关键字相关企业，请修改查询条件。")
                                }
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "未查询到此关键字相关企业，请修改查询条件。")
                        }
                    }
                }else{
                    self.endEditing(true)
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.showWaitDialog(message: "获取企业列表中，请稍等...")
                    }
                    CommonBiz.sharedInstance.findEnterprisePage(name: searchText) { (responseBean) in
                        DispatchQueue.main.async {
                            AlertUtil.sharedInstance.closeWaitDialog()
                        }
                        self.preSearchText = searchText
                        if(responseBean.success!){
                            let organizationList:[OrganizationBean]=responseBean.result as! [OrganizationBean]
                            self.allOrganizationList = organizationList
                            DispatchQueue.main.async {
                                self.refreshTableView(organizationList: organizationList)
                            }
                        }else{
                            DispatchQueue.main.async {
                                AlertUtil.sharedInstance.showErrorAutoDismissDialog(message: responseBean.message!)
                            }
                        }
                    }
                }
            }
        }
    }
}
