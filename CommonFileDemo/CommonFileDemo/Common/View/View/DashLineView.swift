//
//  DashLineView.swift
//  UnityCar
//
//  Created by lax on 2019/11/4.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class DashLineView: UIView {
    
    var shapeLayer: CAShapeLayer?

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        backgroundColor = .clear
        shapeLayer = addHorizontalDashLine(color: UIColor.dynamic(hex: "#E5E5E5", darkHex: "#000000"))
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        shapeLayer = addHorizontalDashLine(color: UIColor.dynamic(hex: "#E5E5E5", darkHex: "#000000"))
        layer.masksToBounds = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        shapeLayer?.removeFromSuperlayer()
        shapeLayer = addHorizontalDashLine(color: UIColor.dynamic(hex: "#E5E5E5", darkHex: "#000000"))
    }

}
