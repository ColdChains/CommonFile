//
//  CornerRadiusImageView.swift
//  FreightUser
//
//  Created by lax on 2019/12/12.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class CornerRadiusImageView: UIImageView {
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        backgroundColor = .whiteGray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4
        backgroundColor = .whiteGray
    }

}
