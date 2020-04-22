//
//  CodeButton.swift
//  FreightUser
//
//  Created by lax on 2019/8/29.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

protocol CodeButtonDelegate : NSObjectProtocol {
    func codeButtonDidSelect()
}

class CodeButton: UIButton {
    
    weak var delegate: CodeButtonDelegate?
    
    private var timer: DispatchSourceTimer?
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "enabled")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil, timer != nil {
            timer?.cancel()
            timer = nil
        }
    }
    
    private func initView() {
        addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        if isEnabled {
            setTitleColor(.global, for: .normal)
            setTitleColor(.global, for: .highlighted)
        } else {
            setTitleColor(.lightGray, for: .normal)
            setTitleColor(.lightGray, for: .highlighted)
        }
        addObserver(self, forKeyPath: "enabled", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let path = keyPath, path == "enabled" {
            if isEnabled {
                setTitleColor(.global, for: .normal)
                setTitleColor(.global, for: .highlighted)
            } else {
                setTitleColor(.lightGray, for: .normal)
                setTitleColor(.lightGray, for: .highlighted)
            }
        }
    }
    
    @objc private func buttonAction() {
        FeedbackGeneratorManager.occurredSoft()
        delegate?.codeButtonDidSelect()
    }
    
    func createTimer() {
        if timer != nil { return }
        isEnabled = false
        timer = DispatchSource.timer(1, total: 60, handler: { (count) in
            self.setTitleColor(.lightGray, for: .normal)
            self.setTitle(String(format: "%02ds", count), for: .normal)
        }) {
            self.stopTimer()
        }
    }
    
    func stopTimer() {
        if timer == nil { return }
        timer?.cancel()
        timer = nil
        isEnabled = true
        setTitleColor(.global, for: .normal)
        setTitle("再次获取", for: .normal)
    }
    
}
