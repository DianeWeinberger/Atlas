//
//  BannerImage.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/3/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import GameplayKit

struct BannerImage {
  static let images = [#imageLiteral(resourceName: "img_1"), #imageLiteral(resourceName: "img_2"), #imageLiteral(resourceName: "img_3"), #imageLiteral(resourceName: "img_4"), #imageLiteral(resourceName: "img_5")]
  
  static func random() -> UIImage {
    let n = GKRandomSource.sharedRandom().nextInt(upperBound: BannerImage.images.count)
    return BannerImage.images[n]
  }
}
