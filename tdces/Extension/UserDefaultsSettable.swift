
//
//  UserDefaultsSettable.swift
//  CarManagement
//
//  Created by 刘湘 on 2018/6/29.
//  Copyright © 2018年 gmcx. All rights reserved.
//

import Foundation
protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue==String {
    
    static func set(value: String?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    
    static func set(value: Bool? , forKey key: defaultKeys){
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    
    static func bool(forkey key:defaultKeys) -> Bool?{
        let aKey = key.rawValue
        return UserDefaults.standard.bool(forKey: aKey)
    }
    
    static func string(forKey key: defaultKeys) -> String? {
        let aKey = key.rawValue
        return UserDefaults.standard.string(forKey: aKey)
    }
    
    static func remove(forKey key: defaultKeys){
        let aKey = key.rawValue
        UserDefaults.standard.removeObject(forKey: aKey)
    }
}



