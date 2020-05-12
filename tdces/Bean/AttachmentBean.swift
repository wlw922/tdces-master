//
//  AttachmentBean.swift
//  tdces
//
//  Created by Str1ng on 2019/11/4.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class AttachmentBean: BaseBean{
    var id : Int?
    var relatedId:Int?
    var fileUrl:String?
    var category:Int?
    var attachType:String?
    required init(json: JSON) {
        super.init(json: json)
        id = json["id"].int
        fileUrl = json["fileUrl"].string
        relatedId = json["relatedId"].int
        category  = json["category"].int
        attachType  = json["attachType"].string
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}
