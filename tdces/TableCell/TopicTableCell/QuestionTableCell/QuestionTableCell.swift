//
//  QuestionTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/10/29.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class QuestionTableCell: UITableViewCell {
    /// 课程名称
    @IBOutlet weak var labQuestionTitle: UILabel!
    var questionDetail:QuestionDetailBean?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "QuestionTableCell 被销毁！！！")
    }
    
    func setupWithBean(questionDetail : QuestionDetailBean) {
        weak var weakSelf=self
        weakSelf!.questionDetail = questionDetail
        /// 0-单选 1-多选 2-判断 3-简答
        var questionTypeString=""
        switch(questionDetail.quesType){
        case 0:
            questionTypeString="(单选题)"
            break
        case 1:
            questionTypeString="(多选题)"
            break
        case 2:
            questionTypeString="(判断题)"
            break
        case 3:
            questionTypeString="(简答题)"
            break
        default:
            break
        }
        if(questionDetail.question != nil){
            weakSelf!.labQuestionTitle.text = questionTypeString + questionDetail.question!
        }else{
            weakSelf!.labQuestionTitle.text = "-"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

