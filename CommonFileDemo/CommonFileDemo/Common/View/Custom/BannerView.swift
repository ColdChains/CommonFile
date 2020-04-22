//
//  BannerView.swift
//  FreightUser
//
//  Created by lax on 2019/8/27.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

protocol BannerViewDelegate: NSObjectProtocol {
    func sliderViewDidSelectItem(_ index: Int)
    func scroll()
}

class BannerView: UIView {
    
    weak var delegate: BannerViewDelegate?

    var dataArray: [UIImage?] = []
    private var itemViewArray: [UIImageView] = []
    
    private var timer: Timer?
    
    private var isSlider = true
    private var isRepeats = true
    
    private var selectIndex = 0
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl(frame: CGRect())
        page.pageIndicatorTintColor = .lightGray
        page.currentPageIndicatorTintColor = .global
        page.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        return page
    }()
    
    init(frame: CGRect = ScreenBounds, imageArray: [UIImage?], slider: Bool = true, repeats: Bool = true) {
        super.init(frame: frame)
        initView(imageArray: imageArray, slider: slider, repeats: repeats)
    }
    
    private func initView( imageArray: [UIImage?], slider: Bool, repeats: Bool) {
        
        dataArray = imageArray
        isSlider = slider
        isRepeats = repeats
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
        
        reloadData()
    }
    
    func reloadData() {
        
        for itemView in itemViewArray {
            itemView.removeFromSuperview()
        }
        
        for i in 0...dataArray.count + 1 {
            let itemView = UIImageView()
            itemView.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height)
            itemView.tag = 100 + i
            itemView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
            itemView.addGestureRecognizer(tap)
            
            switch i {
            case 0:
                itemView.image = dataArray[dataArray.count - 1]
            case dataArray.count + 1:
                itemView.image = dataArray[0]
            default :
                itemView.image = dataArray[i - 1]
            }
            
            scrollView.addSubview(itemView)
            itemViewArray.append(itemView)
//            itemView.snp.makeConstraints { (make) in
//                if i == 0 {
//                    make.left.equalToSuperview()
//                } else if i == dataArray.count + 1 {
//                    make.left.equalTo(itemViewArray[i - 1].snp_right)
//                    make.right.equalToSuperview()
//                } else {
//                    make.left.equalTo(itemViewArray[i - 1].snp_right)
//                }
//                make.top.bottom.equalToSuperview()
//                make.width.height.equalToSuperview()
//            }
        }
        
        scrollView.contentSize = CGSize(width: width * CGFloat(dataArray.count + 2), height: height)
        scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
        
        pageControl.numberOfPages = dataArray.count
        pageControl.currentPage = 0
        selectIndex = 0
        closeTimer()
        createTimer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func createTimer() {
        if isSlider && timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    
    private func closeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func timerAction() {
        scrollView.setContentOffset(CGPoint(x: width * CGFloat(selectIndex + 2), y: 0), animated: true)
    }
    
    @objc private func pageControlValueChanged() {
        selectIndex = pageControl.currentPage
        scrollView.setContentOffset(CGPoint(x: width * CGFloat(selectIndex + 1), y: 0), animated: true)
    }
    
    @objc private func tapAction(_ tap: UITapGestureRecognizer) {
        guard let tag = tap.view?.tag else { return }
        delegate?.sliderViewDidSelectItem(tag - 100)
    }
    
}

extension BannerView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isRepeats {
            if scrollView.contentOffset.x <= 0 {
                scrollView.setContentOffset(CGPoint(x: width * CGFloat(dataArray.count), y: 0), animated: false)
            } else if scrollView.contentOffset.x >= width * CGFloat(dataArray.count + 1) {
                scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
            }
        } else {
            if scrollView.contentOffset.x <= width {
                scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
            } else if scrollView.contentOffset.x >= width * CGFloat(dataArray.count) {
                scrollView.setContentOffset(CGPoint(x: width * CGFloat(dataArray.count), y: 0), animated: false)
            }
        }
        
        var index = Int((scrollView.contentOffset.x + width / 2) / width) - 1
        if index > dataArray.count - 1 {
            index = 0
        } else if index < 0 {
            index = dataArray.count - 1
        }
        if selectIndex != index {
            selectIndex = index
            pageControl.currentPage = selectIndex
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        closeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        createTimer()
    }
    
}
