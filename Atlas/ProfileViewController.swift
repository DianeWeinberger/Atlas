//
//  ProfileViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/31/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import Action
import RealmSwift

class ProfileViewController: UIViewController, BindableType {
  
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel: ProfileViewModel!

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section < 2 ? 1 : viewModel.user.runs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
      
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as! ProfileTableViewCell
      cell.configure(from: viewModel.user)
      cell.editButton.rx.action = viewModel.editAction
      return cell
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.reuseIdentifier, for: indexPath) as! ChartTableViewCell
      cell.configure(from: viewModel.user)
      return cell
      
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: RunTableViewCell.reuseIdentifier, for: indexPath) as! RunTableViewCell
      let run = viewModel.user.sortedRuns[indexPath.row]
      cell.configure(run: run)
      return cell
      
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let width = tableView.bounds.width
    
    switch indexPath.section {
      
    case 0:
      return width * 520/375
    case 1:
      return width * 250/375
    default:
      return width * 80/375
      
    }
  }
}
