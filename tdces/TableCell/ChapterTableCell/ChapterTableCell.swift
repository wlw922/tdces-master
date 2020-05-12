//
//  ChapterTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class ChapterTableCell: UITableViewCell {
    /// 课程名称
    @IBOutlet var labChapterTitle: UILabel!
    
    @IBOutlet var labSerialNumber: UILabel!
    var chapter:ChapterBean?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    func setupWithBean(chapterBean : ChapterBean) {
        if(chapterBean.chapterTitle != nil){
            labChapterTitle.text = chapterBean.chapterTitle
        }else{
            labChapterTitle.text = ""
        }
    }
    
    func setSerialNumber(serialNumber:String){
        labSerialNumber.text = serialNumber
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
