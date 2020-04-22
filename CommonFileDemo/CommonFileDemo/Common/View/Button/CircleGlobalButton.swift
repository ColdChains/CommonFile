//
//  CircleGlobalButton.swift
//  UnityCar
//
//  Created by lax on 2019/11/2.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CircleGlobalButton: UIButton {
    
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
        layer.cornerRadius = height / 2
        setTitleColor(.white, for: .normal)
        initBackgroundColor()
        addObserver(self, forKeyPath: "enabled", options: .new, context: nil)
        addObserver(self, forKeyPath: "highlighted", options: .new, context: nil)
    }
    
    private func initBackgroundColor() {
        if isEnabled {
            if isHighlighted {
                backgroundColor = .highlightGlobal
            } else {
                backgroundColor = .global
            }
        } else {
            backgroundColor = .unable
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        initBackgroundColor()
    }
    
    deinit {
        removeObserver(self, forKeyPath: "enabled")
        removeObserver(self, forKeyPath: "highlighted")
    }
    
}
