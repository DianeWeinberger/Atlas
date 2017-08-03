//
//  ConnectTableViewCell.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/27/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import AvatarImageView
import Kingfisher

class ConnectTableViewCell: UITableViewCell {

  @IBOutlet weak var avatarImageView: AvatarImageView!
  @IBOutlet weak var nameTextLabel: UILabel!
  @IBOutlet weak var locationTextLabel: UILabel!
  @IBOutlet weak var paceTextLabel: UILabel!
  
  func configure(from user: User) {
    avatarImageView.configuration = AvatarConfig.shared
    avatarImageView.dataSource = user.avatarData
    if !user.imageURL.isEmpty, let url = user.url {
      avatarImageView.kf.roundedImage(with: url)
    }
    nameTextLabel.text = user.displayName
  }
}

