//
//  AdvertView.swift
//  FreightUser
//
//  Created by lax on 2019/8/23.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class AdvertView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.launch1()
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(hex: "000000", alpha: 0.22)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.titleLabel?.font = .normal
        button.setTitle("3 跳过", for: .normal)
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
        tag = Tag.advert
        backgroundColor = .systemBackground
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-HomeBarHeight - 15)
            make.height.equalTo(30)
            make.width.equalTo(68)
        }
        
    }
    
    func run() {
        _ = DispatchSource.timer(1, total: 3, handler: { count in
            self.closeButton.setTitle("\(count) 跳过", for: .normal)
        }) { 
            self.hide()
        }
    }
    
    @objc private func tapAction() {
        let vc = BaseWebViewController(urlString: "https://www.baidu.com")
        navigationController?.pushViewController(vc, animated: true)
        hide()
    }
    
    func show(in view: UIView?) {
        view?.viewWithTag(Tag.advert)?.removeFromSuperview()
        view?.addSubview(self)
        snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
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
