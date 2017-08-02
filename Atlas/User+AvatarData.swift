//
//  User+AvatarData.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/2/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import AvatarImageView
import SwiftyImage

extension User {
  var avatarData: AvatarImageViewDataSource {
    return AvatarSource(
      name: self.fullName,
      avatar: nil,
      bgColor: nil,
      initials: self.initials,
      avatarId: self.id.hash
    )
  }
}

struct AvatarSource: AvatarImageViewDataSource {
  var name: String
  var avatar: UIImage?
  var bgColor: UIColor?
  var initials: String
  var avatarId: Int
}
