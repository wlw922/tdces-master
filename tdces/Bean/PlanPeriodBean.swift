//
//  PlanPeriodBean.swift
//  tdces
//
//  Created by Str1ng on 2019/11/25.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class PlanPeriodBean: BaseBean{
    var regId : Int?
    var examPeriodList:[ExamPeriodBean]?
    var materiaPeriodList:[MateriaPeriodBean]?
    required init(json: JSON) {
        super.init(json: json)
        regId = json["regId"].int
        
        examPeriodList=[ExamPeriodBean].init()
        let examPeriodListJson = json["exams"].array
        for examPeriodJson in examPeriodListJson!{
            let examPeriodBean = ExamPeriodBean.init(json: examPeriodJson)
            examPeriodList?.append(examPeriodBean)
        }
        
        materiaPeriodList=[MateriaPeriodBean].init()
        let materiaPeriodListJson = json["periods"].array
        for materiaPeriodJson in materiaPeriodListJson!{
            let materiaPeriodBean = MateriaPeriodBean.init(json: materiaPeriodJson)
            materiaPeriodList?.append(materiaPeriodBean)
        }
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}

class ExamPeriodBean: BaseBean{
    var score : Int?
    var beginTime:String?
    var paperId:Int?
    
    required init(json: JSON) {
        super.init(json: json)
        score = json["score"].int
        beginTime = json["beginTime"].string
        paperId = json["paperId"].int
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}

class MateriaPeriodBean: BaseBean{
    var watchDuration : Int?
    var totalDuration:Int?
    var materialId:Int?
    
    required init(json: JSON) {
        super.init(json: json)
        watchDuration = json["watchDuration"].int
        totalDuration = json["totalDuration"].int
        materialId = json["materialId"].int
    }
    
    required init(){
        super.init()
        //        fatalError("init() has not been implemented")
    }
    
}
