//
//  ContainerBGView.swift
//  FreightUser
//
//  Created by lax on 2019/12/12.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class ContainerBGView: UIView {

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        backgroundColor = .containerBG
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .containerBG
    }

}
