//
//  YOrNTableCell.swift
//  tdces
//
//  Created by MAC on 2020/4/24.
//  Copyright © 2020 gmcx. All rights reserved.
//

import UIKit

class YOrNTableCell: UITableViewCell {
    @IBOutlet weak var YorNQuestionLabel:UILabel!
 @IBOutlet weak var rightLabel:UILabel!
 @IBOutlet weak var errorLabel:UILabel!
@IBOutlet weak var userAnswer:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupWithBean(examContentBean : ExamContentBean) {
        weak var weakSelf=self
            var quesTypeStr:String?
           if(examContentBean.quesType == 0)
           {
             quesTypeStr = "单选题"
           }
           else if(examContentBean.quesType == 1)
           {
             quesTypeStr = "多选题"
           }
           else if(examContentBean.quesType == 2)
           {
               quesTypeStr = "判断题"
           }else
             {
               quesTypeStr = "简答题"
             }
   //问题
    weakSelf?.YorNQuestionLabel.text = "\(String(examContentBean.sn!))." + "[\(quesTypeStr!)]" + "\(String(examContentBean.question!))"
        
     //答案
        rightLabel.textColor = UIColor.black
        errorLabel.textColor = UIColor.black
        let examContentOptionsList:[ExamContentOptionsBean] = examContentBean.examContentOptionsList
        weakSelf?.rightLabel.text = "[\(String(examContentOptionsList[0].code!))]"
        if (examContentOptionsList[0].judge!)
        {
            weakSelf?.rightLabel.textColor = UIColor.red
        }
        weakSelf?.errorLabel.text = "[\(String(examContentOptionsList[1].code!))]"
        if (examContentOptionsList[1].judge!)
        {
            weakSelf?.errorLabel.textColor = UIColor.red
        }
  
    weakSelf?.userAnswer.text = "你的答案：" + "\(String(describing: examContentBean.userAnswer!))"
        weakSelf?.userAnswer.textColor = UIColor.red
        
   
    }
}
