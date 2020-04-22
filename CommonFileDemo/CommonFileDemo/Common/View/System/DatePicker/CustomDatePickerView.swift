//
//  CustomDatePickerView.swift
//  FreightDriver
//
//  Created by lax on 2019/12/31.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import Foundation

protocol CustomDatePickerViewDelegate : NSObjectProtocol {
    func customDatePickerViewDidSelect(style: String, index:Int, value: String)
}

class CustomDatePickerView: UIView {
    
    weak var delegate: CustomDatePickerViewDelegate?
    
    var dataArray: [[String]] = []
    
    var style: String = ""
    
    private var maxYearCount = 0
    private var contentViewHeight: CGFloat = 0
    
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
    
    init(title: String? = nil, items: [String], selectIndex: Int? = nil, value: String? = nil) {
        super.init(frame: ScreenBounds)
        initView()
        initData(title: title, items: items, selectIndex: selectIndex, value: value)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        
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
    }
    
    private func initData(title: String? = nil, items: [String], selectIndex: Int?, value: String?) {
        dataArray.append(items)
        titleLabel.text = title
        
        if let index = selectIndex, index < items.count  {
            pickerView.selectRow(index, inComponent: 0, animated: true)
            return
        }
        if let str = value {
            var index = 0
            for i in 0..<items.count {
                if items[i] == str {
                    index = i
                    break
                }
            }
            pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    @objc private func cancelButtonAction() {
        hide()
    }
    
    @objc private func confirmButtonAction() {
        let day = pickerView.selectedRow(inComponent: 0)
        delegate?.customDatePickerViewDidSelect(style: style, index: day, value: dataArray[0][day])
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


extension CustomDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        label.font = .standardMedium
        label.textAlignment = .center
        label.text = dataArray[component][row]
        return label
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: Date())
//
//        let day = pickerView.selectedRow(inComponent: 0)
//        let hour = pickerView.selectedRow(inComponent: 1)
//        let minute = pickerView.selectedRow(inComponent: 2)
//
//        if day > 0 {
//            return
//        }
//        if hour < components.hour! {
//            pickerView.selectRow(components.hour!, inComponent: 1, animated: true)
//            return
//        }
//        if hour == components.hour! && minute < components.minute! {
//            pickerView.selectRow(components.minute!, inComponent: 2, animated: true)
//            return
//        }
//    }
    
}
