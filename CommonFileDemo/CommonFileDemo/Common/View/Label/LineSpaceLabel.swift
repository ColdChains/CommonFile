//
//  LineSpaceLabel.swift
//  FreightUser
//
//  Created by lax on 2019/8/22.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class LineSpaceLabel: UILabel {
    
    var lineSpace: CGFloat = 4 {
        didSet {
            attributedText = text?.attributedString(lineSpace: lineSpace)
        }
    }
    
    var lineSpaceText: String? {
        didSet {
            attributedText = lineSpaceText?.attributedString(lineSpace: lineSpace)
        }
    }
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        lineSpace = 4
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineSpace = 4
    }

}
