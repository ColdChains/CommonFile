//
//  HUDView.swift
//  FreightUser
//
//  Created by lax on 2019/8/23.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

extension HUDView {
    
    enum Style {
        case `default`
        case light
    }
    
}

class HUDView: UIView {
    
    static let shared = HUDView()
    
    var style: Style = .default {
        didSet {
            switch style {
            case .light:
                setStyleLight()
            default:
                setStyleDefault()
            }
        }
    }
    
    private var contentView: CornerRadiusShadowView = {
        let view = CornerRadiusShadowView()
        return view
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let active = UIActivityIndicatorView(style: .whiteLarge)
        active.hidesWhenStopped = true
        active.startAnimating()
        return active
    }()
    
    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .normal
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        tag = Tag.hud
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func show(in view: UIView? = AppDelegate.shared.window, top offset: CGFloat = 0, message: String?) {
        guard let _ = view else { return }
        view!.viewWithTag(Tag.hud)?.removeFromSuperview()
        view!.addSubview(self)
        
        var rect = view!.frame
        rect.origin.y = offset
        rect.size.height -= offset
        frame = rect
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-offset / 2)
        }
        
        contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(25)
            make.left.right.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        tipsLabel.text = message
        contentView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(indicatorView.snp_bottom).offset(5)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        setStyleDefault()
        
        if message != "正在加载" { return }
        DispatchQueue.main.after(5) {
            self.loadSlow()
        }
    }
    
    private func loadSlow() {
        indicatorView.color = .lightGlobal
        tipsLabel.textColor = .lightGlobal
        tipsLabel.text = "加载缓慢"
    }
    
    private func hide() {
        removeFromSuperview()
    }
    
    private func setStyleDefault() {
        backgroundColor = .clear
        contentView.backgroundColor = .backgroundAlpha
        indicatorView.style = .whiteLarge
        indicatorView.color = .white
        tipsLabel.textColor = .white
    }
    
    private func setStyleLight() {
        backgroundColor = .clear
        contentView.backgroundColor = .systemBackground
        indicatorView.style = .whiteLarge
        indicatorView.color = .darkGray
        tipsLabel.textColor = .lightGray
    }

}

extension HUDView {
    
    static func show(_ message: String? = nil) {
        shared.show(message: message)
    }
    
    static func hide() {
        shared.hide()
    }
    
}
