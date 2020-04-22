//
//  StatusBarHeightConstraint.swift
//  FreightDriver
//
//  Created by lax on 2019/12/30.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class StatusBarHeightConstraint: NSLayoutConstraint {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        constant = StatusBarHeight
    }

}
