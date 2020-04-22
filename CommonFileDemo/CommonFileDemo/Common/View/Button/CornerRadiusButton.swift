//
//  CornerRadiusButton.swift
//  FreightUser
//
//  Created by lax on 2019/8/22.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CornerRadiusButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4
    }
    
}
