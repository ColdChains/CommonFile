//
//  TransitionColorButton.swift
//  UnityCarDriver
//
//  Created by lax on 2020/3/23.
//  Copyright © 2020 ColdChains. All rights reserved.
//

import UIKit

class TransitionColorButton: UIButton {

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
        layer.cornerRadius = 4
        setTitleColor(.white, for: .normal)
        setTitleColor(.whiteGray, for: .highlighted)
    }
    
    override func draw(_ rect: CGRect) {
        drawLinearGradientLeftToRight([.lightGlobal, .global])
    }

}
