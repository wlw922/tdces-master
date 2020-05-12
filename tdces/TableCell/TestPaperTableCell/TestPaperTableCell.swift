//
//  ScoreTableCell.swift
//  tdces
//
//  Created by Str1ng on 2020/1/14.
//  Copyright © 2020 gmcx. All rights reserved.
//

import Foundation
class TestPaperTableCell: UITableViewCell {
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
       // labPaperName.text = "客户端4月23日电 (上官云)针对五一是否可以小范围进行旅游的问题，23日，中国疾控中心研究员冯录召在发布会上介绍，对于大部分近期没有病例报告的地区，出去旅行还是比较安全的，但对老年人、慢性病患者、孕妇这些高危人群不建议出行旅游。出行人员要注意预防，一是出行前做好准备，建议就近错峰出游；第二，途中要做好防护；第三，旅行期间要做好防护。"
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
