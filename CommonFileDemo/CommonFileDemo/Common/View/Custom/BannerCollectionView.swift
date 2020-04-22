//
//  BannerCollectionView.swift
//  FreightUser
//
//  Created by lax on 2019/8/29.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

protocol BannerCollectionViewDelegate: NSObjectProtocol {
    func bannerCollectionViewDidSelectItem(_ index: Int)
}

class BannerCollectionView: UIView {
    
    weak var delegate: BannerCollectionViewDelegate?
    
    var dataArray: [UIImage?] = []
    
    private var timer: Timer?
    
    private var isSlider = true
    private var isRepeats = true
    
    private var selectIndex = 0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets()
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UINib(nibName: CommonCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: CommonCollectionViewCell.className)
        return collectionView
    }()
    
    private var isSelectPageControl = false
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
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
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
        collectionView.reloadData()
        collectionView.setContentOffset(CGPoint(x: width * CGFloat(dataArray.count + 1), y: 0), animated: false)
        
        pageControl.numberOfPages = dataArray.count
        pageControl.currentPage = 0
        selectIndex = 0
        closeTimer()
        createTimer()
    }
    
    func layoutIfNeeded(_ width: CGFloat) {
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.setContentOffset(CGPoint(x: width * CGFloat(dataArray.count + 1), y: 0), animated: false)
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.setContentOffset(CGPoint(x: width * CGFloat(dataArray.count + 1), y: 0), animated: false)
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
        collectionView.setContentOffset(CGPoint(x: width * CGFloat(selectIndex + 2), y: 0), animated: true)
    }
    
    @objc private func pageControlValueChanged() {
        isSelectPageControl = true
        selectIndex = pageControl.currentPage
        collectionView.setContentOffset(CGPoint(x: width * CGFloat(selectIndex + 1), y: 0), animated: true)
    }
    
}

extension BannerCollectionView : UIScrollViewDelegate {
    
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
        if selectIndex != index && !isSelectPageControl {
            selectIndex = index
            pageControl.currentPage = selectIndex
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        closeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        createTimer()
        isSelectPageControl = false
    }
    
}

extension BannerCollectionView : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCollectionViewCell.className, for: indexPath) as! CommonCollectionViewCell
        switch indexPath.row {
        case 0:
            cell.imageView.image = dataArray[dataArray.count - 1]
        case dataArray.count + 1:
            cell.imageView.image = dataArray[0]
        default :
            cell.imageView.image = dataArray[indexPath.row - 1]
        }
        cell.titleLabel.text = "\(indexPath.row)"
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.bannerCollectionViewDidSelectItem(indexPath.item)
    }
    
}
