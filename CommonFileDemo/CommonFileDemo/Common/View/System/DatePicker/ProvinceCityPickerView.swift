//
//  ProvinceCityPickerView.swift
//  UnityCarDriver
//
//  Created by 田峰 on 2020/3/25.
//  Copyright © 2020 ColdChains. All rights reserved.

import Foundation

typealias ProviceCityAreaBlock = (String,String,String)->()

class ProvinceCityPickerView: UIView {
    
    var dataArray = [OpenProvinceModel]()
    var proviceIndex = 0
    var cityIndex = 0
    var areaIndex = 0
    private var contentViewHeight: CGFloat = 0
    var pcaBlock : ProviceCityAreaBlock?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .container
        return view
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "请选择开户所在城市"
        label.textColor = .darkText
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
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
    
    init(value: String? = nil) {
        super.init(frame: ScreenBounds)
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
        
        initData(value: value)
    }
    
    private func initData(value: String? = nil) {
        if let path = Bundle.main.path(forResource: "province.json", ofType: nil) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                if let dataJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]] {
                    if let array = [OpenProvinceModel].deserialize(from: dataJSON) as? [OpenProvinceModel] {
                        //获取到了全国城市数据
                        dataArray = array
                        showCustomProviceCityArea(value: value)
                    }
                }
            }
        }
    }
    
    func showCustomProviceCityArea(value:String?) {
        guard let array = value?.components(separatedBy: "-") else {
            return
        }
        //获取省的索引
        guard let pindex = dataArray.firstIndex(where: {$0.name == array[0]}) else { return }
        //获取城市的索引
        guard let cmodels = dataArray[pindex].city else {
            return
        }
        guard let cindex = cmodels.firstIndex (where: {$0.name == array[1]}) else { return }
        guard let aindex = cmodels[cindex].area?.firstIndex(of: array[2]) else { return }
        proviceIndex = pindex
        cityIndex = cindex
        areaIndex = aindex
        pickerView.selectRow(proviceIndex, inComponent: 0, animated: false)
        pickerView.selectRow(cityIndex, inComponent: 1, animated: false)
        pickerView.selectRow(areaIndex, inComponent: 2, animated: false)
    }
    
    @objc private func cancelButtonAction() {
        //取消按钮
        hide()
    }
    
    @objc private func confirmButtonAction() {
        let proviceModel = dataArray[proviceIndex]
        guard let provice = proviceModel.name else { return }
        guard let city = proviceModel.city?[cityIndex].name else { return }
        guard let area = proviceModel.city?[cityIndex].area?[areaIndex] else { return }
        pcaBlock?(provice,city,area)
        //确认选择按钮
        hide()
    }
    
    @objc private func tapAction() {
        hide()
    }
    
    func show(in view: UIView?) {
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

extension ProvinceCityPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let provinceModel = dataArray[proviceIndex]
        if component == 0 {
            return dataArray.count
        } else if component == 1 {
            if let cities = provinceModel.city {
                return cities.count
            }
        } else {
            if let city = provinceModel.city?[cityIndex] {
                if let area = city.area {
                    return area.count
                }
            }
        }
        return 0
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
        if component == 0 {
            let provinceModel = dataArray[row]
            label.text = provinceModel.name
        } else if component == 1 {
            let provinceModel = dataArray[proviceIndex]
            if let city = provinceModel.city {
                label.text = city[row].name
            }
        } else {
            let provinceModel = dataArray[proviceIndex]
            if let city = provinceModel.city {
                if let areas = city[cityIndex].area {
                    label.text = areas[row]
                }
            }
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //选中年月刷新对应的月日
        if component == 0 {
            proviceIndex = row
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        } else if component == 1 {
            cityIndex = row
            pickerView.reloadComponent(2)
        } else {
            areaIndex = row
        }
    }
}
