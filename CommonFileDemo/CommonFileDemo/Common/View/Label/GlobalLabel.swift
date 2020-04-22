//
//  GlobalLabel.swift
//  FreightUser
//
//  Created by lax on 2019/8/22.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class GlobalLabel: UILabel {
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        textColor = .global
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = .global
    }
    
}
