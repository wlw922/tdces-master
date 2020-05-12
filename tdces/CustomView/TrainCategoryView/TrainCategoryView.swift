//
//  TrainCategoryView.swift
//  tdces
//
//  Created by Str1ng on 2019/11/6.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation

protocol TrainCategoryViewDelegate {
    func btnCommitClick(trainCategoryCheckList:[TrainCategoryBean])
}
/// Description
class TrainCategoryView: UIView {
    @IBOutlet weak var tableViewTrainCagegory:UITableView!
    @IBOutlet weak var btnCommit:UIButton!
    @IBOutlet weak var btnDismiss:UIButton!
    var trainCategoryList:[TrainCategoryBean]!
    var trainCategoryCheckList:[TrainCategoryBean]=[TrainCategoryBean].init()
    var contentView:UIView!
    var delegate:TrainCategoryViewDelegate?
    //初始化默认属性配置
    func initialSetup(){
        self.tableViewTrainCagegory.delegate = self
        self.tableViewTrainCagegory.dataSource = self
        initTableCell()
        initNotification()
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
        let trainCategoryTableCell = UINib.init(nibName: "TrainCategoryTableCell", bundle: nil)
        tableViewTrainCagegory?.register(trainCategoryTableCell, forCellReuseIdentifier: "TrainCategoryTableCell")
    }
    
    func refreshTableView(trainCategoryList:[TrainCategoryBean]){
        self.trainCategoryList = trainCategoryList
        DispatchQueue.main.async {
            self.tableViewTrainCagegory.reloadData()
        }
    }
    
    func initNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(noti:)), name: NotifyTrainCategoryCheckChange, object: nil)
    }
    
    @objc func getNotification(noti:Notification){
        switch noti.name {
        case NotifyTrainCategoryCheckChange:
            guard let trainCategory = noti.object as? TrainCategoryBean else{
                return
            }
            if(trainCategory.isCheck){
                if(trainCategoryCheckList.count == 3){
                    trainCategory.isCheck = false
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.showAutoDismissDialog(title: "温馨提示", message: "最多选择3种培训类型。", timeout: 2)
                    }
                }else{
                    //                    trainCategoryList.first { (trainCategoryBean) -> Bool in
                    //                        if(trainCategory.id == trainCategoryBean.id){
                    //                            return true
                    //                        }else{
                    //                            return false
                    //                        }
                    //                        }?.isCheck = trainCategory.isCheck
                    trainCategoryCheckList.append(trainCategory)
                }
            }else{
                //                trainCategoryList.first { (trainCategoryBean) -> Bool in
                //                if(trainCategory.id == trainCategoryBean.id){
                //                    return true
                //                }else{
                //                    return false
                //                }
                //                }?.isCheck = trainCategory.isCheck
                trainCategoryCheckList.removeAll { (trainCategoryBean) -> Bool in
                    if(trainCategoryBean.id == trainCategory.id){
                        return true
                    }else{
                        return false
                    }
                }
            }
            self.refreshTableView(trainCategoryList: self.trainCategoryList)
            
            break
        default:
            break
        }
    }
    
    @IBAction func btnDismissClick() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    @IBAction func btnCommitClick(){
        DispatchQueue.main.async {
            self.delegate?.btnCommitClick(trainCategoryCheckList: self.trainCategoryCheckList)
            self.removeFromSuperview()
        }
    }
    
}

extension TrainCategoryView:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(trainCategoryList != nil){
            return (trainCategoryList?.count)!
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        AlertUtil.sharedInstance.showWaitDialog(message: "努力加载数据中...")
        //        AlertUtil.sharedInstance.closeWaitDialog()
        //        DispatchQueue.main.async {
        //            self.goPlanView(train: self.trainList[indexPath.row])
        //        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier : String = "TrainCategoryTableCell"
        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrainCategoryTableCell
        let row=indexPath.row
        let trainCategory : TrainCategoryBean = trainCategoryList![row]
        cell.setupWithBean(trainCategory: trainCategory)
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
