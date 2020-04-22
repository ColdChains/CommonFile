//
//  BaseTableViewController.swift
//  DAPPBrowser
//
//  Created by ColdChains on 2018/9/13.
//  Copyright © 2018 ColdChains. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController {
    
    var tableView = CommonTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    override func addNavigationBar() {
        super.addNavigationBar()
        setTableViewTopConstraint(top: NavigationBarHeight)
    }
    
    func setTableViewTopConstraint(top: CGFloat) {
        tableView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(top)
        }
    }
    
}
