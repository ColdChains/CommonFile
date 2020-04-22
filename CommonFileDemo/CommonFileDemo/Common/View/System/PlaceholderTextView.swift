//
//  PlaceholderTextView.swift
//  FreightUser
//
//  Created by lax on 2019/8/28.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {
    
    var placeholder: String? {
        didSet {
            label.text = placeholder
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .normal
        label.textColor = .lightGray
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        returnKeyType = .done
        layer.cornerRadius = 4
//        contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addSubview(label)
        setValue(label, forKey: "_placeholderLabel")
    }

}
