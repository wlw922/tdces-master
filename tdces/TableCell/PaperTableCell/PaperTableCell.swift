//
//  PaperTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/10/22.
//  Copyright © 2019 gmcx. All rights reserved.
//


import Foundation

class PaperTableCell: UITableViewCell {
    /// 课程名称
    @IBOutlet var labPaperTitle: UILabel!
    
    @IBOutlet var labSerialNumber: UILabel!
    
    var paper:PaperBean?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    func setupWithBean(paperBean : PaperBean) {
        if(paperBean.paperName != nil){
            labPaperTitle.text = paperBean.paperName
        }else{
            labPaperTitle.text = ""
        }
    }
    
    func setSerialNumber(serialNumber:String){
        labSerialNumber.text = serialNumber
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

