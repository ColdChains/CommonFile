//
//  DatePickerView.swift
//  UnityCar
//
//  Created by lax on 2019/9/9.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import Foundation

extension DatePickerView {
    
    enum Style {
        case year
        case yearmonth
        case yearmonthday
    }
    
}

protocol DatePickerViewDelegate : NSObjectProtocol {
    func datePickerViewDidSelect(year: Int, month: Int, day: Int)
}

class DatePickerView: UIView {
    
    weak var delegate: DatePickerViewDelegate?
    
    var style: Style = .yearmonthday
    
    var dataArray: [[String]] = []
    
    private var maxYearCount = 0
    private var contentViewHeight: CGFloat = 0
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .container
        return view
    }()
    
    private lazy var components: DateComponents = {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year, .month, .day], from: Date())
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
    
    /// 时间选择器 年 月 日
    /// - Parameters:
    ///   - style: 选择器样式
    ///   - years: 显示的年数
    ///   - value: 默认日期（以-分割 如2020-02-02）
    init(style: Style = .yearmonthday, years: Int = 50, value: String? = nil) {
        super.init(frame: ScreenBounds)
        self.style = style
        initView(yearCount: years, value: value)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView(yearCount: Int, value: String? = nil) {
        let count = yearCount > 0 ? yearCount : 3
        maxYearCount = count
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
        let currentYear = maxYearCount - 1
        let currentMonth = components.month! - 1
        let currentDay = components.day! - 1
        
        var arr: [String] = []
        for i in 0...currentYear {
            let year = components.year! - maxYearCount + i + 1
            arr.append("\(year)年")
        }
        dataArray.append(arr)
        if style != .year {
            var arr: [String] = []
            for i in 0...currentMonth {
                arr.append("\(i + 1)月")
            }
            dataArray.append(arr)
        }
        if style == .yearmonthday {
            var arr: [String] = []
            for i in 0...currentDay {
                arr.append("\(i + 1)日")
            }
            dataArray.append(arr)
        }
        
        //设置默认值
        var yearValue = 0
        var monthValue = 0
        var dayValue = 0
        if var str = value {
            str = str.replacingOccurrences(of: "年", with: "-")
            str = str.replacingOccurrences(of: "月", with: "-")
            str = str.replacingOccurrences(of: "日", with: "")
            let arr = str.components(separatedBy: "-")
            if arr.count > 0 {
                yearValue = Int(arr[0]) ?? 0
            }
            if arr.count > 1 {
                monthValue = Int(arr[1]) ?? 0
            }
            if arr.count > 2 {
                dayValue = Int(arr[2]) ?? 0
            }
        }
        
        var yearIndex = currentYear
        var monthIndex = currentMonth
        var dayIndex = currentDay
        
        for i in 0..<dataArray[0].count {
            if yearValue == components.year! - maxYearCount + i + 1 {
                yearIndex = i
            }
        }
        for i in 0..<dataArray[1].count {
            if monthValue == i + 1 {
                monthIndex = i
            }
        }
        for i in 0..<dataArray[1].count {
            if dayValue == i + 1 {
                dayIndex = i
            }
        }
        
        //初始化选中的行
        pickerView.selectRow(yearIndex, inComponent: 0, animated: true)
        if style == .yearmonth || style == .yearmonthday {
            pickerView.selectRow(monthIndex, inComponent: 1, animated: true)
        }
        if style == .yearmonthday {
            pickerView.selectRow(dayIndex, inComponent: 2, animated: true)
        }
    }
    
    @objc private func cancelButtonAction() {
        hide()
    }
    
    @objc private func confirmButtonAction() {
        let currentYear = components.year! - maxYearCount + pickerView.selectedRow(inComponent: 0) + 1
        var currentMonth = 0
        var currentDay = 0
        if style == .yearmonth || style == .yearmonthday {
            currentMonth = pickerView.selectedRow(inComponent: 1) + 1
        }
        if style == .yearmonthday {
            currentDay = pickerView.selectedRow(inComponent: 2) + 1
        }
        delegate?.datePickerViewDidSelect(year: currentYear, month: currentMonth, day: currentDay)
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


extension DatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //选中年月刷新对应的月日
        if component == 0 && style == .yearmonth {
            datePickReloadMonth()
        }
        if component == 0 && style == .yearmonthday {
            datePickReloadMonth()
            datePickReloadDay()
        }
        if component == 1 && style == .yearmonthday {
            datePickReloadDay()
        }
    }
    
    private func datePickReloadMonth() {
        let yearIndex = pickerView.selectedRow(inComponent: 0)
        var month = 12
        if yearIndex == maxYearCount - 1 {
            month = components.month!
        }
        var arr: [String] = []
        for i in 0..<month {
            arr.append("\(i + 1)月")
        }
        dataArray[1] = arr
        pickerView.reloadComponent(1)
    }
    
    private func datePickReloadDay() {
        let yearIndex = pickerView.selectedRow(inComponent: 0)
        let monthIndex = pickerView.selectedRow(inComponent: 1)
        
        var day = dayCount(year: dataArray[0][yearIndex].intValue, month: dataArray[1][monthIndex].intValue)
        if yearIndex == maxYearCount - 1 && monthIndex == components.month! - 1 {
            day = components.day!
        }
        var arr: [String] = []
        for i in 0..<day {
            arr.append("\(i + 1)日")
        }
        dataArray[2] = arr
        pickerView.reloadComponent(2)
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
