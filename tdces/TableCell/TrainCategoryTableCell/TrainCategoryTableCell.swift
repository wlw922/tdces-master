//
//  TrainCategoryTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/11/6.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class TrainCategoryTableCell: UITableViewCell {
    ///
    @IBOutlet weak var btnCheck:UIButton!
    
    @IBOutlet weak var labTrainCategory:UILabel!
    var isCheck:Bool=false
    var trainCategory : TrainCategoryBean?
    @IBAction func checkTrainCategory(){
        if(isCheck){
            isCheck = false
//            self.btnCheck.setBackgroundImage(UIImage.init(named: "icon_checkbox_blank"), for: UIControl.State.normal)
        }
        else{
            isCheck = true
//            self.btnCheck.setBackgroundImage(UIImage.init(named: "icon_checkbox_check"), for: UIControl.State.normal)
        }
        trainCategory?.isCheck = isCheck
        NotificationCenter.default.post(name: NotifyTrainCategoryCheckChange, object: trainCategory)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    
    
    func setupWithBean(trainCategory : TrainCategoryBean) {
        self.trainCategory = trainCategory
        isCheck = trainCategory.isCheck
        if(isCheck){
            self.btnCheck.setBackgroundImage(UIImage.init(named: "icon_checkbox_check"), for: UIControl.State.normal)
        }else{
            self.btnCheck.setBackgroundImage(UIImage.init(named: "icon_checkbox_blank"), for: UIControl.State.normal)
        }
        labTrainCategory.text = trainCategory.TrainCategoryString
    }
    
    override func prepareForReuse() {
        self.btnCheck.setBackgroundImage(UIImage.init(named: "icon_checkbox_blank"), for: UIControl.State.normal)
        super.prepareForReuse()
    }
    
    
}
