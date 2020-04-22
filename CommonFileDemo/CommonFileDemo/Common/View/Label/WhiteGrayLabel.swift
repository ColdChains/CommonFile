//
//  WhiteGrayLabel.swift
//  UnityCar
//
//  Created by lax on 2019/11/4.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class WhiteGrayLabel: UILabel {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        textColor = .whiteGray
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = .whiteGray
    }

}
