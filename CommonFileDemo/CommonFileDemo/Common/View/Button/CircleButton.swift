//
//  CircleButton.swift
//  FreightUser
//
//  Created by lax on 2019/8/28.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = width < height ? width / 2 : height / 2
    }

}
