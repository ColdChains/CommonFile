//
//  Common.swift
//  FreightUser
//
//  Created by lax on 2019/8/23.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

struct CellModel {
    
    var index = -1
    
    var title: String?
    var titleColor: UIColor?
    
    var detail: String?
    var detailColor: UIColor?
    
    var icon: UIImage?
    var image: UIImage?
    
    var arrow: Bool?
    var autoArrowWidth: Bool?
    
    var action: String?
    var push: String?
    var value: Any?
    
    init(
        title: String? = nil,
        titleColor: UIColor? = nil,
        detail: String? = nil,
        detailColor: UIColor? = nil,
        
        icon: UIImage? = nil,
        image: UIImage? = nil,
        arrow: Bool? = nil,
        autoArrowWidth: Bool? = nil,
        
        action: String? = nil,
        push: String? = nil,
        value: Any? = nil
    ) {
        self.title = title
        self.titleColor = titleColor
        self.detail = detail
        self.detailColor = detailColor
        
        self.icon = icon
        self.arrow = arrow
        self.image = image
        self.autoArrowWidth = autoArrowWidth
        
        self.action = action
        self.push = push
        self.value = value
    }
    
}
