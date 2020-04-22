//
//  LightGrayBlueLabel.swift
//  UnityCarDriver
//
//  Created by 田峰 on 2020/3/30.
//  Copyright © 2020 ColdChains. All rights reserved.
//

import UIKit

class LightGrayBlueLabel: UILabel {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        textColor = .lightGrayBlue
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = .lightGrayBlue
    }

}
