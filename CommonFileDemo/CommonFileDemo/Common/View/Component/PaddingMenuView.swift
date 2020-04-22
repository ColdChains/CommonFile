//
//  PaddingMenuView.swift
//  UnityCar
//
//  Created by lax on 2019/9/8.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

protocol PaddingMenuViewViewDelegate {
    func paddingMenuViewDidSelectMenu(index: Int)
    func paddingMenuViewDidScroll(scrollView: UIScrollView)
}

class PaddingMenuView: UIView {
    
    var delegate: PaddingMenuViewViewDelegate?
    
    var textFont: UIFont = .normal {
        didSet {
            for button in buttonArray {
                button.titleLabel?.font = textFont
            }
        }
    }
    
    var textColor: UIColor = .darkGray {
        didSet {
            for button in buttonArray {
                button.setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    var backColor: UIColor = .line {
        didSet {
            for button in buttonArray {
                button.backgroundColor = backColor
            }
        }
    }
    
    var selectTextColor: UIColor = .darkGray {
        didSet {
            for button in buttonArray {
                button.setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    var selectBackColor: UIColor = .line {
        didSet {
            for button in buttonArray {
                button.backgroundColor = backColor
            }
        }
    }
    
    var padding: CGFloat = 20
    
    var selectIndex = 0 {
        willSet {
            buttonArray[selectIndex].setTitleColor(textColor, for: .normal)
            buttonArray[selectIndex].backgroundColor = backColor
        }
        didSet {
            buttonArray[selectIndex].setTitleColor(selectTextColor, for: .normal)
            buttonArray[selectIndex].backgroundColor = selectBackColor
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
    
    init(frame: CGRect = CGRect(x: 0, y: 0, width: ScreenWidth, height: 50), dataArray: [String], padding: CGFloat = 20) {
        super.init(frame: frame)
        self.dataArray = dataArray
        self.padding = padding
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
        
        for i in 0..<dataArray.count {
            let title = dataArray[i]
            let w = title.boundingRectWidth(with: ScreenWidth, font: .standard)
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: totalWidth, y: (height - 30) / 2, width: w, height: 30)
            button.tag = 100 + i
            button.backgroundColor = backColor
            button.layer.cornerRadius = 15
            button.layer.masksToBounds = true
            button.titleLabel?.font = textFont
            button.setTitle(dataArray[i], for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            contentView.addSubview(button)
            buttonArray.append(button)
            titleWidthArray.append(w)
            totalWidth += w + padding
        }
        
        totalWidth -= padding
        contentView.contentSize = CGSize(width: totalWidth, height: height)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        selectIndex = sender.tag - 100
        delegate?.paddingMenuViewDidSelectMenu(index: selectIndex)
    }
    
}


extension PaddingMenuView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.paddingMenuViewDidScroll(scrollView: scrollView)
    }
    
}

