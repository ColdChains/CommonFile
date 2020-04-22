//
//  CircleBackgroundView.swift
//  UnityCar
//
//  Created by lax on 2019/10/24.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CircleBackgroundView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .background
        layer.cornerRadius = height / 2
    }
}
