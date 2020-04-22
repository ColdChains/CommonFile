//
//  CornerBigRadiusBGView.swift
//  UnityCarDriver
//
//  Created by 田峰 on 2020/3/31.
//  Copyright © 2020 ColdChains. All rights reserved.
//

import UIKit

class CornerBigRadiusBGView: UIView {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = .black
    }
    
    override func draw(_ rect: CGRect) {
        // 获取当前模式
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                return
            }
        }
        drawLinearGradientLeftToRight([UIColor(hex: "#EFF1F4"), UIColor(hex: "#F5F8FC")])
    }
}
