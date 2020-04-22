//
//  StarView.swift
//  UnityCar
//
//  Created by lax on 2019/11/10.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class StarView: UIView {
    
    var buttonArray: [UIButton] = []
    
    var selectIndex: Int = 0 {
        didSet {
            for i in 0..<buttonArray.count {
//                buttonArray[i].isSelected = i <= selectIndex
                let image = i <= selectIndex ? R.image.icon_star_select() : R.image.icon_star()
                buttonArray[i].setImage(image, for: .highlighted)
                buttonArray[i].setImage(image, for: .normal)
            }
        }
    }

    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initView() {
        let count = 5
        for i in 0..<count {
            let button = UIButton(type: .custom)
            button.tag = 100 + i
//            button.frame = CGRect(x: (i % 2) * w, y: (i / 2) * h, width: w, height: h)
            button.setImage(R.image.icon_star(), for: .normal)
            button.setImage(R.image.icon_star(), for: .highlighted)
//            button.setImage(R.image.icon_Star_select(), for: .selected)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            addSubview(button)
            buttonArray.append(button)
            button.snp.makeConstraints { (make) in
                if i == 0 {
                    make.left.equalToSuperview()
                } else if i == count - 1 {
                    make.left.equalTo(buttonArray[i - 1].snp_right)
                    make.right.equalToSuperview()
                } else {
                    make.left.equalTo(buttonArray[i - 1].snp_right)
                }
                make.top.bottom.equalToSuperview()
                make.width.height.equalToSuperview()
            }
        }
        selectIndex = 4
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        selectIndex = sender.tag - 100
    }

}
