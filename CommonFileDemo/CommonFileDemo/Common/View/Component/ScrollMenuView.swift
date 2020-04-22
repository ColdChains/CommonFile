//
//  ScrollMenuView.swift
//  FreightUser
//
//  Created by lax on 2019/8/27.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

protocol ScrollMenuViewDelegate: NSObjectProtocol {
    func scrollMenuViewDidSelectMenu(index: Int)
    func scrollMenuViewDidScroll(scrollView: UIScrollView)
}

class ScrollMenuView: UIView {
    
    weak var delegate: ScrollMenuViewDelegate?
    
    var textFont: UIFont = .standard {
        didSet {
            for button in buttonArray {
                button.titleLabel?.font = textFont
            }
        }
    }
    
    var selectTextFont: UIFont = .normalMedium {
        didSet {
            buttonArray[selectIndex].titleLabel?.font = selectTextFont
        }
    }
    
    var textColor: UIColor = .darkGray {
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
            lineView.backgroundColor = selectTextColor
        }
    }
    
    var selectIndex: Int = 0 {
        willSet {
            buttonArray[selectIndex].setTitleColor(textColor, for: .normal)
            buttonArray[selectIndex].titleLabel?.font = textFont
        }
        didSet {
            buttonArray[selectIndex].setTitleColor(selectTextColor, for: .normal)
            buttonArray[selectIndex].titleLabel?.font = selectTextFont
            var x = buttonArray[selectIndex].center.x - width / 2
            x = x > contentView.contentSize.width - width ? contentView.contentSize.width - width : x
            x = x < 0 ? 0 : x
            contentView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
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
    
    private var dataArray: [String] = []
    private var titleWidthArray: [CGFloat] = []
    private var buttonArray: [UIButton] = []
    
    private lazy var contentView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        return view
    }()
    
    init(frame: CGRect = CGRect(x: 0, y: 0, width: ScreenWidth, height: 50), dataArray: [String]) {
        super.init(frame: frame)
        self.dataArray = dataArray
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        contentView.backgroundColor = .clear
        contentView.showsHorizontalScrollIndicator = false
        contentView.frame = frame
        addSubview(contentView)
        
        var totalWidth: CGFloat = 0
        let padding: CGFloat = 30
        
        for i in 0..<dataArray.count {
            let w = dataArray[i].boundingRectWidth(with: ScreenWidth, font: .standard)
            let button = UIButton(type: .custom)
            button.tag = 100 + i
            button.frame = CGRect(x: totalWidth, y: 0, width: w + padding, height: height)
            button.titleLabel?.font = textFont
            button.setTitle(dataArray[i], for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            contentView.addSubview(button)
            buttonArray.append(button)
            titleWidthArray.append(w)
            totalWidth += w + padding
        }
        
        buttonArray[selectIndex].setTitleColor(selectTextColor, for: .normal)
        buttonArray[selectIndex].titleLabel?.font = selectTextFont
        let w = titleWidthArray[0]
        lineView.frame = CGRect(x: w / 2, y: height - 3, width: w, height: 3)
        lineView.backgroundColor = selectTextColor
        contentView.addSubview(lineView)
        contentView.contentSize = CGSize(width: totalWidth, height: height)
        addShadow(.lightShadow, offset: CGSize(width: 0, height: 4))
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        selectIndex = sender.tag - 100
        delegate?.scrollMenuViewDidSelectMenu(index: selectIndex)
    }
    
    func setProgress(_ progress: CGFloat) {
        
        var left = Int(floor(progress))
        var right = Int(ceil(progress))
        left = left <= 0 ? 0 : left
        right = right >= dataArray.count - 1 ? dataArray.count - 1 : right

        var rect = lineView.frame
        let ratio = CGFloat(Int(progress * width) % Int(width)) / width
        //width = 左width + 左到右width差的比例
        rect.size.width = titleWidthArray[left] + (titleWidthArray[right] - titleWidthArray[left]) * ratio
        //x = 左x + 左到右的x差的比例(x是文字的x不是button的)
        let leftX = buttonArray[left].center.x  - titleWidthArray[left] / 2
        let rightX = buttonArray[right].center.x  - titleWidthArray[right] / 2
        rect.origin.x = leftX + (rightX - leftX) * ratio
        lineView.frame = rect
        
    }
    
}


extension ScrollMenuView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollMenuViewDidScroll(scrollView: scrollView)
    }
    
}
