//
//  CityPickerView.swift
//  UnityCarDriver
//
//  Created by 田峰 on 2020/3/25.
//  Copyright © 2020 ColdChains. All rights reserved.

import Foundation

extension CityPickerView {
    
    enum Style {
        case province
        case provincecity
        case provincecityarea
    }
    
}

protocol CityPickerViewDelegate: NSObjectProtocol {
    func cityPickerViewDidSelect(province: String, city: String, area: String)
}

class CityPickerView: UIView {
    
    weak var delegate: CityPickerViewDelegate?
    
    var style: Style = .provincecityarea
    
    private var provinceModelArray: [OpenProvinceModel] = []
    
    private var dataArray: [[String]] = []
    
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
        cancelButton.setTitleColor(.lightGray, for: .normal)
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
    init(style: Style = .provincecityarea, value: String? = nil) {
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
        guard let path = Bundle.main.path(forResource: "province.json", ofType: nil),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let dataJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]],
            let array = [OpenProvinceModel].deserialize(from: dataJSON) as? [OpenProvinceModel] else {
            return
        }
        provinceModelArray = array
        
        //设置默认值
        var province = ""
        var city = ""
        var area = ""
        if let str = value {
            let arr = str.components(separatedBy: "-")
            if arr.count > 0 {
                province = arr[0]
            }
            if arr.count > 1 {
                city = arr[1]
            }
            if arr.count > 2 {
                area = arr[2]
            }
        }
        
        var provinceIndex = 0
        var cityIndex = 0
        var areaIndex = 0
        
        var arr: [String] = []
        for i in 0..<provinceModelArray.count {
            if let name = provinceModelArray[i].name {
                arr.append(name)
                if name == province {
                    provinceIndex = i
                }
            }
        }
        dataArray.append(arr)
        
        guard provinceModelArray.count > 0,
            let cityArray = provinceModelArray[provinceIndex].city else { return }
        arr = []
        for i in 0..<cityArray.count {
            if let name = cityArray[i].name {
                arr.append(name)
                if name == city {
                    cityIndex = i
                }
            }
        }
        dataArray.append(arr)
        
        guard cityArray.count > 0, let areaArray = cityArray[cityIndex].area else { return }
        arr = []
        for i in 0..<areaArray.count {
            arr.append(areaArray[i])
            if areaArray[i] == area {
                areaIndex = i
            }
        }
        dataArray.append(arr)
        
        //初始化选中的行
        pickerView.selectRow(provinceIndex, inComponent: 0, animated: true)
        if style == .provincecity || style == .provincecityarea {
            pickerView.selectRow(cityIndex, inComponent: 1, animated: true)
        }
        if style == .provincecityarea {
            pickerView.selectRow(areaIndex, inComponent: 2, animated: true)
        }
    }
    
    @objc private func cancelButtonAction() {
        hide()
    }
    
    @objc private func confirmButtonAction() {
        let province = dataArray[0][pickerView.selectedRow(inComponent: 0)]
        var city = ""
        var area = ""
        if style == .provincecity || style == .provincecityarea {
            city = dataArray[1][pickerView.selectedRow(inComponent: 1)]
        }
        if style == .provincecityarea {
            area = dataArray[2][pickerView.selectedRow(inComponent: 2)]
        }
        delegate?.cityPickerViewDidSelect(province: province, city: city, area: area)
        hide()
    }
    
    @objc private func tapAction() {
        hide()
    }
    
    func show(in view: UIView?) {
        if provinceModelArray.count == 0 { return }
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

extension CityPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        label.text = ""
        label.text = dataArray[component][row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //选中年月刷新对应的月日
        if component == 0 {
            datePickReloadMonth()
            datePickReloadDay()
        }
        if component == 1 {
            datePickReloadDay()
        }
    }
    
    private func datePickReloadMonth() {
        let provinceIndex = pickerView.selectedRow(inComponent: 0)
        guard provinceModelArray.count > 0, let cityArray = provinceModelArray[provinceIndex].city else { return }
        var arr: [String] = []
        for i in 0..<cityArray.count {
            if let name = cityArray[i].name {
                arr.append(name)
            }
        }
        dataArray[1] = arr
        pickerView.reloadComponent(1)
    }
    
    private func datePickReloadDay() {
        let provinceIndex = pickerView.selectedRow(inComponent: 0)
        let cityIndex = pickerView.selectedRow(inComponent: 1)
        guard provinceModelArray.count > 0, let cityArray = provinceModelArray[provinceIndex].city else { return }
        guard cityArray.count > 0, let areaArray = cityArray[cityIndex].area else { return }
           var arr: [String] = []
           for i in 0..<areaArray.count {
               arr.append(areaArray[i])
           }
           dataArray[2] = arr
        pickerView.reloadComponent(2)
    }
    
}
