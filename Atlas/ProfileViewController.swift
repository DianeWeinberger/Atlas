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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    // Do any additional setup after loading the view.
  }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 1 : user.runs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard indexPath.section > 0 else {
      let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as! ProfileTableViewCell
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
      return width * 587/375
    }
    
    return width * 80/375
  }
}
