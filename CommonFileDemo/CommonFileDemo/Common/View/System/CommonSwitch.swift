//
//  CommonSwitch.swift
//  FreightDriver
//
//  Created by lax on 2019/12/20.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CommonSwitch: UISwitch {

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
        tintColor = .global
        onTintColor = .global
    }

}
