//
//  ContentScrollView.swift
//  FreightUser
//
//  Created by lax on 2019/11/27.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class ContentScrollView: UIScrollView {
    
    var viewArray: [UITableView] = [] {
        willSet {
            for view in viewArray {
                view.removeFromSuperview()
            }
        }
        didSet {
            addSubviews(viewArray)
        }
    }

    init(delegate: UIScrollViewDelegate? = nil) {
        super.init(frame: CGRect())
        self.delegate = delegate
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubviews(_ viewArray: [UIView]) {
        for i in 0..<viewArray.count {
            let view = viewArray[i]
            addSubview(view)
            view.snp.makeConstraints { (make) in
                if i == 0 {
                    make.left.equalToSuperview()
                } else if i == viewArray.count - 1 {
                    make.left.equalTo(viewArray[i - 1].snp_right)
                    make.right.equalToSuperview()
                } else {
                    make.left.equalTo(viewArray[i - 1].snp_right)
                }
                make.top.bottom.equalToSuperview()
                make.width.height.equalToSuperview()
            }
        }
    }

}
