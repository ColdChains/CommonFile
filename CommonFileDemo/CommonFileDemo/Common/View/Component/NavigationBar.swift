//
//  CustomNavigationBar.swift
//  FreightUser
//
//  Created by lax on 2019/8/23.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

extension NavigationBar {
       
    enum Style {
        case darkContent
        case lightContent
        case webview
    }
    
}

protocol NavigationBarDelegate : NSObjectProtocol {
    func navigationBarDidSelectLeftItem()
    func navigationBarDidSelectCloseItem()
    func navigationBarDidSelectRightItem()
}

final class NavigationBar: UIView {
    
    weak var delegate: NavigationBarDelegate?
    
    var style: Style = .darkContent {
        didSet {
            switch style {
            case .darkContent:
                setDarkContentStyle()
            case .lightContent:
                setLightContentStyle()
            case .webview:
                setWebViewStyle()
            }
        }
    }
    
    lazy var leftBarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .normal
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var closeBarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.titleLabel?.font = .normal
        button.setImage(R.image.icon_close(), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var rightBarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .normal
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .titleBold
        label.textAlignment = .center
        return label
    }()
    
    var titleView: UIView = UIView() {
        willSet {
            titleLabel.removeFromSuperview()
            titleView.removeFromSuperview()
        }
        didSet {
            addSubview(titleView)
            sendSubviewToBack(titleView)
            titleView.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(44)
                make.centerX.equalToSuperview()
                make.width.equalTo(titleView.width > 0 ? titleView.width : ScreenWidth - 100)
            }
        }
    }
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .line
        line.isHidden = true
        return line
    }()
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        
        addSubview(leftBarButton)
        leftBarButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(44)
        }
        
        addSubview(closeBarButton)
        closeBarButton.snp.makeConstraints { (make) in
            make.left.equalTo(leftBarButton.snp_right)
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(44)
        }

        addSubview(rightBarButton)
        rightBarButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(44)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(ScreenWidth - 88)
        }
        
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        layer.zPosition = .greatestFiniteMagnitude
        backgroundColor = .navigation
        setDarkContentStyle()
        addShadow(.lightShadow, offset: CGSize(width: 0, height: 4))
        
        rightBarButton.titleLabel?.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else { return }
        if keyPath == "text", let title = change[NSKeyValueChangeKey.newKey] as? String {
            var w = title.boundingRectWidth(with: 100, font: rightBarButton.titleLabel?.font) + 20
            w = w > 44 ? w : 44
            rightBarButton.snp.remakeConstraints { (make) in
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(44)
                make.width.equalTo(w)
            }
            titleLabel.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(44)
                make.centerX.equalToSuperview()
                make.width.lessThanOrEqualTo(ScreenWidth - w * 2)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        rightBarButton.titleLabel?.removeObserver(self, forKeyPath: "text")
    }
    
    @objc private func leftButtonAction() {
        delegate?.navigationBarDidSelectLeftItem()
    }
    
    @objc private func closeButtonAction() {
        delegate?.navigationBarDidSelectCloseItem()
    }
    
    @objc private func rightButtonAction() {
        delegate?.navigationBarDidSelectRightItem()
    }
    
    private func setDarkContentStyle() {
        titleLabel.textColor = .darkText
        leftBarButton.setImage(R.image.icon_back_gray(), for: .normal)
        leftBarButton.setTitleColor(.darkText, for: .normal)
        rightBarButton.setTitleColor(.darkText, for: .normal)
    }
    
    private func setLightContentStyle() {
        titleLabel.textColor = .white
        leftBarButton.setImage(R.image.icon_back_white(), for: .normal)
        leftBarButton.setTitleColor(.white, for: .normal)
        rightBarButton.setTitleColor(.white, for: .normal)
        lineView.isHidden = true
    }
    
    private func setWebViewStyle() {
        let title = rightBarButton.titleLabel?.text ?? ""
        var w = title.boundingRectWidth(with: 100, font: rightBarButton.titleLabel?.font) + 20
        w = w > 88 ? w : 88
        titleLabel.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(ScreenWidth - w * 2)
        }
    }
    
}
