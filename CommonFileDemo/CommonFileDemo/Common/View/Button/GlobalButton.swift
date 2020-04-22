//
//  GlobalButton.swift
//  FreightUser
//
//  Created by lax on 2019/8/22.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class GlobalButton: UIButton {
    
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
        if isEnabled {
            setTitleColor(.global, for: .normal)
            setTitleColor(.highlightGlobal, for: .highlighted)
        } else {
            setTitleColor(.lightGray, for: .normal)
            setTitleColor(.darkGray, for: .highlighted)
        }
        addObserver(self, forKeyPath: "enabled", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let path = keyPath, path == "enabled" {
            if isEnabled {
                setTitleColor(.global, for: .normal)
                setTitleColor(.highlightGlobal, for: .highlighted)
            } else {
                setTitleColor(.lightGray, for: .normal)
                setTitleColor(.darkGray, for: .highlighted)
            }
        }
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "enabled")
    }
    
}
