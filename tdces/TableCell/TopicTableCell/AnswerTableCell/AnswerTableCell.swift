//
//  AnswerTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/10/29.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class AnswerTableCell: UITableViewCell {
    ///
    @IBOutlet weak var btnCheck:UIButton!
    
    @IBOutlet weak var labAnswer:UILabel!
    var isCheck:Bool=false
    var questionDetail : QuestionDetailBean?
    @IBAction func checkAnswer(){
        if(isCheck){
            isCheck = false
            self.btnCheck.setBackgroundImage(UIImage.init(named: "icon_checkbox_blank"), for: UIControl.State.normal)
        }
        else{
            isCheck = true
            self.btnCheck.setBackgroundImage(UIImage.init(named: "icon_checkbox_check"), for: UIControl.State.normal)
        }
        questionDetail?.answer?.isCheck = isCheck
        NotificationCenter.default.post(name: NotifyAnswerChange, object: questionDetail)
    }
    deinit {
        LogUtil.sharedInstance.printLog(message: "AnswerTableCell 被销毁！！！")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    
    
    func setupWithBean(questionDetail : QuestionDetailBean) {
        self.questionDetail = questionDetail
        if(questionDetail.answer != nil){
            if(questionDetail.answer?.content != nil){
                if(!(questionDetail.answer?.content)!.isEmpty){
                    labAnswer.text=questionDetail.answer?.content!
                }
            }
            isCheck = questionDetail.answer!.isCheck
            if(questionDetail.answer!.isCheck){
                self.btnCheck.setBackgroundImage(UIImage.init(named: "icon_checkbox_check"), for: UIControl.State.normal)
            }
        }
    }
    
    override func prepareForReuse() {
        self.btnCheck.setBackgroundImage(UIImage.init(named: "icon_checkbox_blank"), for: UIControl.State.normal)
        super.prepareForReuse()
    }
}
