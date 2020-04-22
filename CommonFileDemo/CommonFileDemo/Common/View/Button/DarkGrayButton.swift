//
//  DarkGrayButton.swift
//  UnityCar
//
//  Created by lax on 2019/10/16.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class DarkGrayButton: UIButton {
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        setTitleColor(.darkGray, for: .normal)
        setTitleColor(.darkText, for: .highlighted)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(.darkGray, for: .normal)
        setTitleColor(.darkText, for: .highlighted)
   }

}
