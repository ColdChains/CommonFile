//
//  SplitLineView.swift
//  UnityCar
//
//  Created by lax on 2019/10/10.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class SplitLineView: UIView {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        backgroundColor = .splitLine
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .splitLine
    }

}
