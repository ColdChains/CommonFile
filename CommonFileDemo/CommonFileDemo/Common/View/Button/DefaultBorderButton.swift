//
//  DefaultBorderButton.swift
//  UnityCar
//
//  Created by lax on 2020/3/27.
//  Copyright © 2020 ColdChains. All rights reserved.
//

import Foundation

class DefaultBorderButton: UIButton {

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
        layer.borderWidth = 1
        layer.borderColor = UIColor.default.cgColor
        setTitleColor(.default, for: .normal)
        setTitleColor(.highlightDefault, for: .highlighted)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.borderColor = UIColor.default.cgColor
    }

}
