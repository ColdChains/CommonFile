//
//  YellowLabel.swift
//  FreightDriver
//
//  Created by lax on 2019/12/19.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class YellowLabel: UILabel {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        textColor = .orange
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = .orange
    }

}
