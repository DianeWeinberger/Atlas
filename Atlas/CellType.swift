//
//  CellType.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/1/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

protocol CellType {
  static var dequeueData: (cellIdentifier: String, cellType: AnyClass) { get }
}

extension CellType {
  static var reuseIdentifier: String {
    return String(describing: Self.self)
  }
  
  static var dequeueData: (cellIdentifier: String, cellType: AnyClass) {
    return (reuseIdentifier, Self.self as! AnyClass)
  }
}

extension UITableViewCell: CellType {}
extension UICollectionViewCell: CellType {}
