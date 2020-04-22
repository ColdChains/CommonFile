//
//  MenuView.swift
//  FreightUser
//
//  Created by lax on 2019/7/16.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

protocol MenuViewDelegate : NSObjectProtocol {
    func menuViewDidSelectMenu(index: Int)
}

class MenuView: UIView {
    
    weak var delegate: MenuViewDelegate?
    
    var textFont: UIFont = .normal {
        didSet {
            for button in buttonArray {
                button.titleLabel?.font = textFont
            }
            for i in 0..<titleWidthArray.count {
                let itemWidth = width / CGFloat(dataArray.count)
                titleWidthArray[i] = dataArray[i].boundingRectWidth(with: itemWidth, font: textFont)
            }
        }
    }
    
    var selectTextFont: UIFont = .normalMedium {
        didSet {
            buttonArray[selectIndex].titleLabel?.font = selectTextFont
        }
    }
    
    var textColor: UIColor = .darkText {
        didSet {
            for button in buttonArray {
                button.setTitleColor(textColor, for: .normal)
            }
            buttonArray[selectIndex].setTitleColor(selectTextColor, for: .normal)
        }
    }
    
    var selectTextColor: UIColor = .global {
        didSet {
            for button in buttonArray {
                button.setTitleColor(textColor, for: .normal)
            }
            buttonArray[selectIndex].setTitleColor(selectTextColor, for: .normal)
        }
    }
    
    var selectIndex: Int = 0 {
        willSet {
            buttonArray[selectIndex].titleLabel?.font = textFont
            buttonArray[selectIndex].setTitleColor(textColor, for: .normal)
        }
        didSet {
            buttonArray[selectIndex].titleLabel?.font = selectTextFont
            buttonArray[selectIndex].setTitleColor(selectTextColor, for: .normal)
        }
    }
    
    var titleWidth: CGFloat = 0 {
        didSet {
            for i in 0..<titleWidthArray.count {
                titleWidthArray[i] = titleWidth
                setProgress(CGFloat(selectIndex))
            }
        }
    }
    
    var buttonArray: [UIButton] = []
    
    private var dataArray: [String] = []
    
    private var titleWidthArray: [CGFloat] = []
    
    private lazy var lineView: UIView = {
        let view = UIView()
        return view
    }()
    
    init(frame: CGRect = CGRect(x: 0, y: 0, width: ScreenWidth, height: 44), dataArray: [String]) {
        super.init(frame: frame)
        self.dataArray = dataArray
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        
        let itemWidth = width / CGFloat(dataArray.count)
        for i in 0..<dataArray.count {
            let button = UIButton(type: .custom)
            button.tag = 100 + i
            button.frame = CGRect(x: itemWidth * CGFloat(i), y: 0, width: itemWidth, height: height)
            button.titleLabel?.font = textFont
            button.setTitle(dataArray[i], for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            addSubview(button)
            buttonArray.append(button)
            titleWidthArray.append(dataArray[i].boundingRectWidth(with: itemWidth, font: textFont))
        }
        
        buttonArray[selectIndex].setTitleColor(selectTextColor, for: .normal)
        buttonArray[selectIndex].titleLabel?.font = selectTextFont
        let w = titleWidthArray[0]
        lineView.frame = CGRect(x: (itemWidth - titleWidthArray[0]) / 2, y: height - 3, width: w, height: 3)
        lineView.layer.cornerRadius = 1.5
        lineView.backgroundColor = .global
        addSubview(lineView)
        addShadow(.lightShadow, offset: CGSize(width: 0, height: 4))
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        selectIndex = sender.tag - 100
        delegate?.menuViewDidSelectMenu(index: selectIndex)
    }
    
    func setProgress(_ progress:CGFloat) {
        
        var left = Int(floor(progress))
        var right = Int(ceil(progress))
        left = left <= 0 ? 0 : left
        right = right >= dataArray.count - 1 ? dataArray.count - 1 : right

        var rect = lineView.frame
        let ratio = CGFloat(Int(progress * width) % Int(width)) / width
        rect.size.width = titleWidthArray[left] + (titleWidthArray[right] - titleWidthArray[left]) * ratio
        //x = 左x + 左到右的x差的比例(x是文字的x不是button的)
        let leftX = buttonArray[left].center.x  - titleWidthArray[left] / 2
        let rightX = buttonArray[right].center.x  - titleWidthArray[right] / 2
        rect.origin.x = leftX + (rightX - leftX) * ratio
        lineView.frame = rect
        
    }

}
