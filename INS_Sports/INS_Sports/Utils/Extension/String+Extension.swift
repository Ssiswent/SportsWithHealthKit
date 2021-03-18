//
//  String+Extension.swift
//  Futures-0814
//
//  Created by Ssiswent on 2020/8/14.
//

import UIKit

// 计算发布时间
extension String
{
    func getPublishTimeStr() -> String
    {
        let publishDate = self.getDateFromTime()
        let todayDate = Date()
        let doubleDistance = todayDate.timeIntervalSince(publishDate)
        let integerDistance = Int(doubleDistance)
        let secondsInAnHour = 3600
        let secondsInAMinitue = 60
        let hoursInADay = 24
        let hoursBetweenDates = integerDistance / secondsInAnHour
        let minutesBetweenDates = integerDistance % secondsInAnHour / secondsInAMinitue
        let daysBetweenDates = hoursBetweenDates / hoursInADay
        
        let timeStr1 = String(format: "%ld小时%ld分钟前", hoursBetweenDates, minutesBetweenDates)
        let timeStr2 = String(format: "%ld分钟前", minutesBetweenDates)
        let timeStr3 = String(format: "%ld天前", daysBetweenDates)
        
        if hoursBetweenDates <= 0 {
            return timeStr2
        } else if hoursBetweenDates > 0 && hoursBetweenDates < 24 {
            return timeStr1
        } else {
            return timeStr3
        }
    }
    
    func getDateFromTime() -> Date {
        let dateformatter = DateFormatter()
        //自定义日期格式
        dateformatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss"
        let date = dateformatter.date(from: self)!
        return date
    }
}

// MARK: 截取字符串
extension String
{
    /// 截取到任意位置
    func subString(to: Int) -> String
    {
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    /// 从任意位置开始截取
    func subString(from: Int) -> String
    {
        let index: String.Index = self.index(startIndex, offsetBy: from)
        return String(self[index ..< endIndex])
    }
    /// 从任意位置开始截取到任意位置
    func subString(from: Int, to: Int) -> String
    {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    //使用下标截取到任意位置
    subscript(to: Int) -> String
    {
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    //使用下标从任意位置开始截取到任意位置
    subscript(from: Int, to: Int) -> String
    {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
}
