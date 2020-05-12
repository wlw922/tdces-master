//
//  AreaDbBean.swift
//  tdces
//
//  Created by Str1ng on 2019/12/16.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import RealmSwift
class AreaDbBean: Object {
    @objc dynamic var id = NSUUID.init().uuidString
    @objc dynamic var areaName:String?//null,
    @objc dynamic var areaId:Int=0//360100,
    /// 1 省份 2市 3 区县
    @objc dynamic var areaType:Int=0
    let children = List<AreaDbBean>()
    @objc dynamic var RecordTime:String=DateUtil().getDateNow(dateFormat: DateUtil.CUSTOM_PATTERN)
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        
        return ["provinceId"]
    }
}
