//
//  ConditionDelegate.swift
//  CarManagementCommon
//
//  Created by Str1ng on 2017/4/20.
//  Copyright © 2017年 gmcx. All rights reserved.
//

import Foundation
import UIKit

protocol ConditionDelegate:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
}
