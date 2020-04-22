//
//  LineView.swift
//  FreightUser
//
//  Created by lax on 2019/8/28.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        backgroundColor = .line
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .line
    }

}
