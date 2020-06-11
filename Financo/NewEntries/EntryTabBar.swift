//
//  NewEntry.swift
//  Financer
//
//  Created by Valentin Witzeneder on 24.08.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit

class EntryTabBar: UITabBarController {
    
    private var isIncome: Bool!
    private var navTitle = NSLocalizedString("incomes.name", comment: "")
    
    init(isIncome: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isIncome = isIncome
        if !isIncome {
            navTitle =  NSLocalizedString("outcomes.name", comment: "")
        }
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        var vcID = 1
        if !isIncome {
            vcID = 4
        }
        self.tabBar.backgroundImage = UIColor(hex: "#DCDFE0").image()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: "#216260")]
        
        let oneTimeEntriesVC = UINavigationController(rootViewController: NewEntryBaseClass(tabID: vcID, title: navTitle))
        oneTimeEntriesVC.title = NSLocalizedString("newEntry.oneTime", comment: "")
        var customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "oneUnselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "oneSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        oneTimeEntriesVC.tabBarItem = customTabBarItem
        oneTimeEntriesVC.tabBarItem.title = NSLocalizedString("newEntry.oneTime", comment: "")
        oneTimeEntriesVC.navigationBar.setBackgroundImage(UIColor(hex: "#DCDFE0").image(), for: .any, barMetrics: .default)
        oneTimeEntriesVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        oneTimeEntriesVC.tabBarItem.setTitleTextAttributes(attributes, for: .selected)
        
        let monthlyEntriesVC = UINavigationController(rootViewController: NewEntryBaseClass(tabID: vcID+1, title: navTitle))
        monthlyEntriesVC.title = NSLocalizedString("newEntry.monthly", comment: "")
        customTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "monthlyUnselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "monthlySelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        monthlyEntriesVC.tabBarItem = customTabBarItem
        monthlyEntriesVC.tabBarItem.title = NSLocalizedString("newEntry.monthly", comment: "")
        monthlyEntriesVC.navigationBar.setBackgroundImage(UIColor(hex: "#DCDFE0").image(), for: .any, barMetrics: .default)
        monthlyEntriesVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        monthlyEntriesVC.tabBarItem.setTitleTextAttributes(attributes, for: .selected)
       
        let customEntriesVC = UINavigationController(rootViewController: NewEntryBaseClass(tabID: vcID+2, title: navTitle))
        customEntriesVC.title = NSLocalizedString("newEntry.custom", comment: "")
        customTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "recurrentUnselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "recurrentSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        customEntriesVC.tabBarItem = customTabBarItem
        customEntriesVC.tabBarItem.title = NSLocalizedString("newEntry.custom", comment: "")
        customEntriesVC.navigationBar.setBackgroundImage(UIColor(hex: "#DCDFE0").image(), for: .any, barMetrics: .default)
        customEntriesVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        customEntriesVC.tabBarItem.setTitleTextAttributes(attributes, for: .selected)
        
        self.viewControllers = [oneTimeEntriesVC, monthlyEntriesVC, customEntriesVC]
        self.tabBar.unselectedItemTintColor = .black
    }
    
}
