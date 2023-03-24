//
//  Extension+Date.swift
//  HZToolLib
//
//  Created by 权海 on 2023/3/24.
//

import Foundation

extension Date{
    /// SwifterSwift: User’s current calendar.
    var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier) // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
    }
    
    /// SwifterSwift: Year.
    ///
    ///        Date().year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.year = 2000 // sets someDate's year to 2000
    ///
    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Month.
    ///
    ///     Date().month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.month = 10 // sets someDate's month to 10.
    ///
    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Day.
    ///
    ///     Date().day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.day = 1 // sets someDate's day of month to 1.
    ///
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Weekday.
    ///
    ///     Date().weekday -> 5 // fifth day in the current week.
    ///
    var weekday: Int {
        return calendar.component(.weekday, from: self)
    }

    /// SwifterSwift: Hour.
    ///
    ///     Date().hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.hour = 13 // sets someDate's hour to 1 pm.
    ///
    var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentHour = calendar.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Minutes.
    ///
    ///     Date().minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.minute = 10 // sets someDate's minutes to 10.
    ///
    var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = calendar.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Seconds.
    ///
    ///     Date().second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.second = 15 // sets someDate's seconds to 15.
    ///
    var second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = calendar.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = calendar.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Yesterday date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
    ///
    var yesterday: Date {
        return calendar.date(byAdding: .day, value: -1, to: self) ?? Date()
    }

    /// SwifterSwift: Tomorrow's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
    ///
    var tomorrow: Date {
        return calendar.date(byAdding: .day, value: 1, to: self) ?? Date()
    }
}

extension Date{
    func hz_string(withFormat format: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func utcTimeStamp() -> TimeInterval{
        let timeZone = TimeZone.current
        let offset = timeZone.secondsFromGMT(for: Date())
        return timeIntervalSince1970 + Double(offset) * 1000
    }
    
    /// 获取日期对应的年月日
    func components() -> (years: Int, months: Int, days: Int){
        let calendar = Calendar.current
        let flags: Set<Calendar.Component> = Set([.year, .month, .day])
        let component = calendar.dateComponents(flags, from: self)
        let year = component.year ?? 0
        let month = component.month ?? 0
        let day = component.day ?? 0
        return (year, month, day)
    }
    
    /// 根据年月日转换为Date
    static func dateFrom(years: Int, months: Int, days: Int) -> Date?{
        let year = "\(years)"
        let month = String(format: "%2ld", months)
        let day = String(format: "%2ld", days)
        let dateString = "\(year)-\(month)-\(day)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.date(from: dateString)
        return date
    }
    
    /// 计算时差
    /// - Parameters:
    ///   - date: 小日期
    ///   - nearbyDate: 大日期
    ///   - autoIncrease: 是否需要加1天补齐
    ///   - reserve: 是否从计算到下一个周期， 而不是从过去计算
    /// - Returns: 相差的年月日
    static func diffSince(_ date: Date?, anotherDate: Date = Date(), autoIncrease: Bool = true, ignoreYear: Bool = true) -> (years: Int, months: Int, days: Int)?{
        guard let date else {
            return nil
        }
        
        var minDate: Date = date
        var maxDate: Date = anotherDate.yesterday
 
        // 忽略年份， 来比日期
        if ignoreYear{
            minDate = anotherDate.yesterday
            maxDate = date
            
            if date.month >= anotherDate.month && date.day >= anotherDate.day{
                // date > anotherDate
                maxDate.year = minDate.year
            }else{
                maxDate.year = minDate.year + 1
            }
            if autoIncrease{
                minDate.day += 1
            }
        }else{
            if autoIncrease{
                maxDate.day += 2
            }
        }

        
        let calendar = Calendar.current
        let flags: Set<Calendar.Component> = Set([.year, .month, .day])
        let component = calendar.dateComponents(flags, from: minDate, to: maxDate)
        let year = component.year ?? 0
        let month = component.month ?? 0
        let day = component.day ?? 0
        return (year, month, day)
    }
}
