//
//  MediaBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class MediaBean: BaseBean {
    var quality:String?//null,
    var url:String?//null,
    
    required init(json: JSON) {
        super.init(json: json)
        quality=json["quality"].string
        url=json["url"].string
    }
    
    required init(){
        super.init()
//        fatalError("init() has not been implemented")
    }
}
