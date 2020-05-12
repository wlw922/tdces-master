//
//  StaffBean.swift
//  tdces
//
//  Created by Str1ng on 2019/11/1.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class StaffBean: BaseBean{
    var id : Int?
    var idNumber:String?
    var sex:Int?
    var name:String?
    var mobile:String?
    var birthday:String?
    var user:UserBean?
    var staffCert:StaffCertBean?
    var attachments:[AttachmentBean]?
    required init(json: JSON) {
        super.init(json: json)
        id = json["id"].int
        idNumber = json["idNumber"].string
        sex = json["sex"].int
        name  = json["name"].string
        mobile  = json["mobile"].string
        birthday  = json["birthday"].string
        user = UserBean.init(json: json["user"])
        staffCert = StaffCertBean.init(json: json["staffCert"])
        attachments=[AttachmentBean].init()
        
        let attachmentsJson = json["attachments"].array
        for attachmentJson in attachmentsJson!{
            let attachmentBean = AttachmentBean.init(json: attachmentJson)
            attachments?.append(attachmentBean)
        }
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}
