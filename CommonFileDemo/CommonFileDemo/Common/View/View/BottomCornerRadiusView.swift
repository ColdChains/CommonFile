//
//  BottomCornerRadiusView.swift
//  FreightUser
//
//  Created by lax on 2019/12/12.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class BottomCornerRadiusView: UIView {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        backgroundColor = .container
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .container
        addShadow()
    }
    
    var shapeLayer: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer?.removeFromSuperlayer()
        shapeLayer = clipsBottomCornerRadius(8)
    }
    
}
