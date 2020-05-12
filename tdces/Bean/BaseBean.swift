//
//  BaseBean.swift
//  CarManagementCommon
//
//  Created by Str1ng on 2017/4/20.
//  Copyright © 2017年 gmcx. All rights reserved.
//
import SwiftyJSON
import RealmSwift
protocol BaseBeanDelegate {
    
}
class BaseBean:Object{
    required init(json:JSON){
        
    }
    required init(){
        
    }
}
