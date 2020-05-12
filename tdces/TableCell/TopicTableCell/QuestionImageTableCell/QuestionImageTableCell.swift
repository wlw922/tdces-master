//
//  QuestionImageTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/10/29.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class QuestionImageTableCell: UITableViewCell {
    /// 课程名称
    @IBOutlet weak var imgQuestionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "QuestionImageTableCell 被销毁！！！")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    func setupWithBean(questionDetail : QuestionDetailBean) {
        if(questionDetail.questionImageUrl != nil){
            imgQuestionImage.kf.setImage(with: URL.init(string: questionDetail.questionImageUrl!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (result) in
            })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
