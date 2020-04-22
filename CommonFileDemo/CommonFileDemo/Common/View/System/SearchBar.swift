//
//  SearchBar.swift
//  UnityCar
//
//  Created by lax on 2019/10/24.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: NSObjectProtocol {
    func searchBarDidSearch(text: String?)
    func searchBarDidCancel()
}

class SearchBar: UIView {

    weak var delegate: SearchBarDelegate?
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .background
        textField.delegate = self
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .normal
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        backgroundColor = .container
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(80)
        }
        
        addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalTo(cancelButton.snp_left)
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func cancelButtonAction() {
        delegate?.searchBarDidCancel()
    }

}

extension SearchBar: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}
