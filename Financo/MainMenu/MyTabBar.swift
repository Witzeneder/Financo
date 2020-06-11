//
//  MyTabBar.swift
//  Financer
//
//  Created by Valentin Witzeneder on 12.10.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Foundation

class MyTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension MyTabBar: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.2, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
}
