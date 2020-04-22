//
//  DarkTextButton.swift
//  UnityCar
//
//  Created by lax on 2019/10/24.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class DarkTextButton: UIButton {
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        setTitleColor(.darkText, for: .normal)
        setTitleColor(.darkGray, for: .highlighted)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(.darkText, for: .normal)
        setTitleColor(.darkGray, for: .highlighted)
    }

}
