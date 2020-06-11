//
//  PageViewControllerInfo.swift
//  Financer
//
//  Created by Valentin Witzeneder on 09.10.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit

class PageViewControllerInfo: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var pages = [UIViewController]()
    private let pageControl = UIPageControl()
    private let isInital: Bool!

    init(isInitial: Bool) {
        self.isInital = isInitial
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if !isInitial {
            let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(goBack(sender:)))
            self.navigationItem.leftBarButtonItem = doneItem;
            self.navigationItem.leftBarButtonItem?.tintColor = .white
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goBack(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        let initialPage = 0
        
        // <---------- PAGE VC'S---------->
        let page1 = InitialStart()
        let page2 = SettingsFirstStart()
        let page3 = GeneralInfo(isInitial: isInital)
        
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        // <---------- PAGE CONTROLL ---------->
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                if isInital {
                    return nil
                }
                return self.pages.last
            } else {
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                return self.pages[viewControllerIndex + 1]
            } else {
                if isInital {
                    return nil
                }
                return self.pages.first
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.index(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
}
