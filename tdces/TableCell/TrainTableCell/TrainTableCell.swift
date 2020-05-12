//
//  TrainTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class TrainTableCell:UITableViewCell{
    /// 培训课程名称
    @IBOutlet weak var labTrainTitle: UILabel!
    /// 培训总课时
    @IBOutlet weak var labTotlePeriod: UILabel!
    /// 已学课时
    @IBOutlet weak var labAlreadyPeriod: UILabel!
    /// 批次
    @IBOutlet weak var labBatch: UILabel!
    /// 培训类型
    @IBOutlet weak var labTrainType: UILabel!
    /// 培训方式
    @IBOutlet weak var labTrainMethod: UILabel!
    /// 培训状态
    @IBOutlet weak var labTrainStatus:UILabel!
    /// 培训机构
    @IBOutlet weak var labTrainOrganization:UILabel!
    /// 开始时间
    @IBOutlet weak var labBeginTime:UILabel!
    /// 结束时间
    @IBOutlet weak var labEndTime:UILabel!
    //    @IBOutlet var imageViewCollect:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        weak var weakSelf=self
        weakSelf!.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    func setupWithBean(trainBean : TrainBean) {
        weak var weakSelf=self
        var titleName:String=""
        if(trainBean.regDate != nil){
            titleName.append(trainBean.regDate!.substring(from: 0, to: 3))
            titleName.append("年")
            titleName.append(trainBean.regDate!.substring(from: 5, to: 6))
            titleName.append("月报名")
        }
//        if(!trainBean.effectDate!.isEmpty){
//            titleName.append("\((trainBean.effectDate?.substring(from: 0, to: 3))!)年资格证")
//        }
//        if(trainBean.period != 0){
//            titleName.append("/第\(String(describing: (trainBean.period)!))周期")
//        }
//        if(!trainBean.regReason!.isEmpty){
//            titleName.append("/")
//            if(trainBean.regReason! == "1"){
//                titleName.append("两年到期")
//            }else if(trainBean.regReason! == "1"){
//                titleName.append("扣分逾期")
//            }else{
//                titleName.append("其他")
//            }
//        }
        weakSelf!.labTrainTitle.text =  titleName
        weakSelf!.labTrainType.text = trainBean.trainCategoryStr!
        weakSelf!.labTrainMethod.text = trainBean.teachingMethodStr!
        if(trainBean.org?.name != nil){
        weakSelf!.labTrainOrganization.text = trainBean.org?.name!
        }else{
            weakSelf!.labTrainOrganization.text = "-"
        }
        var liveline:String=""
        if(trainBean.liveline != nil){
            liveline=trainBean.liveline!
        }
        weakSelf!.labBeginTime.text = liveline
        var deadline:String=""
        if(trainBean.deadline != nil){
            deadline=trainBean.deadline!
        }
        weakSelf!.labEndTime.text = deadline
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
