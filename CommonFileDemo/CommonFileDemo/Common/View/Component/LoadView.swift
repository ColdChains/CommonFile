//
//  LoadView.swift
//  FreightUser
//
//  Created by lax on 2019/8/26.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

extension LoadView {
    
    enum Status {
        case none
        case loading
        case error
        case nodata
    }
    
}

class LoadView: UIView {
    
    var reloadClosure: (() -> Void)?
    
    var loadMessage: String?
    var errorMessage: String?
    var errorImage: UIImage?
    var nodataMessage: String?
    var nodataImage: UIImage?
    
    var status: Status = .none {
        didSet {
            switch status {
            case .loading:
                indicatorView.isHidden = false
                imageView.isHidden = true
                tipsLabel.text = loadMessage
                tipsLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(indicatorView.snp_bottom).offset(16)
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                }
            case .error:
                indicatorView.isHidden = true
                imageView.isHidden = false
                imageView.image = errorImage
                tipsLabel.text = errorMessage
                tipsLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(imageView.snp_bottom).offset(16)
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                }
            case .nodata:
                indicatorView.isHidden = true
                imageView.isHidden = false
                imageView.image = nodataImage
                tipsLabel.text = nodataMessage
                tipsLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(imageView.snp_bottom).offset(16)
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                }
            default:
                break
            }
        }
    }
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let active = UIActivityIndicatorView()
        active.color = .lightGray
        active.hidesWhenStopped = true
        active.startAnimating()
        return active
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .normal
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tag = Tag.load
        let tap = UITapGestureRecognizer(target: self, action: #selector(reloadAction))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 加载视图
    /// - Parameters:
    ///   - view: 父视图
    ///   - status: 加载状态
    ///   - top: 距父视图顶部距离
    ///   - load: 加载中的文字
    ///   - error: 加载失败文字
    ///   - errorImage: 加载失败图片
    ///   - nodata: 空数据文字
    ///   - nodataImage: 空数据图片
    func show(
        in view: UIView,
        status: Status = .loading,
        top: CGFloat = 0,
        load: String? = nil,
        error: String? = nil,
        errorImage: UIImage? = nil,
        nodata: String? = nil,
        nodataImage: UIImage? = nil
    ) {
        
        view.viewWithTag(Tag.load)?.removeFromSuperview()
        view.addSubview(self)
        
        snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(top)
            make.left.right.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-top / 2)
        }
        
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-32)
        }
        
        addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(indicatorView.snp_bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        loadMessage = load
        errorMessage = error
        nodataMessage = nodata
        self.errorImage = errorImage
        self.nodataImage = nodataImage
        self.status = status
    }
    
    @objc private func reloadAction() {
        if status == .error && reloadClosure != nil {
            status = .loading
            reloadClosure?()
        }
    }
    
}

extension UIView {

    func loading(_ message: String? = nil, top: CGFloat = 0) {
        if let loadView = viewWithTag(Tag.load) as? LoadView {
            loadView.status = .loading
        } else {
            LoadView().show(in: self, top: top, load: message)
        }
    }

    func endLoading() {
        viewWithTag(Tag.load)?.removeFromSuperview()
    }

    func showErrorView(_ message: String? = "加载失败了，请稍后再试", image: UIImage? = R.image.image_nodata_error(), top: CGFloat = 0) {
        if let loadView = viewWithTag(Tag.load) as? LoadView {
            loadView.errorMessage = message
            loadView.errorImage = image
            loadView.status = .error
        } else {
            LoadView().show(in: self, status: .error, top: top, error: message, errorImage
                : image)
        }
    }

    func hideErrorView() {
        viewWithTag(Tag.load)?.removeFromSuperview()
    }

    func showNoDataView(_ message: String? = nil, image: UIImage?, top: CGFloat = 0) {
        if let loadView = viewWithTag(Tag.load) as? LoadView {
            loadView.nodataMessage = message
            loadView.nodataImage = image
            loadView.status = .nodata
        } else {
            LoadView().show(in: self, status: .nodata, top: top, nodata: message, nodataImage: image)
        }
        if let loadView = viewWithTag(Tag.load) as? LoadView {
            sendSubviewToBack(loadView)
        }
    }

    func hideNoDataView() {
        viewWithTag(Tag.load)?.removeFromSuperview()
    }

    func reloadClosure(_ reload: (() -> Void)?) {
        if let loadView = viewWithTag(Tag.load) as? LoadView {
            loadView.reloadClosure = reload
        }
    }

}
