//
//  GreenImageView.swift
//  FreightUser
//
//  Created by lax on 2019/11/25.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class GreenImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = height / 2
        backgroundColor = UIColor(hex: "#54B8A7")
    }

}
