//
//  ProfileViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/31/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let user = MockUser.ironMan()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    // Do any additional setup after loading the view.
  }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section < 2 ? 1 : user.runs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard indexPath.section != 0 else {
      let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as! ProfileTableViewCell
      cell.configure(from: user)
      return cell
    }
    
    guard indexPath.section != 1 else {
      let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.reuseIdentifier, for: indexPath) as! ChartTableViewCell
      cell.configure(from: user)
      return cell
    }
      
    let cell = tableView.dequeueReusableCell(withIdentifier: RunTableViewCell.reuseIdentifier, for: indexPath) as! RunTableViewCell
    let run = user.runs[indexPath.row]
    cell.configure(run: run)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let width = tableView.bounds.width
    
    if indexPath.section == 0 {
      return width * 520/375
    }
    
    if indexPath.section == 1 {
      return width * 250/375
    }
    
    return width * 80/375
  }
}
