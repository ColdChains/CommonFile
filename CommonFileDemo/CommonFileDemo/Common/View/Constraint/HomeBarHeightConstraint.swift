//
//  HomeBarHeightConstraint.swift
//  FreightDriver
//
//  Created by lax on 2019/12/30.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class HomeBarHeightConstraint: NSLayoutConstraint {

    override func awakeFromNib() {
        super.awakeFromNib()
        constant = HomeBarHeight
    }
    
}
