//
//  shortAnswerTableCell.swift
//  tdces
//
//  Created by MAC on 2020/4/27.
//  Copyright © 2020 gmcx. All rights reserved.
//

import UIKit

class shortAnswerTableCell: UITableViewCell {
    @IBOutlet weak var shortAnswerQuestionTitle: UILabel!
    @IBOutlet weak var userAnswerText: UILabel!
    @IBOutlet weak var rightAnswerText: UILabel!
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
    weakSelf?.shortAnswerQuestionTitle.text = "\(String(examContentBean.sn!))." + "[\(quesTypeStr!)]" + "\(String(examContentBean.question!))"
        
        weakSelf?.rightAnswerText.text = "标准答案：" + "\(String(describing: examContentBean.shortOptions!))"
    weakSelf?.userAnswerText.text = "你的答案：" + "\(String(examContentBean.shortuserAnswer!))"
    }
}
