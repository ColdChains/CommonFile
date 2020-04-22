//
//  FloatBannerView.swift
//  UnityCar
//
//  Created by lax on 2019/9/3.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import Foundation

class FloatBannerView : UIView {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let bannerView = BannerView(imageArray: [R.image.launch1(), R.image.launch2(), R.image.launch3()], slider: false, repeats: true)
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(hex: "000000", alpha: 0.22)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.titleLabel?.font = .normal
        button.setTitle("关闭", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(hide), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        initView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        tag = Tag.banner
        backgroundColor = .backgroundAlpha
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.height.equalTo(snp_width).multipliedBy(1)
        }
        
        contentView.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-HomeBarHeight - 30)
            make.height.equalTo(44)
            make.width.equalTo(44)
        }
        
    }
    
    @objc private func tapAction() {
        hide()
    }
    
    func show(in view: UIView?) {
        view?.viewWithTag(Tag.banner)?.removeFromSuperview()
        view?.addSubview(self)
        snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        layoutIfNeeded()
        bannerView.reloadData()
    }
    
    @objc private func hide() {
        UIView.animate(withDuration: TimeIntervalAnimationFast, animations: { 
            self.alpha = 0
        }) { finish in
            if finish {
                self.removeFromSuperview()
            }
        }
    }
    
}
