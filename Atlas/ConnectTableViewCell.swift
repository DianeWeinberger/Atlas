//
//  ConnectTableViewCell.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/27/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

class ConnectTableViewCell: UITableViewCell {

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameTextLabel: UILabel!
  @IBOutlet weak var locationTextLabel: UILabel!
  @IBOutlet weak var paceTextLabel: UILabel!

  override func layoutSubviews() {
    avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    avatarImageView.layer.masksToBounds = true
  }
}
