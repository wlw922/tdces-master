//
//  MaterialTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation

class MaterialTableCell: UITableViewCell {
    /// 课程名称
    @IBOutlet weak var labMaterialTitle: UILabel!
    
    @IBOutlet weak var labSerialNumber: UILabel!
    
    @IBOutlet weak var imgMaterialType: UIImageView!
    @IBOutlet weak var labStauts:UILabel!
    var material:MaterialBean?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    func setupWithBean(materialBean : MaterialBean) {
        if(materialBean.name != nil){
           labMaterialTitle.text = materialBean.name
        }else{
            labMaterialTitle.text = ""
        }
        if(materialBean.materialFormat == 0){//视频
            imgMaterialType.image = UIImage.init(named: "icon_video")
        }else if(materialBean.materialFormat == 1){//文档
            
            imgMaterialType.image = UIImage.init(named: "icon_pdf")
        }
    }
    
    func setSerialNumber(serialNumber:String){
        labSerialNumber.text = serialNumber
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
