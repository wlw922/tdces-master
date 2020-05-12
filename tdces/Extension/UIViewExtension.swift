//
//  UIViewExtension.swift
//  CarManagementCommon
//
//  Created by Str1ng on 2017/8/14.
//  Copyright © 2017年 gmcx. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: bounds.width, height: bounds.height), false, 0.0)
            let context: CGContext = UIGraphicsGetCurrentContext()!
            layer.render(in: context)
            context.restoreGState()
            let theImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return theImage
        }
        
    }
    
   }
