//
//  DefaultSearchBar.swift
//  FreightUser
//
//  Created by lax on 2019/12/10.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class DefaultSearchBar: UISearchBar {

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
    
    private func initView() {
        layer.masksToBounds = true
        layer.cornerRadius = height / 2
        //边框宽度
        layer.borderWidth = 0
        //搜索框样式
        searchBarStyle = .minimal
        //是否显示Bookmark按钮
        showsBookmarkButton = false
        //是否显示Cancel按钮
        showsCancelButton = false
        //获取搜索框的输入框
        let searchField = value(forKey: "searchField") as! UITextField
        //改变搜索框的输入框的输入框的字体颜色
        searchField.textColor = .darkText
        searchField.font = .normal
        //改变搜索框的输入框的提示文字颜色，也就是搜索框提示文字的颜色
        searchField.setValue(UIColor.lightGray, forKeyPath: "_placeholderLabel.textColor")
        searchField.setValue(UIFont.normal, forKeyPath: "_placeholderLabel.font")
        //更换“放大镜”图片方法一
//        setImage(UIImage(named: "Search"),for: .search, state: .normal)
        //方法一的图片大小有点怪，暂时没找到方法修改
        //更换放大镜图片方法二，修改value(forKey: "searchField")的左视图
        let btnsearchLeft:UIButton = UIButton(type: .custom)
        btnsearchLeft.frame = CGRect(x:0,y:0,width:20,height:20)
        btnsearchLeft.setImage(R.image.icon_search(), for: .normal)
        searchField.leftView = btnsearchLeft
        searchField.leftViewMode = .unlessEditing
    }

}
