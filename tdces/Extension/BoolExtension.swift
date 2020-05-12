//
//  BoolExtension.swift
//  CarManagement
//
//  Created by 刘湘 on 2018/5/21.
//  Copyright © 2018年 gmcx. All rights reserved.
//

import Foundation
extension Bool {
    var intValue: Int {
        if self {
            return 1
        }
        else {
            return 0
        }
    }
}
