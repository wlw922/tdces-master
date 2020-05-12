//
//  paperHistroyInformationTableCell.swift
//  tdces
//
//  Created by MAC on 2020/4/27.
//  Copyright © 2020 gmcx. All rights reserved.
//

import UIKit

class paperHistroyInformationTableCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIDNumberLabel: UILabel!
    @IBOutlet weak var StartTimeLabel: UILabel!
    @IBOutlet weak var TestScoreLabel: UILabel!
    @IBOutlet weak var isPassLabel: UILabel!
    @IBOutlet weak var bjView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupWithBean(transcriptBean: PaperHistroryBean) {
        
   // func setupWithBean() {
        weak var weakSelf=self
      
        weakSelf?.bjView.backgroundColor = UIColor.white
        weakSelf?.bjView.layer.borderWidth = 0.5;
        weakSelf?.bjView.layer.borderColor = UIColor.lightGray.cgColor
        
        weakSelf?.userNameLabel.text = transcriptBean.reg?.name
        weakSelf?.userIDNumberLabel.text = transcriptBean.reg?.idNumber
        weakSelf?.StartTimeLabel.text =  transcriptBean.startTime
        weakSelf?.TestScoreLabel.text = "\(String(transcriptBean.score!))分"
        if (transcriptBean.result != 0)
        {
          weakSelf?.isPassLabel.text = "通过"
          weakSelf?.isPassLabel.textColor = UIColor.green
        }
        else
        {
            weakSelf?.isPassLabel.text = "未通过"
            weakSelf?.isPassLabel.textColor = UIColor.red
        }
        
     
       }
}
