//
//  SettingsViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import AvatarImageView
import Kingfisher
import SkyFloatingLabelTextField

class SettingsViewController: UITableViewController {
  
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var imageView: AvatarImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  @IBOutlet weak var fullNameTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var logoutButton: UIButton!

  var viewModel: SettingsViewModel!
  
  override func viewDidLoad() {
    nameLabel.text = viewModel.user.fullName
    
    imageView.configuration = AvatarConfig.shared
    imageView.dataSource = viewModel.user.avatarData
    if !viewModel.user.imageURL.isEmpty, let url = viewModel.user.url {
      imageView.kf.roundedImage(with: url)
    }
    
    
  }
}

extension SettingsViewController: BindableType {
  func bindViewModel() {
    backButton.rx.action = viewModel.backAction
    logoutButton.rx.action = viewModel.logOutAction
  }
}
