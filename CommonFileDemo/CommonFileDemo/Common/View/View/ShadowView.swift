//
//  ShadowView.swift
//  FreightUser
//
//  Created by lax on 2019/8/22.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }
    
}
