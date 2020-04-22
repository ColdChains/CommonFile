//
//  BackgroundView.swift
//  UnityCar
//
//  Created by lax on 2019/10/10.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .background
    }

}
