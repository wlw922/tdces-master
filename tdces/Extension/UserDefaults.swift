//
//  UserDefaults.swift
//  CarManagement
//
//  Created by 刘湘 on 2018/6/29.
//  Copyright © 2018年 gmcx. All rights reserved.
//

import Foundation

// MARK: - UserDefaults扩展
extension UserDefaults{
    struct LoginInfo:UserDefaultsSettable {
        enum defaultKeys:String {
            case userName
            case password
//            case openID
        }
    }
    
//    struct wxAccessInfo:UserDefaultsSettable{
//        enum defaultKeys:String {
//            case access_token
//            case refresh_token
//            case openID
//        }
//    }
//    
//    struct WXLoginInfo:UserDefaultsSettable{
//        enum defaultKeys:String {
//            case wxOpenID
//        }
//    }
    
    struct VersionInfo:UserDefaultsSettable{
        enum defaultKeys:String{
            case status
            case version
        }
    }
}
