//
//  DateUtil.swift
//  CarManagementCommon
//
//  Created by Str1ng on 2017/4/20.
//  Copyright © 2017年 gmcx. All rights reserved.
//

import Foundation


class DateUtil{
    
    /// yyyyMMddHHmmss
    static var METHOD_DATE_TIME_PATTERN = "yyyyMMddHHmmss";
    
    /// yyyy-MM-dd
    static var DATE_PATTERN = "yyyy-MM-dd"
    /// yyyy-MM
    static var MONTH_PATTERN = "yyyy-MM"
    /// yyyy/MM/dd
    static var WEEK_PATTERN = "yyyy/MM/dd"
    
    /// MM/dd
    static var SHORT_PATTERN = "MM/dd"
    
    /// yyyy-MM-dd 00:00:00
    static var NO_TIME_PATTERN = "yyyy-MM-dd 00:00:00"
    /// yyyy-MM-dd HH:mm:ss
    static var CUSTOM_PATTERN = "yyyy-MM-dd HH:mm:ss"
    static func getMothodDateTime() -> String{
        let zone:NSTimeZone = NSTimeZone(name: "Asia/Shanghai")!
        var date:NSDate = NSDate.init()
        let second:Int = zone.secondsFromGMT
        let second1:Int = NSTimeZone.local.secondsFromGMT(for: date as Date)
        date = date.addingTimeInterval(TimeInterval(second-second1))
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
        
//        let zone:NSTimeZone = NSTimeZone(name: "Asia/Shanghai")!
//        var date:NSDate = NSDate.init()
//        //        // 计算本地时区与 GMT 时区的时间差
//        let second:Int = zone.secondsFromGMT
//        let second1:Int = NSTimeZone.local.secondsFromGMT(for: date as Date)
//        date = date.addingTimeInterval(TimeInterval(second-second1))
//        //
//        let timeFormatter = DateFormatter.init()
//        timeFormatter.dateFormat=METHOD_DATE_TIME_PATTERN
//        return timeFormatter.string(from: date as Date)
    }
    
    func getNowTimeInterval()->String{
        //获取当前时间
        let now = Date()
        
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//        print("当前日期时间：\(dformatter.string(from: now))")
        
        //当前时间的时间戳
       
//        print("当前时间的时间戳：\(timeStamp)")
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
        
    }
    /// Date类型转化为日期字符串
    ///
    /// - Parameters:
    ///   - date: Date类型
    ///   - dateFormat: 格式化样式默认“yyyy-MM-dd”
    /// - Returns: 日期字符串
     func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    
    /// 日期字符串转化为Date类型
    ///
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - dateFormat: 格式化样式，默认为“yyyy-MM-dd HH:mm:ss”
    /// - Returns: Date类型
     func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date {
        let timeZone = TimeZone.init(identifier: "UTC")
        let dateFormatter = DateFormatter.init()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale.init(identifier: "zh_CN")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    func toDate(dateTimeString:String) -> Date{
        let timeFormatter = DateFormatter.init()
        timeFormatter.dateFormat = DateUtil.CUSTOM_PATTERN
        return timeFormatter.date(from: dateTimeString)!
    }
    
    func getTimeDifference(beginTime:String,endTime:String) -> String{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeDifference = Int(dateFormatter.date(from: endTime)!.timeIntervalSince1970 - dateFormatter.date(from: beginTime)!.timeIntervalSince1970)
        return self.getHHMMSSFormSS(seconds: timeDifference)
    }
    
    func getHHMMSSFormSS(seconds:Int) -> String {
        let str_hour = NSString(format: "%02ld", seconds/3600)
        let str_minute = NSString(format: "%02ld", (seconds%3600)/60)
        let str_second = NSString(format: "%02ld", seconds%60)
        let format_time = NSString(format: "%@:%@:%@",str_hour,str_minute,str_second)
        return format_time as String
    }
    
    func getDateNow(dateFormat:String) -> String{
        let timeZone = TimeZone.init(identifier: "UTC")
        let dateFormatter = DateFormatter.init()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale.init(identifier: "zh_CN")
        dateFormatter.dateFormat = dateFormat
        let date = Date.init()
        return dateFormatter.string(from: date)
    }
    
    func changeDateFormatter (dateString:String ,formDateFormatter:String,toDateFormatter:String ) -> String{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formDateFormatter
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = toDateFormatter
        return dateFormatter.string(from: date!)
    }
    
    func getDateComponents(dateComponents:DateComponents,dateFormat:String) -> String{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date=Date.init()
        let caclulatedDate = Calendar.current.date(byAdding: dateComponents, to: date)
        return dateFormatter.string(from: caclulatedDate!)
    }
    
    func getDateComponents(dateComponents:DateComponents,dateFormat:String,dateString:String) -> String{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date=dateFormatter.date(from: dateString)
        let caclulatedDate = Calendar.current.date(byAdding: dateComponents, to: date!)
        return dateFormatter.string(from: caclulatedDate!)
    }
    
    func getDateComponents(dateComponents:DateComponents,dateFormat:String,date:Date) -> String{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let caclulatedDate = Calendar.current.date(byAdding: dateComponents, to: date)
        return dateFormatter.string(from: caclulatedDate!)
    }
    
    //获取周
    func getWeekDay(year:Int,month:Int,day:Int) ->Int{
        let dateFormatter:DateFormatter = DateFormatter.init();
        dateFormatter.dateFormat = "yyyy/MM/dd";
        let date:Date = dateFormatter.date(from: String(format:"%04d/%02d/%02d",year,month,day))!;
        let calendar:Calendar = Calendar.current
//            var dateComp:DateComponents = calendar.components(NSCalendar.Unit.weekday, fromDate: date)
            return  calendar.component(Calendar.Component.weekday, from: date);
        
    }
    
    func weekDay() -> String {
        let weekDays = [NSNull.init(),"周日","周一","周二","周三","周四","周五","周六"] as [Any]
        let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        let timeZone = NSTimeZone.init(name: "Asia/Shanghai")
        calendar?.timeZone = timeZone! as TimeZone
        let calendarUnit = NSCalendar.Unit.weekday
        let theComponents = calendar?.components(calendarUnit, from: Date.init())
        return weekDays[(theComponents?.weekday)!] as! String
    }
    
    func weekDay(date:Date) -> String {
        let weekDays = [NSNull.init(),"周日","周一","周二","周三","周四","周五","周六"] as [Any]
        let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        let timeZone = NSTimeZone.init(name: "Asia/Shanghai")
        calendar?.timeZone = timeZone! as TimeZone
        let calendarUnit = NSCalendar.Unit.weekday
        let theComponents = calendar?.components(calendarUnit, from: date)
        return weekDays[(theComponents?.weekday)!] as! String
    }
    
}
