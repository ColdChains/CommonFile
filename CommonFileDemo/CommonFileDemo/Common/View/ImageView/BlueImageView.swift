//
//  BlueImageView.swift
//  UnityCar
//
//  Created by lax on 2019/11/4.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class BlueImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = height / 2
        backgroundColor = UIColor(hex: "#1B72FF")
    }

}
