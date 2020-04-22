//
//  DarkTextField.swift
//  UnityCar
//
//  Created by lax on 2019/10/24.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class DarkTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        clearButtonMode = .whileEditing
        textColor = .darkText
        let placeholserAttributes = [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : font]
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",attributes: placeholserAttributes as [NSAttributedString.Key : Any])
        addObserver(self, forKeyPath: "placeholder", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let path = keyPath, path == "placeholder" {
            let placeholserAttributes = [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : font]
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "",attributes: placeholserAttributes as [NSAttributedString.Key : Any])
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "placeholder")
    }

}
