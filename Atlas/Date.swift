//
//  Date.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation

extension Date {
  var shortDate: String {
    return DateFormatter.string(from: self, date: .short, time: .none)
  }
  
  var shortTime: String {
    return DateFormatter.string(from: self, date: .none, time: .short)
  }
  
  var month: String {
    return DateFormatter.string(from: self, format: "MMM")
  }
  
  var day: String {
    return DateFormatter.string(from: self, format: "d")
  }
  
  func after(months: Int) -> Date {
    return Calendar.current.date(byAdding: .month,
                                 value: months,
                                 to: self) ?? self
  }
  
  func after(days: Int) -> Date {
    return Calendar.current.date(byAdding: .day,
                                 value: days,
                                 to: self) ?? self
  }
  
  func after(hours: Int) -> Date {
    return Calendar.current.date(byAdding: .hour,
                                 value: hours,
                                 to: self) ?? self
  }
  
  func after(minutes: Int) -> Date {
    return Calendar.current.date(byAdding: .minute,
                                 value: minutes,
                                 to: self) ?? self
  }
  
  func before(months: Int) -> Date {
    return Calendar.current.date(byAdding: .month,
                                 value: -months,
                                 to: self) ?? self
  }
  
  func before(days: Int) -> Date {
    return Calendar.current.date(byAdding: .day,
                                 value: -days,
                                 to: self) ?? self
  }
  
  func before(hours: Int) -> Date {
    return Calendar.current.date(byAdding: .hour,
                                 value: -hours,
                                 to: self) ?? self
  }
  
  func before(minutes: Int) -> Date {
    return Calendar.current.date(byAdding: .minute,
                                 value: -minutes,
                                 to: self) ?? self
  }
  
  func isBefore(date: Date) -> Bool {
    let comparison = Calendar.current.compare(self, to: date, toGranularity: Calendar.Component.second)
    return comparison == .orderedAscending
  }
  
  func isSame(date: Date) -> Bool {
    let comparison = Calendar.current.compare(self, to: date, toGranularity: Calendar.Component.second)
    return comparison == .orderedSame
  }
  
  func isAfter(date: Date) -> Bool {
    let comparison = Calendar.current.compare(self, to: date, toGranularity: Calendar.Component.second)
    return comparison == .orderedDescending
  }
}

// Mark: DateFormatter Extensions
extension DateFormatter {
  class func string(from fromDate: Date,
                    date dateStyle: DateFormatter.Style,
                    time timeStyle: DateFormatter.Style) -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateStyle = dateStyle
    dateFormater.timeStyle = timeStyle
    return dateFormater.string(from: fromDate)
  }
  
  class func string(from fromDate: Date, format: String) -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = format
    return dateFormater.string(from: fromDate)
  }
  
  convenience init (format: String) {
    self.init()
    dateFormat = format
    locale = Locale.current
  }
}
