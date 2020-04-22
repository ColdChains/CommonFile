//
//  RedLabel.swift
//  FreightUser
//
//  Created by lax on 2019/11/28.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class RedLabel: UILabel {
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        textColor = .red
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = .red
    }

}
