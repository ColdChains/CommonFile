//
//  ToastView.swift
//  FreightUser
//
//  Created by lax on 2019/8/23.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

extension Toast {
        
    enum Style {
        case normal
        case success
        case error
        case warning
    }

}
    
class Toast : UIView {
    
    private var timer: Timer?
    
    private var style: Style = .normal
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .normal
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        tag = Tag.toast
        backgroundColor = .toast
        layer.cornerRadius = 10
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView(in view: UIView, style: Style, message: String?, delay: Double) {
        
        view.addSubview(self)
        snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(-100)
            make.height.lessThanOrEqualToSuperview().offset(-200)
            if style != .normal {
                make.width.greaterThanOrEqualTo(200)
                make.height.greaterThanOrEqualTo(100)
            }
        }

        switch style {
        case .normal:
            addSubview(tipsLabel)
            tipsLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-10)
            }
        case .success, .error, .warning:
            addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(20)
                make.centerX.equalToSuperview()
                make.width.equalTo(100)
                make.height.equalTo(40)
            }
            addSubview(tipsLabel)
            tipsLabel.snp.makeConstraints { (make) in
                make.top.equalTo(imageView.snp_bottom).offset(5)
                make.bottom.equalToSuperview().offset(-20)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            if message == nil || message == "" {
                imageView.snp.updateConstraints { (make) in
                    make.height.equalTo(100)
                }
            }
        }
        
        tipsLabel.text = message
        switch style {
        case .success:
            imageView.image = R.image.icon_toast_success()
        case .error:
            imageView.image = R.image.icon_toast_success()
        case .warning:
            imageView.image = R.image.icon_toast_warn()
        case .normal:
            layoutIfNeeded()
            layer.cornerRadius = frame.size.height < 40 ? frame.size.height / 2 : 8
        }
        
        DispatchQueue.main.after(delay) {
            self.hide()
        }
    }
    
    func show(in view: UIView, style: Style = .normal, message: String?, delay: Double = 3) {
        view.viewWithTag(Tag.toast)?.removeFromSuperview()
        initView(in: view, style: style, message: message, delay: delay)
        
        UIView.animate(withDuration: TimeIntervalAnimationFast) {
            self.alpha = 1
        }
    }
    
    @objc private func hide() {
        UIView.animate(withDuration: TimeIntervalAnimationFast, animations: {
            self.alpha = 0
        }) { (finish) in
            if finish {
                self.removeFromSuperview()
            }
        }
        timer?.invalidate()
        timer = nil
    }
    
}

extension Toast {
    
    static func show(_ message: String? = "") {
        if message == nil || message == "" { return }
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        Toast().show(in: window, style: .normal, message: message)
    }
    
    static func showSuccess(_ message: String? = "") {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        Toast().show(in: window, style: .success, message: message)
    }
    
    static func showError(_ message: String? = "") {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        Toast().show(in: window, style: .error, message: message)
    }
    
    static func showWarn(_ message: String? = "") {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        Toast().show(in: window, style: .warning, message: message)
    }
    
    static func hide() {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        window.viewWithTag(Tag.toast)?.removeFromSuperview()
    }
    
}
