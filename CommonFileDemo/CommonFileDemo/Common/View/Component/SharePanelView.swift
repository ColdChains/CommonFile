//
//  SharePanelView.swift
//  UnityCar
//
//  Created by lax on 2019/9/11.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class SharePanelView: UIView {

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .container
        return view
    }()
    
    private lazy var wxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.icon_wx(), for: .normal)
        button.addTarget(self, action: #selector(wxButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var wxLabel: UILabel = {
        let label = UILabel()
        label.text = "微信"
        label.font = .small
        label.textColor = .darkText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pyqButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.icon_pyq(), for: .normal)
        button.addTarget(self, action: #selector(pyqButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var pyqLabel: UILabel = {
        let label = UILabel()
        label.text = "朋友圈"
        label.font = .small
        label.textColor = .darkText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .normal
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
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
        
        contentView.addSubview(wxButton)
        wxButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(98 * ScaleWidth)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(48)
        }
        
        contentView.addSubview(wxLabel)
        wxLabel.snp.makeConstraints { (make) in
            make.top.equalTo(wxButton.snp_bottom).offset(15)
            make.centerX.equalTo(wxButton)
        }
        
        contentView.addSubview(pyqButton)
        pyqButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-98 * ScaleWidth)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(48)
        }
        
        contentView.addSubview(pyqLabel)
        pyqLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pyqButton.snp_bottom).offset(15)
            make.centerX.equalTo(pyqButton)
        }
        
        let line = LineView()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(wxLabel.snp_bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp_bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-HomeBarHeight)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        contentView.addGestureRecognizer(tap1)
    }
    
    @objc private func tapAction() {
        
    }
    
    @objc private func wxButtonAction() {
        UMShareManager.share(to: .wechatSession, title: title, description: desc, thumbURL: icon, webpageUrl: url)
        hide()
    }
    
    @objc private func pyqButtonAction() {
        UMShareManager.share(to: .wechatTimeLine, title: title, description: desc, thumbURL: icon, webpageUrl: url)
        hide()
    }
    
    @objc private func cancelButtonAction() {
        hide()
    }
    
    private var title = ""
    private var desc = ""
    private var icon = ""
    private var url = ""
    
    func show(in view: UIView?, title: String, description: String, icon: String, url: String) {
        self.title = title
        self.desc = description
        self.icon = icon
        self.url = url
        
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
            self.removeFromSuperview()
        }
    }

}
