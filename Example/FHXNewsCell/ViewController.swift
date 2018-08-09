//
//  ViewController.swift
//  FHXNewsCell
//
//  Created by fenghanxu on 08/09/2018.
//  Copyright (c) 2018 fenghanxu. All rights reserved.
//  import FHXNewsCell

import UIKit
import FHXNewsCell

class ViewController: UIViewController {
  
  let tableview = UITableView()
  
  let arr = ["广告1","广告2","广告3","广告4","广告5"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    buildUI()
  }
  
  func buildUI(){
    view.backgroundColor = UIColor.white
    view.addSubview(tableview)
    buildSubview()
    buildLayout()
  }
  
  func buildSubview(){
    tableview.backgroundColor = UIColor.white
    tableview.tableFooterView = UIView()
    tableview.delegate = self
    tableview.dataSource = self
    tableview.separatorStyle = .none
    tableview.register(HomeNewsCell.self, forCellReuseIdentifier: "kHomeNewsCell")
    tableview.rowHeight = 44
  }
  
  func buildLayout(){
    tableview.snp.makeConstraints { (make) in
      make.left.right.bottom.equalToSuperview()
      make.top.equalToSuperview().offset(100)
    }
  }
  
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: "kHomeNewsCell", for: indexPath) as! HomeNewsCell
    cell.model = arr
    return cell
  }
  
  
}
