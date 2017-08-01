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
    // Do any additional setup after loading the view.
  }
}

extension ProfileViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as! ProfileTableViewCell
    
    cell.configure(from: user)
    
    return cell
  }
}
