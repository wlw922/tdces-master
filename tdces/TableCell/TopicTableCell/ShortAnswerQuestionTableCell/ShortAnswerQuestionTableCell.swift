//
//  ShortAnswerQuestionTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/10/31.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class ShortAnswerQuestionTableCell: UITableViewCell {
    /// 课程名称
//    @IBOutlet weak var txtfAnswer: UITextView!
    var txtfAnswer:UITextView?
    var questionDetail : QuestionDetailBean?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "ShortAnswerQuestionTableCell 被销毁！！！")
    }
    func setupWithBean(questionDetail : QuestionDetailBean) {
        txtfAnswer = UITextView.init()
        txtfAnswer?.layer.cornerRadius = 5
        txtfAnswer?.layer.borderWidth = 0.5
        txtfAnswer?.layer.borderColor = UIColor.lightGray.cgColor
        //        txtfAnswer.delegate = self
        self.questionDetail = questionDetail
        if(questionDetail.shortAnswer != nil){
            txtfAnswer!.text = questionDetail.shortAnswer
        }else{
            txtfAnswer!.text = ""
        }
        txtfAnswer?.delegate = self
        self.contentView.addSubview(txtfAnswer!)
        txtfAnswer!.translatesAutoresizingMaskIntoConstraints = false
        txtfAnswer!.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        txtfAnswer?.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        txtfAnswer!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        txtfAnswer!.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        txtfAnswer!.heightAnchor.constraint(equalToConstant: 128).isActive = true
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension ShortAnswerQuestionTableCell:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        questionDetail?.shortAnswer = textView.text
        NotificationCenter.default.post(name: NotifyAnswerChange, object: questionDetail)
    }
}
