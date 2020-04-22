//
//  CircleImageView.swift
//  UnityCar
//
//  Created by lax on 2019/11/2.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        layer.cornerRadius = height / 2
        backgroundColor = .whiteGray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = height / 2
        backgroundColor = .whiteGray
    }

}
