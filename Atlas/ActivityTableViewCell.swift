//
//  ActivityTableViewCell.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/1/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import AvatarImageView

class ActivityTableViewCell: UITableViewCell {

  @IBOutlet weak var avatarImageView: AvatarImageView!
  @IBOutlet weak var activityLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configure(from event: Event) {
    guard let user = event.user else { return }
    avatarImageView.configuration = AvatarConfig.shared
    avatarImageView.dataSource = user.avatarData
    if !user.imageURL.isEmpty, let url = user.url {
      avatarImageView.kf.roundedImage(with: url)
    }
    activityLabel.text = event.title
    nameLabel.text = user.displayName
    timeLabel.text = event.timestamp.shortDate + " - " + event.timestamp.shortTime
  }
}
