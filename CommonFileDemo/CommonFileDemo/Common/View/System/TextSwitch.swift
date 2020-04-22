//
//  TextSwitch.swift
//  FreightDriver
//
//  Created by lax on 2019/12/16.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

protocol TextSwitchDelegate: NSObjectProtocol {
    func textSwitchValueChanged(isOn: Bool)
}

class TextSwitch: UIView {
     
    weak var delegate: TextSwitchDelegate?
    
    private var padding: CGFloat = 2
    
    var onText: String = "工作中" {
        didSet {
            onLabel.text = onText
        }
    }
    
    var offText: String = "休息中" {
        didSet {
            offLabel.text = offText
        }
    }
    
    var isOn = false {
        didSet {
            layoutIfNeeded()
            UIView.animate(withDuration: TimeIntervalAnimationFast) {
                if self.isOn {
                    self.contentView.snp.updateConstraints { (make) in
                        make.width.equalTo(self.height - 4)
                    }
                    self.backgroundColor = .global
                } else {
                    self.contentView.snp.updateConstraints { (make) in
                        make.width.equalTo(self.width - 4)
                    }
                    self.backgroundColor = .lightGray
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var circle: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addShadow()
        return view
    }()
    
    private lazy var onLabel: UILabel = {
        let label = UILabel()
        label.text = onText
        label.font = .small
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var offLabel: UILabel = {
        let label = UILabel()
        label.text = offText
        label.font = .small
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonAction))
        addGestureRecognizer(tap)
        
        backgroundColor = .lightGray
        layer.cornerRadius = height / 2
        circle.layer.cornerRadius = height / 2 - padding
        contentView.layer.cornerRadius = height / 2 - padding
        
        addSubview(onLabel)
        onLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(padding)
            make.top.bottom.equalToSuperview()
        }
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(onLabel.snp_right)
            make.top.equalToSuperview().offset(padding)
            make.right.bottom.equalToSuperview().offset(-padding)
            make.width.equalTo(width - padding * 2)
        }
        contentView.addSubview(circle)
        circle.snp.makeConstraints { (make) in
            make.left.equalTo(onLabel.snp_right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(circle.snp_height).multipliedBy(1)
        }
        contentView.addSubview(offLabel)
        offLabel.snp.makeConstraints { (make) in
            make.left.equalTo(circle.snp_right)
            make.right.top.bottom.equalToSuperview()
        }
    }
    
    @objc private func buttonAction() {
        FeedbackGeneratorManager.occurredMedium()
        isOn = !isOn
        delegate?.textSwitchValueChanged(isOn: isOn)
    }

}
