//
//  DefaultSegmented.swift
//  UnityCar
//
//  Created by lax on 2019/11/12.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class DefaultSegmented: UISegmentedControl {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    private func initView() {
        backgroundColor = .container
        tintColor = .default
        layer.cornerRadius = 4
    }

}
