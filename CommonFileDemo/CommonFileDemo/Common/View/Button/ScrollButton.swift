//
//  ScrollButton.swift
//  FreightDriver
//
//  Created by lax on 2019/12/17.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

protocol ScrollButtonDelegate: NSObjectProtocol {
    func scrollButtonProgress(_ progress: CGFloat)
    func scrollButtonDidScroll()
}

class ScrollButton: UIScrollView {
    
    weak var viewDelegate: ScrollButtonDelegate?
    
    var selectIndex = 0

    override init(frame: CGRect = CGRect(x: 0, y: 0, width: ScreenWidth - 32, height: 48)) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        delegate = self
        bounces = false
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        
        for i in 0..<2 {
            let imageView = UIImageView(image: R.image.icon_scroll_button())
            imageView.frame = CGRect(x: width * CGFloat(i) + 16, y: 15, width: 21, height: 19)
            addSubview(imageView)
        }
        contentSize = CGSize(width: width * 2, height: height)
        setContentOffset(CGPoint(x: width, y: 0), animated: false)
    }

}

extension ScrollButton: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = (width - scrollView.contentOffset.x) / width
        viewDelegate?.scrollButtonProgress(progress)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectIndex = Int(scrollView.contentOffset.x / width)
        // 0：确认 1：取消
        if (selectIndex == 0) {
            setContentOffset(CGPoint(x: width, y: 0), animated: false)
            viewDelegate?.scrollButtonDidScroll()
        }
    }
    
}
