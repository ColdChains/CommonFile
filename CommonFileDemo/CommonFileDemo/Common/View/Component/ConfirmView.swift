//
//  ConfirmView.swift
//  UnityCar
//
//  Created by lax on 2019/9/11.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class ConfirmView: UIView {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .container
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bigMedium
        label.textColor = .darkText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = .standard
        label.textColor = .darkText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = DefaultBorderButton()
        button.titleLabel?.font = .standard
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = BackgroundGlobalButton()
        button.titleLabel?.font = .standard
        button.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: ScreenBounds)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        alpha = 0
        backgroundColor = .backgroundAlpha
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp_bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(48)
        }
        
        contentView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp_bottom).offset(30)
            make.left.equalTo(cancelButton.snp_right).offset(35)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(48)
            make.width.equalTo(cancelButton)
            make.bottom.equalToSuperview().offset(-20 - HomeBarHeight)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        contentView.addGestureRecognizer(tap1)
    }
    
    @objc private func tapAction() {
        
    }
    
    @objc private func confirmButtonAction() {
        confirmBlock?()
        hide()
    }
    
    @objc private func cancelButtonAction() {
        cancelBlock?()
        hide()
    }
    
    private var title = ""
    private var desc = ""
    private var icon = ""
    private var url = ""
    
    var cancelBlock: (() -> Void)? = nil
    var confirmBlock: (() -> Void)? = nil
    
    func showWithCancel(in view: UIView?, title: String, description: String, cancelText: String = "取消", confirmText: String = "确认", cancelBlock: (() -> Void)? = nil, confirmBlock: (() -> Void)? = nil) {
        show(in: view, title: title, description: description, cancelText: cancelText, confirmText: confirmText, cancelBlock: cancelBlock, confirmBlock: confirmBlock)
    }
    
    func show(in view: UIView?, title: String, description: String, cancelText: String? = nil, confirmText: String = "确认", cancelBlock: (() -> Void)? = nil, confirmBlock: (() -> Void)? = nil) {
        
        titleLabel.text = title
        descLabel.text = description
        cancelButton.setTitle(cancelText, for: .normal)
        confirmButton.setTitle(confirmText, for: .normal)
        
        self.cancelBlock = cancelBlock
        self.confirmBlock = confirmBlock
        
        if cancelText == nil {
            cancelButton.removeFromSuperview()
//            cancelButton.snp.makeConstraints { (make) in
//                make.top.equalTo(descLabel.snp_bottom).offset(30)
//                make.left.equalToSuperview().offset(20)
//                make.height.equalTo(48)
//            }
            
            confirmButton.snp.remakeConstraints { (make) in
                make.top.equalTo(descLabel.snp_bottom).offset(30)
//                make.left.equalTo(cancelButton.snp_right).offset(35)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(48)
//                make.width.equalTo(cancelButton)
                make.bottom.equalToSuperview().offset(-20 - HomeBarHeight)
            }
        }
        
        view?.addSubview(self)
        snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        layoutIfNeeded()
        contentView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(contentView.height)
        }
        layoutIfNeeded()
        UIView.animate(withDuration: TimeIntervalAnimation) { 
            self.contentView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().offset(0)
            })
            self.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: TimeIntervalAnimation, animations: { 
            self.contentView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().offset(self.contentView.height)
            })
            self.alpha = 0
            self.layoutIfNeeded()
        }) { finish in
            if finish {
                self.removeFromSuperview()
            }
        }
    }
    
}
