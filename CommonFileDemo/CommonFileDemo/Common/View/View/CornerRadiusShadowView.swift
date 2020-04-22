//
//  CornerRadiusShadowView.swift
//  FreightUser
//
//  Created by lax on 2019/8/23.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CornerRadiusShadowView: UIView {
    
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
        layer.cornerRadius = 4
        addShadow()
    }

}
