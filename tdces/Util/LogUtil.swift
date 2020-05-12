//
//  LogUtil.swift
//  CarManagement
//
//  Created by Str1ng on 2018/11/12.
//  Copyright © 2018 gmcx. All rights reserved.
//

import Foundation

class LogUtil {
    static let sharedInstance = LogUtil()
    private init(){
    }
    func printLog(message:Any) {
        #if DEBUG
        print("============================Str1ng's Debug============================")
        let dateformatter = DateFormatter.init()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss SSSS"
        print("\(dateformatter.string(from: Date.init()))")
        print(message)
        print("======================================================================")
        #endif
    }
}
