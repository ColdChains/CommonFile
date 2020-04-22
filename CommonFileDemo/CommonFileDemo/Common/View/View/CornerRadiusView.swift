//
//  CornerRadiusView.swift
//  UnityCar
//
//  Created by lax on 2019/11/12.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CornerRadiusView: UIView {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4
    }

}
