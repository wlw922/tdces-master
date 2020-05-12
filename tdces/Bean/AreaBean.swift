//
//  AreaBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/18.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON

class AreaBean : BaseBean{
    var areaName:String?//null,
    var id:Int?//360100,
    var children:[AreaBean]?
   
//    var isDelete:String?//null,
//    var parent:String?//null,
//    var remarks:String?//null,
//    var createDate:String?//null,
//    var state:String?//null,
//    var pageSize:String?//0,
//    var pageNum:String?//0,
//    var updateDate:String?//null,
//    var areaType:String?//null,
//    var sortOrderBy:String?//null
    
    required init(json: JSON) {
        super.init(json: json)
        areaName = json["areaName"].string
        id=json["id"].int
        if(!json["children"].isEmpty){
            children=[AreaBean].init()
            for areaJson in json["children"].array!{
                let area:AreaBean = AreaBean.init(json: areaJson)
                children?.append(area)
            }
        }
    }
    
    required init(){
        super.init()
//        fatalError("init() has not been implemented")
    }
    
}
