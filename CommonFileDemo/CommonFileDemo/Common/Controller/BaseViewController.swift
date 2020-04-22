//
//  BaseViewController.swift
//  FreightUser
//
//  Created by lax on 2019/7/12.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

extension UIViewController {
    
    enum JumpStyle {
        case none
        case present
        case push
    }
    
}

class BaseViewController: UIViewController {
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var jumpStyle: JumpStyle = .none
    
    lazy var navigationBar: NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.delegate = self
        navigationBar.style = .lightContent
        return navigationBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        automaticallyAdjustsScrollViewInsets = false
        modalPresentationStyle = .fullScreen
    }

    func addNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(NavigationBarHeight)
        }
    }

    func backAction() {
        if jumpStyle == .present {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        print("\(className) \(#function)")
    }
    
}

extension BaseViewController: NavigationBarDelegate {
    
    @objc func navigationBarDidSelectLeftItem() {
        backAction()
    }
    
    @objc func navigationBarDidSelectCloseItem() {
        backAction()
    }
    
    @objc func navigationBarDidSelectRightItem() {
        print("right button")
    }
    
}
