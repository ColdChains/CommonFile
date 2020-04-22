//
//  BaseNavigationController.swift
//  FreightUser
//
//  Created by lax on 2019/7/12.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override var prefersHomeIndicatorAutoHidden: Bool {
        if #available(iOS 11.0, *) {
            return topViewController?.prefersHomeIndicatorAutoHidden ?? true
        } else {
            return true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        modalPresentationStyle = topViewController?.modalPresentationStyle ?? .fullScreen
    }

}

extension UITabBarController {
    
    func setBadge(index: Int = 1, _ badge: Int) {
        if tabBar.items?.count ?? 0 < index { return }
        if badge <= 0 {
            tabBar.items?[index].badgeValue = nil
            return
        }
        tabBar.items?[index].badgeValue = "\(badge)"
        if #available(iOS 10.0, *) {
            tabBar.items?[index].badgeColor = .global
        }
    }
    
}
