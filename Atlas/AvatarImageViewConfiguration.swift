//
//  AvatarImageViewConfiguration.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/2/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import AvatarImageView

struct AvatarConfig: AvatarImageViewConfiguration {
  static var shared: AvatarConfig { return AvatarConfig() }
  
  var shape: Shape = Shape.circle
  var textSizeFactor: CGFloat = 0.5
  var fontName: String? = "OpenSans-Bold"
  var textColor: UIColor = UIColor.white
  var bgColor: UIColor? {
    let colors: [UIColor] = [
      Colors.blue.azure,
      Colors.green,
      Colors.orange.orangeRed,
      Colors.red.pinkishRed,
      Colors.yellow
    ]
    
    let i = Int(arc4random_uniform(UInt32(colors.count)))
    return colors[i]
  }

}
