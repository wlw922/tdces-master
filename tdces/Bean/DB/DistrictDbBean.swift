////
////  DistrictDbBean.swift
////  tdces
////
////  Created by Str1ng on 2019/12/16.
////  Copyright © 2019 gmcx. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//class DistrictDbBean: Object {
//    @objc dynamic var id = NSUUID.init().uuidString
//    @objc dynamic var districtName:String?//null,
//    @objc dynamic var districtId:Int=0//360100,
//    @objc dynamic var RecordTime:String=DateUtil().getDateNow(dateFormat: DateUtil.CUSTOM_PATTERN)
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//    
//    override class func indexedProperties() -> [String] {
//        return ["districtId"]
//    }
//}
