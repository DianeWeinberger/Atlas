//
//  ActivityTableViewCell.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/1/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

  @IBOutlet weak var avatarImageView: UIImageView!
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
  
}
