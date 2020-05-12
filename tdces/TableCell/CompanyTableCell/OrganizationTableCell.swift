//
//  CompanyTableCell.swift
//  tdces
//
//  Created by Str1ng on 2019/11/13.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
class OrganizationTableCell: UITableViewCell {

    @IBOutlet weak var labOrganizationName:UILabel!
    var organizationBean : OrganizationBean?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame=CGRect.init(x: 9, y: 0, width: 302, height: 44)
    }
    
    
    
    func setupWithBean(organization : OrganizationBean) {
        self.organizationBean = organization
        
        labOrganizationName.text = organization.name!
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
}
