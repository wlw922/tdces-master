//
//  PlanDetailBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON

class PlanDetailBean {
    /// 1:chapter 2:material 3:paper
    var type:Int=0
    var serialNumber:String?
    var chapter:ChapterBean?
    var material:MaterialBean?
    var paper:PaperBean?
    
}
