//
//  TopCornerRadiusView.swift
//  UnityCar
//
//  Created by lax on 2019/10/24.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class TopCornerRadiusView: UIView {
    
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
        shapeLayer = clipsTopCornerRadius(4)
    }
    
}
