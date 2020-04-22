//
//  ConfigDatePicker.swift
//  FreightDriver
//
//  Created by lax on 2020/1/2.
//  Copyright © 2020 ColdChains. All rights reserved.
//

import Foundation

protocol ConfigDatePickerDelegate : NSObjectProtocol {
    func configDatePickerViewDidSelect(date: String)
}

class ConfigDatePicker: UIView {
    
    weak var delegate: ConfigDatePickerDelegate?
    
    var dataArray: [[String]] = []
    
    private var maxYearCount = 0
    private var contentViewHeight: CGFloat = 0
    
    private lazy var components: DateComponents = {
        let comp = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: Date())
        return comp
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .container
        return view
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
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .normal
        titleLabel.textAlignment = .center
        titleLabel.textColor = .darkText
        return titleLabel
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
    
    init(days: Int = 3, value: String? = nil) {
        super.init(frame: ScreenBounds)
        initView(days: days)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView(days: Int, value: String? = nil) {
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
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(cancelButton.snp_right)
            make.right.equalTo(confirmButton.snp_left)
            make.height.equalTo(44)
        }
        
        contentView.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(44)
            make.left.right.bottom.equalToSuperview()
        }
        
        initData(days: days, value: value)
    }
    
    @objc private func initData(days: Int, value: String? = nil) {
        
        //数据源
        var arr: [String] = []
        let chinese = ["日", "一", "二", "三", "四", "五", "六", ""]
        let dayArr = ["今天", "明天", "后天"]
        for i in 0..<days {
            var month = components.month!
            var day = components.day! + i
            while day > dayCount(year: components.year!, month: month) {
                day -= dayCount(year: components.year!, month: month)
                month += 1
                if month > 12 {
                    month -= 12
                }
            }
            var week = "周\(chinese[(components.weekday! - 1 + i) % 7])"
            if i <= 2 {
                week = dayArr[i]
            }
            let date = i <= 2 ? "" : "\(month)月\(day)日 "
            arr.append(date + week)
        }
        dataArray.append(arr)
        arr = []
        for i in 0...23 {
            arr.append(String(format: "%02d点", i))
        }
        dataArray.append(arr)
        arr = []
        for i in 0...59 {
            if i % 5 == 0 {
                arr.append(String(format: "%02d分", i))
            }
        }
        dataArray.append(arr)
        //初始化选中的行
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.selectRow(components.hour!, inComponent: 1, animated: true)
        let minuteIndex = (components.minute! + 4) / 5
        pickerView.selectRow(minuteIndex, inComponent: 2, animated: true)
        
    }
    
    @objc private func cancelButtonAction() {
        hide()
    }
    
    @objc private func confirmButtonAction() {
        let day = pickerView.selectedRow(inComponent: 0)
        let hour = pickerView.selectedRow(inComponent: 1)
        let minute = pickerView.selectedRow(inComponent: 2)
        delegate?.configDatePickerViewDidSelect(date: dataArray[0][day] + " " + dataArray[1][hour] + " " + dataArray[2][minute])
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
    
    private func dayCount(year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
                return 29
            } else {
                return 28
            }
        default:
            return 0
        }
    }
    
}


extension ConfigDatePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return component == 0 ? ScreenWidth / 16 * 6 : ScreenWidth / 16 * 3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = .standard
        label.textAlignment = .center
        label.text = dataArray[component][row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //检查是否超过当前时间
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: Date())
        
        let day = pickerView.selectedRow(inComponent: 0)
        let hour = pickerView.selectedRow(inComponent: 1)
        let minute = pickerView.selectedRow(inComponent: 2)
        
        if day > 0 {
            return
        }
        if hour < components.hour! {
            pickerView.selectRow(components.hour!, inComponent: 1, animated: true)
            return
        }
        if hour == components.hour! && minute < components.minute! {
            pickerView.selectRow(components.minute!, inComponent: 2, animated: true)
            return
        }
    }
    
}

