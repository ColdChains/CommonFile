//
//  PointInsideScrollView.swift
//  UnityCar
//
//  Created by lax on 2019/12/3.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class PointInsideScrollView: UIScrollView {
    
    let topView = UIView()
    
    var showView: UIView = UIView()
    
    var bottomView: UIView?
    
    private var fullTopView = false
    
    private var bottomViewShowHeight: CGFloat = 0
    
    /// - Parameters:
    ///   - showView: 顶部可见的视图
    ///   - fullTopView: 是否填满可见区域
    ///   - bottomView: 底部隐藏的视图
    ///   - bottomViewShowHeight: 底部隐藏视图露出的高度
    ///   - bounces: 弹性
    ///   - isPagingEnabled: 分页
    init(showView: UIView,
         fullTopView: Bool = false,
         bottomView: UIView? = nil,
         bottomViewShowHeight: CGFloat = 0,
         bounces: Bool = true,
         isPagingEnabled: Bool = false
    ) {
        
        super.init(frame: CGRect())
        
        delegate = self
        self.bounces = bounces
        self.isPagingEnabled = isPagingEnabled
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        initView(showView: showView,
                 fullTopView: fullTopView,
                 bottomView: bottomView,
                 bottomViewShowHeight: bottomViewShowHeight,
                 bounces: bounces,
                 isPagingEnabled: isPagingEnabled)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if point.y < topView.height - showView.height || !bounds.contains(point) {
            return false
        } else if point.y < topView.height {
            return showView.point(inside: convert(point, to: showView), with: event)
        } else {
            return bottomView?.point(inside: convert(point, to: bottomView), with: event) ?? bounds.contains(point)
        }
    }
    
    func initView(showView: UIView,
        fullTopView: Bool = false,
        bottomView: UIView? = nil,
        bottomViewShowHeight: CGFloat = 0,
        bounces: Bool = true,
        isPagingEnabled: Bool = false) {
        
        self.showView = showView
        self.fullTopView = fullTopView
        self.bottomView = bottomView
        self.bottomViewShowHeight = bottomViewShowHeight
        
        if fullTopView {
            backgroundColor = .background
            addSubview(showView)
            showView.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview().offset(1)
                make.bottom.equalToSuperview()
            }
            return
        }
        
        addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(1 - bottomViewShowHeight)
            if bottomView == nil {
                make.bottom.equalToSuperview()
            }
        }
        
        topView.addSubview(showView)
        showView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        guard let view = bottomView else { return }
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp_bottom)
            make.left.right.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
    func updateBottomViewShowHeight(_ h: CGFloat) {
        bottomViewShowHeight = h
        topView.snp.updateConstraints { (make) in
            make.height.equalToSuperview().offset(1 - bottomViewShowHeight)
        }
    }
    
}

extension PointInsideScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 && bottomView == nil && fullTopView == false {
            scrollView.contentOffset = CGPoint()
        }
    }
    
}
