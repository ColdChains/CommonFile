//
//  TimePickerView.swift
//  FreightDriver
//
//  Created by lax on 2019/12/31.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

extension TimePickerView {
    
    enum Style {
        case hour
        case hourminute
        case hourminutesecond
    }
    
}

protocol TimePickerViewDelegate : NSObjectProtocol {
    func timePickerViewDidSelect(hour: Int, minute: Int, second: Int)
}

class TimePickerView: UIView {
    
    weak var delegate: TimePickerViewDelegate?
    
    var style: Style = .hourminutesecond
    
    var dataArray: [[String]] = []
    
    private var contentViewHeight: CGFloat = 0
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .container
        return view
    }()
    
    private lazy var components: DateComponents = {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute, .second], from: Date())
        return comp
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .custom)
        cancelButton.titleLabel?.font = .normal
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.darkText, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var confirmButton: UIButton = {
        let confirmButton = UIButton(type: .custom)
        confirmButton.titleLabel?.font = .normal
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(.global, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        return confirmButton
    }()
    
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        return view
    }()
    
    /// 时间选择器 时 分 秒
    /// - Parameters:
    ///   - style: 选择器样式
    ///   - value: 默认时间（以:分割 如20:20:20）
    init(style: Style = .hourminutesecond, value: String? = nil) {
        super.init(frame: ScreenBounds)
        self.style = style
        initView(value: value)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView(value: String? = nil) {
        contentViewHeight = 240 * ScaleWidth + 44 + HomeBarHeight;
        
        alpha = 0
        backgroundColor = .backgroundAlpha
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(contentViewHeight)
            make.bottom.equalToSuperview().offset(contentViewHeight)
        }
        
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(44)
        }
        
        contentView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(44)
        }
        
        contentView.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(44)
            make.left.right.bottom.equalToSuperview()
        }
        
        initData(value: value)
    }
    
    private func initData(value: String? = nil) {
        //数据源
        let currentHour = components.hour! - 1
        let currentMinute = components.minute! - 1
        let currentSecond = components.second! - 1
        
        var arr: [String] = []
        for i in 0...23 {
            arr.append(String(format: "%02d时", i))
        }
        dataArray.append(arr)
        if style != .hour {
            var arr: [String] = []
            for i in 0...59 {
                arr.append(String(format: "%02d分", i))
            }
            dataArray.append(arr)
        }
        if style == .hourminutesecond {
            var arr: [String] = []
            for i in 0...59 {
                arr.append(String(format: "%02d秒", i))
            }
            dataArray.append(arr)
        }
        
        //设置默认值
        var hourValue = 0
        var minuteValue = 0
        var secondValue = 0
        if var str = value {
            str = str.replacingOccurrences(of: "时", with: ":")
            str = str.replacingOccurrences(of: "分", with: ":")
            str = str.replacingOccurrences(of: "秒", with: "")
            let arr = str.components(separatedBy: ":")
            if arr.count > 0 {
                hourValue = Int(arr[0]) ?? 0
            }
            if arr.count > 1 {
                minuteValue = Int(arr[1]) ?? 0
            }
            if arr.count > 2 {
                secondValue = Int(arr[2]) ?? 0
            }
        }
        
        var hourIndex = currentHour
        var minuteIndex = currentMinute
        var secondIndex = currentSecond
        
        for i in 0..<dataArray[0].count {
            if hourValue == i {
                hourIndex = i
            }
        }
        for i in 0..<dataArray[1].count {
            if minuteValue == i {
                minuteIndex = i
            }
        }
        for i in 0..<dataArray[1].count {
            if secondValue == i {
                secondIndex = i
            }
        }
        
        //初始化选中的行
        pickerView.selectRow(hourIndex, inComponent: 0, animated: true)
        if style == .hourminute || style == .hourminutesecond {
            pickerView.selectRow(minuteIndex, inComponent: 1, animated: true)
        }
        if style == .hourminutesecond {
            pickerView.selectRow(secondIndex, inComponent: 2, animated: true)
        }
    }
    
    @objc private func cancelButtonAction() {
        hide()
    }
    
    @objc private func confirmButtonAction() {
        let currentHour = pickerView.selectedRow(inComponent: 0) + 1
        var currentMinute = 0
        var currentSecond = 0
        if style == .hourminute || style == .hourminutesecond {
            currentMinute = pickerView.selectedRow(inComponent: 1) + 1
        }
        if style == .hourminutesecond {
            currentSecond = pickerView.selectedRow(inComponent: 2) + 1
        }
        delegate?.timePickerViewDidSelect(hour: currentHour, minute: currentMinute, second: currentSecond)
        hide()
    }
    
    @objc private func tapAction() {
        hide()
    }
    
    func show(in view: UIView?, topRadius: CGFloat = 4) {
        view?.addSubview(self)
        snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        layoutIfNeeded()
        UIView.animate(withDuration: TimeIntervalAnimation) {
            self.contentView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().offset(0)
            })
            self.alpha = 1
            self.layoutIfNeeded()
        }
        _ = contentView.clipsTopCornerRadius(topRadius)
    }
    
    func hide() {
        UIView.animate(withDuration: TimeIntervalAnimation, animations: {
            self.contentView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().offset(self.contentViewHeight)
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


extension TimePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return ScreenWidth / 4
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = .standardBold
        label.textAlignment = .center
        label.text = dataArray[component][row]
        return label
    }
    
}
