//
//  FloatButton.swift
//  FreightUser
//
//  Created by lax on 2019/8/27.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

protocol FloatButtonDelegate: NSObjectProtocol {
    func floatButtonDidSelect()
}

class FloatButton: UIView {
    
    weak var delegate: FloatButtonDelegate?
    
    private var timer: DispatchSourceTimer?
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .normal
        button.setTitleColor(.white, for: .normal)
        button.setTitle("安全中心", for: .normal)
        return button
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: ScreenHeight - (70 + 38 + HomeBarHeight) - 20, width: 110, height: 34))
        backgroundColor = .global
        layer.cornerRadius = 17
        layer.masksToBounds = true
        
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
//        createTimer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        timer?.cancel()
        timer = nil
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil, timer != nil {
            timer?.cancel()
            timer = nil
        }
    }

//    func createTimer() {
//        if timer != nil {
//            timer?.cancel()
//            timer = nil
//        }
//        timer = DispatchSource.timer(1, total: 60, handler: { progress in
//            self.button.setTitle("1笔订单待支付 \(Int(progress))", for: .normal)
//        }) {
//            self.button.setTitle("1笔订单待支付", for: .normal)
//            self.timer = nil
//        }
//    }
    
    private var moveStepX: CGFloat = 0
    private var moveStepY: CGFloat = 0
    private var minTop: CGFloat = NavigationBarHeight
    private var maxTop: CGFloat = ScreenHeight - 34 - HomeBarHeight - 70
}

extension FloatButton {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    private func moveToDefaultPosition() {
        var rect = frame
        if rect.origin.x <= (ScreenWidth - rect.size.width) / 2 {
            rect.origin.x = 0
        } else {
            rect.origin.x = ScreenWidth - rect.size.width
        }
        if rect.origin.y < minTop {
            rect.origin.y = minTop
        } else if rect.origin.y > maxTop {
            rect.origin.y = maxTop
        }
        UIView.animate(withDuration: TimeIntervalAnimation) { 
            self.frame = rect
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        moveStepX = 0;
        moveStepY = 0;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if abs(moveStepX) < 1 && abs(moveStepY) < 1 {
            delegate?.floatButtonDidSelect()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (0.1 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC) , execute: { 
            self.moveToDefaultPosition()
        })
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if #available(iOS 9.1, *) {
            let touch = touches[touches.startIndex]
            let currentPoint = touch.location(in: self)
            let oldPoint = touch.precisePreviousLocation(in: self)
            let x = currentPoint.x - oldPoint.x
            let y = currentPoint.y - oldPoint.y
            moveStepX += x
            moveStepY += y
            transform = CGAffineTransform(translationX: x, y: y).concatenating(transform)
        } else {
            // Fallback on earlier versions
        }
    }
    
}
