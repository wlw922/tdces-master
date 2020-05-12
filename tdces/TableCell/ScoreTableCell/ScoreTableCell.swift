//
//  ScoreTableCell.swift
//  tdces
//
//  Created by Str1ng on 2020/1/14.
//  Copyright © 2020 gmcx. All rights reserved.
//

import Foundation
class ScoreTableCell: UITableViewCell {
    /// 试卷名称
    @IBOutlet var labPaperName: UILabel!
    
    @IBOutlet var labIsPassed: UILabel!
    @IBOutlet var labExamTime: UILabel!
    @IBOutlet var labScore: UILabel!
    var chapter:ChapterBean?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    func setupWithBean(transcriptBean : TranscriptBean) {
        labPaperName.text=transcriptBean.paper?.paperName!
        var passedString:String=""
        if(transcriptBean.isPassed!){
            passedString="已通过"
            labIsPassed.textColor = UIColor.green
        }else{
            
            passedString="未通过"
            labIsPassed.textColor = UIColor.red
        }
        labIsPassed.text = passedString
        labExamTime.text = transcriptBean.startTime!
        labScore.text = "\(String(transcriptBean.score!))分"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
