//
//  ConfirmButton.swift
//  UnityCarDriver
//
//  Created by lax on 2020/3/31.
//  Copyright © 2020 ColdChains. All rights reserved.
//

import Foundation

class ConfirmButton: UIButton {

    override init(frame: CGRect = CGRect(x: 0, y: 0, width: ScreenWidth - 32, height: 48)) {
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
        backgroundColor = .containerBG
        layer.cornerRadius = 4
        setTitleColor(.darkText, for: .normal)
    }

}
