//
//  CornerBigRadiusView.swift
//  UnityCarDriver
//
//  Created by 田峰 on 2020/3/31.
//  Copyright © 2020 ColdChains. All rights reserved.
//

import UIKit

class CornerBigRadiusView: UIView {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        backgroundColor = .container
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        backgroundColor = .container
    }
}
