//
//  UIColor.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(_ r: Double, _ g: Double, _ b: Double) {
    self.init(red: CGFloat(r/255),
              green: CGFloat(g/255),
              blue: CGFloat(b/255),
              alpha: 1.0)
  }
  
  convenience init(_ r: Double, _ g: Double, _ b: Double, _ a: Double) {
    self.init(red: CGFloat(r/255),
              green: CGFloat(g/255),
              blue: CGFloat(b/255),
              alpha: CGFloat(a))
  }
}
