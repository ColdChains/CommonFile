//
//  GlobalImageView.swift
//  UnityCar
//
//  Created by lax on 2019/11/4.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class GlobalImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = height / 2
        backgroundColor = .global
    }

}
