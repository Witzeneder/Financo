//
//  MainMenuTabBar.swift
//  Financer
//
//  Created by Valentin Witzeneder on 10.10.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit

class MainMenuTabBar: MyTabBar {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupVCs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.unselectedItemTintColor = .black
    }
    
    private func setupVCs() {
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: "#216260")]
    
        let incomesVC = UINavigationController(rootViewController: TableViewBaseClass(title: NSLocalizedString(NSLocalizedString("incomes.name", comment: ""), comment: ""), isIncome: true))
        incomesVC.navigationBar.setBackgroundImage(UIColor(hex: "#DCDFE0").image(), for: .any, barMetrics: .default)
        var customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "entryUnselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "entrySelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        incomesVC.tabBarItem = customTabBarItem
        incomesVC.tabBarItem.title = NSLocalizedString("viewTitle.Manage", comment: "")
        incomesVC.tabBarItem.setTitleTextAttributes(attributes, for: .selected)
        
        let recurrentVC = RecurrentEntries(isIncome: true)
        customTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "recurrentUnselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "recurrentSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        recurrentVC.tabBarItem = customTabBarItem
        recurrentVC.tabBarItem.title = NSLocalizedString("viewTitle.Recurrent", comment: "")
        recurrentVC.tabBarItem.setTitleTextAttributes(attributes, for: .selected)
        
        let chartsVC = ChartVC(id: 2)
        customTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "chartUnselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "chartSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        chartsVC.tabBarItem = customTabBarItem
        chartsVC.tabBarItem.title = NSLocalizedString("viewTitle.Charts", comment: "")
        chartsVC.tabBarItem.setTitleTextAttributes(attributes, for: .selected)
        
        let singleMonthVC = Situation()
        customTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "personUnselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "personSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        singleMonthVC.tabBarItem = customTabBarItem
        singleMonthVC.tabBarItem.title = NSLocalizedString("viewTitle.Situation", comment: "")
        singleMonthVC.tabBarItem.setTitleTextAttributes(attributes, for: .selected)
        
        let goalsVC = GoalsView(isIncome: true)
        customTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "goalsUnselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "goalsSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        goalsVC.tabBarItem = customTabBarItem
        goalsVC.tabBarItem.title = NSLocalizedString("viewTitle.Goals", comment: "")
        goalsVC.tabBarItem.setTitleTextAttributes(attributes, for: .selected)
        
        let myVCs = [incomesVC,recurrentVC, singleMonthVC, chartsVC, goalsVC]
        
        self.viewControllers = myVCs
        self.selectedIndex = 2
        self.tabBar.backgroundImage = UIColor(hex: "#DCDFE0").image()
    }
}
