//
//  TouchImageView.swift
//  FreightDriver
//
//  Created by lax on 2020/1/13.
//  Copyright © 2020 ColdChains. All rights reserved.
//

import Foundation

class TouchImageView: UIImageView {
    
    private var imageView = UIImageView()
    
    private var originalFrame = CGRect()
    
    private lazy var bgView: UIScrollView = {
        let bgView = UIScrollView(frame: ScreenBounds)
        bgView.showsVerticalScrollIndicator = false
        bgView.showsHorizontalScrollIndicator = false
        bgView.maximumZoomScale = 2
        bgView.delegate = self
        return bgView
    }()
    
    override init(frame: CGRect = CGRect()) {
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
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showZoomImageView(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc private func showZoomImageView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? UIImageView, let image = view.image else { return }
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        bgView.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        bgView.addGestureRecognizer(doubleTap)
        //只有当doubleTapGesture识别失败的时候(即识别出这不是双击操作)，singleTapGesture才能开始识别
        singleTap.require(toFail: doubleTap)
        
        imageView.image = image
        imageView.frame = bgView.convert(frame, from: superview)
        bgView.addSubview(imageView)
        bgView.setZoomScale(1, animated: false)
        originalFrame = imageView.frame
        
        AppDelegate.shared.window?.addSubview(bgView)
        
        UIView.animate(withDuration: TimeIntervalAnimation) {
            var rect = self.imageView.frame
            rect.size.width = self.bgView.frame.size.width
            rect.size.height = rect.size.width * (image.size.height / image.size.width)
            rect.origin.x = 0
            rect.origin.y = (self.bgView.frame.size.height - rect.size.height) / 2
            self.imageView.frame = rect
            self.bgView.backgroundColor = .black
        }
        
    }
    
    @objc private func singleTapAction(_ sender: UITapGestureRecognizer) {
        bgView.contentOffset = CGPoint()
        UIView.animate(withDuration: TimeIntervalAnimation, animations: {
            self.imageView.frame = self.originalFrame
            sender.view?.backgroundColor = .clear
        }) { (finish) in
            if finish {
                sender.view?.removeFromSuperview()
            }
        }
    }
    
    @objc private func doubleTapAction(_ sender: UITapGestureRecognizer) {
        if bgView.zoomScale > 1.5 {
            bgView.setZoomScale(1, animated: true)
        } else {
            bgView.setZoomScale(2, animated: true)
        }
    }
    
}

extension TouchImageView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
