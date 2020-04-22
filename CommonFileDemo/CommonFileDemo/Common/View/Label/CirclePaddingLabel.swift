//
//  CirclePaddingLabel.swift
//  UnityCarDriver
//
//  Created by lax on 2020/3/26.
//  Copyright © 2020 ColdChains. All rights reserved.
//

import Foundation

class CirclePaddingLabel: UILabel {
    
    var edgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    var cornerRadius: CGFloat = 0
    
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
        let h = height + edgeInsets.top + edgeInsets.bottom
        cornerRadius = h > 30 ? 10 : h / 2
        layer.cornerRadius = cornerRadius
//        backgroundColor = UIColor(hex: "#E9ECF6")
//        textColor = UIColor(hex: "#1F253F")
        layer.masksToBounds = true
    }
    
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
        layer.cornerRadius = cornerRadius
    }
    
}
