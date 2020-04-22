//
//  PlanDatePickerView.swift
//  UnityCar
//
//  Created by lax on 2019/9/10.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import Foundation

protocol PlanDatePickerViewDelegate : NSObjectProtocol{
    func planDatePickerViewDidSelect(date: String, format: String)
}

class PlanDatePickerView: UIView {
    
    weak var delegate: PlanDatePickerViewDelegate?
    
    var dataArray: [[String]] = []
    
    private var maxYearCount = 0
    private var contentViewHeight: CGFloat = 0
    
    private var start: Int
    private var end: Int
    // 0点到now+end的分钟数
    private var allMinute: Int
    // private var now = "2020-02-12 21:29:00".toDate()!//30 90 30 160
    private var now = Date()
    // now+start的时间
    private lazy var components: DateComponents = {
        var minute = Int(now.timeIntervalSince(now.todayZeroDate) / 60) + start
        if minute % 60 > 55 {
            minute += 60 - minute % 60
        }
        let date = Date(timeInterval: TimeInterval(minute * 60), since: now.todayZeroDate)
        let comp = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
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
        titleLabel.text = "请选择用车时间"
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
    
    /// 选择日期
    /// - Parameters:
    ///   - start: 当前时间start分钟后开始
    ///   - end: 当前时间end分钟后为止
    ///   - value: 默认值
    init(start: Int = 0, end: Int = 3 * 24 * 60, value: String? = nil) {
        self.start = start
        self.end = end
        allMinute = Int(now.timeIntervalSince(now.todayZeroDate) / 60) + end
        if allMinute % 60 > 55 {
            allMinute += 60 - allMinute % 60
        }
        super.init(frame: ScreenBounds)
        initView()
        initData(start: start, end: end, value: value)
    }
    
    required init?(coder: NSCoder) {
        start = 0
        end = 0
        allMinute = 0
        super.init(coder: coder)
    }
    
    private func initView() {
        contentViewHeight = 240 * ScaleWidth + 120;
        
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
    
    @objc private func initData(start: Int, end: Int, value: String?) {
        let startHour = components.hour!
        let startMinute = components.minute!
        let days = allMinute / 60 / 24 + 1
        var endHour = 23
        var endMinute = 59
        if days == 1 {
            endHour = allMinute % (60 * 24) / 60
        }
        if days == 1 && endHour - startHour == 1 {
            endMinute = allMinute % 60
            if endMinute < startMinute {
                endMinute = 59
            }
        }
        //数据源
        var arr: [String] = []
        //let chinese = ["日", "一", "二", "三", "四", "五", "六", ""]
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
            var date = "\(month)月\(day)日 "
            //var week = "周\(chinese[(components.weekday! - 1 + i) % 7])"
            if i <= 2 {
                date = dayArr[i]
                //week = ""
            }
            arr.append(date)
            //arr.append(date + week)
        }
        dataArray.append(arr)
        arr = []
        for i in startHour...endHour {
            let str = String(format: "%02d点", i)
            arr.append(str)
        }
        dataArray.append(arr)
        arr = []
        for i in startMinute...endMinute {
            if i % 5 == 0 {
                let str = String(format: "%02d分", i)
                arr.append(str)
            }
        }
        dataArray.append(arr)
        
        //设置默认值
        var dayValue = ""
        var hourValue = ""
        var minuteValue = ""
        if var str = value {
            str = str.replacingOccurrences(of: " ", with: ":")
            let arr = str.components(separatedBy: ":")
            if arr.count > 0 {
                dayValue = arr[0]
            }
            if arr.count > 1 {
                hourValue = arr[1]
            }
            if arr.count > 2 {
                minuteValue = arr[2]
            }
        }
        
        var dayIndex = 0
        var hourIndex = 0
        var minuteIndex = 0
        
        for i in 0..<dataArray[0].count {
            if dayValue == dataArray[0][i] {
                dayIndex = i
            }
        }
        for i in 0..<dataArray[1].count {
            if hourValue == dataArray[1][i] {
                hourIndex = i
            }
        }
        for i in 0..<dataArray[2].count {
            if minuteValue == dataArray[2][i] {
                minuteIndex = i
            }
        }
        
        //初始化选中的行
        pickerView.selectRow(dayIndex, inComponent: 0, animated: true)
        pickerView.selectRow(hourIndex, inComponent: 1, animated: true)
        pickerView.selectRow(minuteIndex, inComponent: 2, animated: true)
        pickerView(pickerView, didSelectRow: dayIndex, inComponent: 0)
        pickerView(pickerView, didSelectRow: hourIndex, inComponent: 1)
    }
    
    @objc private func cancelButtonAction() {
        hide()
    }
    
    @objc private func confirmButtonAction() {
        let dayIndex = pickerView.selectedRow(inComponent: 0)
        let hourIndex = pickerView.selectedRow(inComponent: 1)
        let minuteIndex = pickerView.selectedRow(inComponent: 2)
        let date = dataArray[0][dayIndex] + " " + dataArray[1][hourIndex] + " " + dataArray[2][minuteIndex]
        let offset = dayIndex * 24 * 60 * 60 + dataArray[1][hourIndex].intValue * 60 * 60 + dataArray[2][minuteIndex].intValue * 60
        let format = Date(timeInterval: TimeInterval(offset), since: now.todayZeroDate).toString()
        delegate?.planDatePickerViewDidSelect(date: date, format: format)
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


extension PlanDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        //return component == 0 ? ScreenWidth / 16 * 6 : ScreenWidth / 16 * 3
        return component == 0 ? ScreenWidth / 16 * 5 : ScreenWidth / 16 * 4
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
        if component == 0 {
            datePickReloadHour()
            datePickReloadMinute()
        }
        if component == 1 {
            datePickReloadMinute()
        }
    }
    
    private func datePickReloadHour() {
        let dayIndex = pickerView.selectedRow(inComponent: 0)
        var startHour = 0
        if dayIndex == 0 {
            startHour = components.hour!
        }
        var endHour = 23
        if dayIndex == dataArray[0].count - 1 {
            endHour = allMinute % (60 * 24) / 60
        }
        var arr: [String] = []
        for i in startHour...endHour {
            arr.append(String(format: "%02d点", i))
        }
        dataArray[1] = arr
        pickerView.reloadComponent(1)
    }
    
    private func datePickReloadMinute() {
        let dayIndex = pickerView.selectedRow(inComponent: 0)
        let hourIndex = pickerView.selectedRow(inComponent: 1)
        var startMinute = 0
        if dayIndex == 0 && hourIndex == 0 {
            startMinute = components.minute!
        }
        var endMinute = 59
        if dayIndex == dataArray[0].count - 1 && hourIndex == dataArray[1].count - 1 {
            endMinute = allMinute % 60
            if endMinute < startMinute {
                endMinute = 59
            }
        }
        var arr: [String] = []
        for i in startMinute...endMinute {
            if i % 5 == 0 {
                arr.append(String(format: "%02d分", i))
            }
        }
        dataArray[2] = arr
        pickerView.reloadComponent(2)
    }
    
}
