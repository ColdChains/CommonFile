//
//  StepperView.swift
//  FreightUser
//
//  Created by lax on 2019/8/28.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class StepperView: UIView {
    
    var minValue: Double = 0
    
    var maxValue: Double = 100
    
    var step: Double = 1
    
    var unit: String = ""
    
    var value: Double {
        get {
            return textField.text?.doubleValue ?? 0
        }
        set {
            textField.text = "\(newValue)".doubleString + unit
            leftButton.isEnabled = value > minValue
            rightButton.isEnabled = value < maxValue
        }
    }
    
    var canInput = false {
        didSet {
            textField.isEnabled = canInput
        }
    }
    
    private lazy var leftButton: BackgroundGlobalButton = {
        let button = BackgroundGlobalButton()
        button.titleLabel?.font = UIFont.defaultFont(size: 35)
        button.setImage(R.image.icon_sub(), for: .normal)
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "0" + unit
        textField.isEnabled = false
        textField.font = .normal
        textField.textAlignment = .center
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var rightButton: BackgroundGlobalButton = {
        let button = BackgroundGlobalButton()
        button.titleLabel?.font = UIFont.defaultFont(size: 25)
        button.setImage(R.image.icon_add(), for: .normal)
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect = CGRect()) {
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
    
    var itemWidth: CGFloat = 30 {
        didSet {
            leftButton.frame = CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth)
            textField.frame = CGRect(x: leftButton.width, y: 0, width: itemWidth, height: itemWidth)
            rightButton.frame = CGRect(x: leftButton.width + textField.width, y: 0, width: itemWidth, height: itemWidth)
        }
    }
    
    private func initView() {
        itemWidth = 30
        addSubview(leftButton)
        addSubview(textField)
        addSubview(rightButton)
        value = 0
    }
    
    @objc private func leftButtonAction() {
        guard let text = textField.text else { return }
        let value = text.doubleValue - step < minValue ? minValue : text.doubleValue - step
        textField.text = "\(value)".doubleString + unit
        leftButton.isEnabled = value > minValue
        rightButton.isEnabled = value < maxValue
        print(value, value > minValue, value < maxValue)
        FeedbackGeneratorManager.occurred()
    }
    
    @objc private func rightButtonAction() {
        guard let text = textField.text else { return }
        let value = text.doubleValue + step > maxValue ? maxValue : text.doubleValue + step
        textField.text = "\(value)".doubleString + unit
        leftButton.isEnabled = value > minValue
        rightButton.isEnabled = value < maxValue
        print(value, value > minValue, value < maxValue)
        FeedbackGeneratorManager.occurred()
    }

}


extension StepperView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" { return true }
        var str = string
        if let text = textField.text {
            str = text + string
        }
        if !str.isFormatDoubleNumber {
            return false
        }
        if str.doubleValue < minValue || str.doubleValue > maxValue {
            return false
        }
        return true
    }
    
}
