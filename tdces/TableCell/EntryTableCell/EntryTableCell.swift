//
//  EntryTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/10/28.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class EntryTableCell: UITableViewCell {
    /// 课程名称
    @IBOutlet weak var labCourseTitle: UILabel!
    
    @IBOutlet weak var imgCourseUrl: UIImageView!
    
    @IBOutlet weak var labTrainCategory:UILabel!
    @IBOutlet weak var labPrice:UILabel!
    @IBOutlet weak var labTrainReason:UILabel!
    @IBOutlet weak var labCourseDuration:UILabel!
//    var material:MaterialBean?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    func setupWithBean(courseBean : CourseBean) {
        labCourseTitle.text = (courseBean.courseName)!
        labTrainCategory.text = (courseBean.str)
        labCourseDuration.text = "\((courseBean.courseDuration)!)学时"
        if(courseBean.regReasonString != nil){
            labTrainReason.text = courseBean.regReasonString!
        }else{
            labTrainReason.text = "-"
        }
        imgCourseUrl.kf.setImage(with: URL.init(string: "http://114.116.157.104:9000/upload/\((courseBean.coursePhoto)!)"), placeholder: nil, options: nil, progressBlock: nil) { (result) in
        }
        if(WXApi.isWXAppInstalled()){
            labPrice.isHidden = false
            labPrice.text = "¥\((courseBean.price)!)"
        }else{
            labPrice.isHidden = true
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
