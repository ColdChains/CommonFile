//
//  BaseTabBarController.swift
//  FreightDriver
//
//  Created by lax on 2019/12/12.
//  Copyright © 2019 ColdChains. All rights reserved.
//

import UIKit

struct TabBarItemModel {
    
    var viewController: UIViewController
    
    var image: UIImage?
    
    var selectedImage: UIImage?
    
    var title: String?
    
}

class BaseTabBarController: UITabBarController {
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        if #available(iOS 11.0, *) {
            return viewControllers?[selectedIndex].prefersHomeIndicatorAutoHidden ?? true
        } else {
            return true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return viewControllers?[selectedIndex]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return viewControllers?[selectedIndex].shouldAutorotate ?? true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return viewControllers?[selectedIndex].supportedInterfaceOrientations ?? .portrait
    }
    
    init(_ items: [TabBarItemModel] = []) {
        super.init(nibName: nil, bundle: nil)
        
        var vcs: [UIViewController] = []
        for item in items {
            let vc = item.viewController
            vc.tabBarItem.image = item.image?.withRenderingMode(.automatic)
            if item.selectedImage == nil {
                vc.tabBarItem.selectedImage = item.image?.withRenderingMode(.automatic)
            } else {
                vc.tabBarItem.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
            }
            vc.tabBarItem.title = item.title
            vcs.append(vc)
        }
        viewControllers = vcs
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .systemBackground
        tabBar.tintColor = .global
        modalPresentationStyle = viewControllers?[selectedIndex].modalPresentationStyle ?? .fullScreen
    }

}
