//
//  Date.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation

extension Date {
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
}
