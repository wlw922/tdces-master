//
//  KnowledgePointBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/31.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class KnowledgePointBean: BaseBean{
    var knowledgePoint : String?
    
    
    required init(json: JSON) {
        super.init(json: json)
    }
    
    required init(){
        super.init()
//        fatalError("init() has not been implemented")
    }
    
}
