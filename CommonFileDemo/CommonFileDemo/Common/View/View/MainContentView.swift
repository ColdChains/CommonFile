//
//  MainContentView.swift
//  UnityCar
//
//  Created by lax on 2019/9/9.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class MainContentView: UIView {
    
    private var subViewArray: [UIView] = []
    
    var maxCount: Int {
        return subViewArray.count
    }
    
    private var pushAnimation = true
    
    private var pointInSide = false
    
    private var oldIndex = 0
    
    var selectIndex = 0 {
        willSet {
            if selectIndex >= 0 && selectIndex < maxCount {
                oldIndex = selectIndex
            }
        }
        didSet {
            if selectIndex >= 0 && selectIndex < maxCount {
                push(from: oldIndex, to: selectIndex)
            }
            print(oldIndex, selectIndex)
        }
    }
    
    /// - Parameters:
    ///   - subviews: 子视图数组
    ///   - pushAnimation: 切换动画
    ///   - pointInSide: 手势响应是否需要根据子视图判断
    init(_ subviews: [UIView] = [],
         pushAnimation: Bool = true,
         pointInSide: Bool = false
    ) {
        self.subViewArray = subviews
        self.pushAnimation = pushAnimation
        self.pointInSide = pointInSide
        super.init(frame: CGRect())
        
        layer.masksToBounds = true
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if !bounds.contains(point) {
            return false
        }
        if pointInSide {
            return subViewArray[selectIndex].point(inside: convert(point, to: subViewArray[selectIndex]), with: event)
        }
        return true
    }
    
    func initView() {
        for i in 0..<subViewArray.count {
            addSubview(subViewArray[i])
            if i == 0 {
                subViewArray[i].snp.makeConstraints { (make) in
                    make.left.top.equalToSuperview()
                    make.width.height.equalToSuperview()
                }
            } else {
                subViewArray[i].snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.top.equalTo(snp_bottom)
                    make.width.height.equalToSuperview()
                }
            }
        }
    }
    
    private func push(from fromIndex: Int, to toIndex: Int) {
        guard fromIndex >= 0 && fromIndex < subViewArray.count else { return }
        guard toIndex >= 0 && toIndex < subViewArray.count else { return }
        let fromView = subViewArray[fromIndex]
        let toView = subViewArray[toIndex]
        if fromIndex < toIndex {
            fromView.snp.remakeConstraints { (make) in
                make.left.top.equalToSuperview()
                make.width.height.equalToSuperview()
            }
            toView.snp.remakeConstraints { (make) in
                make.left.equalTo(fromView.snp_right)
                make.top.equalToSuperview()
                make.width.height.equalToSuperview()
            }
            layoutIfNeeded()
            UIView.animate(withDuration: pushAnimation ? TimeIntervalAnimation : 0) {
                fromView.snp.updateConstraints { (make) in
                    make.left.equalToSuperview().offset(-self.width)
                }
                self.layoutIfNeeded()
            }
        } else if fromIndex > toIndex {
            fromView.snp.remakeConstraints { (make) in
                make.left.top.equalToSuperview()
                make.width.height.equalToSuperview()
            }
            toView.snp.remakeConstraints { (make) in
                make.right.equalTo(fromView.snp_left)
                make.top.equalToSuperview()
                make.width.height.equalToSuperview()
            }
            layoutIfNeeded()
            UIView.animate(withDuration: pushAnimation ? TimeIntervalAnimation : 0) {
                fromView.snp.updateConstraints { (make) in
                    make.left.equalToSuperview().offset(self.width)
                }
                self.layoutIfNeeded()
            }
        }
    }
    
}

