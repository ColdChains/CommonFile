//
//  PaddingLabel.swift
//  FreightUser
//
//  Created by lax on 2019/8/22.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    var edgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    //修改绘制文字的区域
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= edgeInsets.left
        rect.origin.y -= edgeInsets.top
        rect.size.width += edgeInsets.left + edgeInsets.right
        rect.size.height += edgeInsets.top + edgeInsets.bottom
        return rect
    }
    
    //绘制文字
    override func drawText(in rect: CGRect) {
        if let str = text, str != "" {
            var r = rect
            r.origin.x += edgeInsets.left
            r.origin.y += edgeInsets.top
            r.size.width -= edgeInsets.left + edgeInsets.right
            r.size.height -= edgeInsets.top + edgeInsets.bottom
            super.drawText(in: r)
            isHidden = false
        } else {
            super.drawText(in: rect)
            isHidden = true
        }
    }
    
}

