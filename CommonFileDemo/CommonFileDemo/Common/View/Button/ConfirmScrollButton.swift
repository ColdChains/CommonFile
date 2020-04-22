//
//  ConfirmScrollButton.swift
//  UnityCarDriver
//
//  Created by lax on 2020/3/30.
//  Copyright © 2020 ColdChains. All rights reserved.
//

import UIKit

protocol ConfirmScrollButtonDelegate: NSObjectProtocol {
//    func confirmScrollButtonProgress(_ progress: CGFloat)
    func confirmScrollButtonDidScroll()
}

class ConfirmScrollButton: UIButton {
    
    weak var delegate: ConfirmScrollButtonDelegate?
    
    var selectIndex = 0
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    override init(frame: CGRect = CGRect(x: 0, y: 0, width: ScreenWidth - 32, height: 48)) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    private func initView() {
        backgroundColor = .containerBG
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        for i in 0..<2 {
            let imageView = UIImageView(image: R.image.icon_scroll_button())
            imageView.frame = CGRect(x: width * CGFloat(i) + 16, y: 15, width: 21, height: 19)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: width * 2, height: height)
        scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
    }

}

extension ConfirmScrollButton: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = (width - scrollView.contentOffset.x) / width
        let alpha = 1 - progress > 0.1 ? 1 - progress : 0.1
        setTitleColor(UIColor.dynamic(hex: "333333", darkHex: "CCCCCC", alpha: alpha), for: .normal)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectIndex = Int(scrollView.contentOffset.x / width)
        // 0：确认 1：取消
        if (selectIndex == 0) {
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
            delegate?.confirmScrollButtonDidScroll()
        }
    }
    
}
