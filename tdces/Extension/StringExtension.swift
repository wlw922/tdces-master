//
//  StringExtension.swift
//  CarManagement
//
//  Created by Str1ng on 4/26/19.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return String(format: hash as String)
    }
    
    var isTelphone:Bool {
        let mobile = "^((13[0-9])|(14[0-9])|(15[0-9])|(17[0,0-9])|(18[0,0-9])|(19[0,0-9]))\\d{8}$"
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if (regextestmobile.evaluate(with: self) == true)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    var isIDCardNumber:Bool{
        let value = self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        var length = 0
        if value == ""{
            return false
        }else{
            length = value.count
            
            if length != 15 && length != 18{
                return false
            }
        }
        
        //省份代码
        let arearsArray = ["11","12", "13", "14",  "15", "21",  "22", "23",  "31", "32",  "33", "34",  "35", "36",  "37", "41",  "42", "43",  "44", "45",  "46", "50",  "51", "52",  "53", "54",  "61", "62",  "63", "64",  "65", "71",  "81", "82",  "91"]
        let valueStart2 = (value as NSString).substring(to: 2)
        var arareFlag = false
        if arearsArray.contains(valueStart2){
            
            arareFlag = true
        }
        if !arareFlag{
            return false
        }
        var regularExpression = NSRegularExpression()
        
        var numberofMatch = Int()
        var year = 0
        switch (length){
        case 15:
            year = Int((value as NSString).substring(with: NSRange(location:6,length:2)))!
            if year%4 == 0 || (year%100 == 0 && year%4 == 0){
                do{
                    regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive) //检测出生日期的合法性
                    
                }catch{
                    
                    
                }
                
                
            }else{
                do{
                    regularExpression =  try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{}
            }
            
            numberofMatch = regularExpression.numberOfMatches(in: value, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, value.count))
            
            if(numberofMatch > 0) {
                return true
            }else {
                return false
            }
            
        case 18:
            year = Int((value as NSString).substring(with: NSRange(location:6,length:4)))!
            if year%4 == 0 || (year%100 == 0 && year%4 == 0){
                do{
                    regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{
                    
                }
            }else{
                do{
                    regularExpression =  try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{}
            }
            
            numberofMatch = regularExpression.numberOfMatches(in: value, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, value.count))
            
            if(numberofMatch > 0) {
                let s1 = (Int((value as NSString).substring(with: NSRange(location:0,length:1)))! +
                    Int((value as NSString).substring(with: NSRange(location:10,length:1)))!) * 7
                let s2 = (Int((value as NSString).substring(with: NSRange(location:1,length:1)))! +
                    Int((value as NSString).substring(with: NSRange(location:11,length:1)))!) * 9
                let s3 = (Int((value as NSString).substring(with: NSRange(location:2,length:1)))! +
                    Int((value as NSString).substring(with: NSRange(location:12,length:1)))!) * 10
                let s4 = (Int((value as NSString).substring(with: NSRange(location:3,length:1)))! +
                    Int((value as NSString).substring(with: NSRange(location:13,length:1)))!) * 5
                let s5 = (Int((value as NSString).substring(with: NSRange(location:4,length:1)))! +
                    Int((value as NSString).substring(with: NSRange(location:14,length:1)))!) * 8
                let s6 = (Int((value as NSString).substring(with: NSRange(location:5,length:1)))! +
                    Int((value as NSString).substring(with: NSRange(location:15,length:1)))!) * 4
                let s7 = (Int((value as NSString).substring(with: NSRange(location:6,length:1)))! +
                    Int((value as NSString).substring(with: NSRange(location:16,length:1)))!) *  2
                let s8 = Int((value as NSString).substring(with: NSRange(location:7,length:1)))! * 1
                let s9 = Int((value as NSString).substring(with: NSRange(location:8,length:1)))! * 6
                let s10 = Int((value as NSString).substring(with: NSRange(location:9,length:1)))! * 3
                let s = s1 + s2 + s3 + s4 + s5 + s6 + s7 + s8 + s9 + s10
                let Y = s%11
                var M = "F"
                let JYM = "10X98765432"
                
                M = (JYM as NSString).substring(with: NSRange(location:Y,length:1))
                if M == (value as NSString).substring(with: NSRange(location:17,length:1))
                {
                    return true
                }else{return false}
                
                
            }else {
                return false
            }
            
        default:
            return false
        }
    }
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
}
