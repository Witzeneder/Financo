//
//  Situation+UI.swift
//  Financer
//
//  Created by Valentin Witzeneder on 26.02.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Charts

extension Situation: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                return nil
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
                return nil
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
    
    
    internal func setupUI() {
        // This ensures that view is below the navigation bar
        self.edgesForExtendedLayout = []
        var constraints: [NSLayoutConstraint] = []
        self.view.setGradientBackgroundMiddle(colorOne: UIColor(hex: "#DCDFE0"), colorTwo: UIColor(hex: "0D3530"))
        
        // <---------- CONTAINER (PAGE VIEW CONTROLL) ---------->
        container = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        container.view.translatesAutoresizingMaskIntoConstraints = false
        container.dataSource = self
        container.delegate = self
        pages.append(IncOutInfoVC(isIncome: true))
        pages.append(SituationInfoVC(currentMonth: currentMonth, currentYear: currentYear))
        pages.append(IncOutInfoVC(isIncome: false))
        
        container.setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)
        
        self.addChild(container)
        self.view.addSubview(container.view)
        
        if !isX {
            constraints.append(NSLayoutConstraint(item: container.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.frame.height / 30))
        } else {
            constraints.append(NSLayoutConstraint(item: container.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.frame.height / 20))
        }
        constraints.append(NSLayoutConstraint(item: container.view, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: container.view, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.15, constant: 0))
        container.didMove(toParent: self)
        
        // <---------- PAGE CONTROLL ---------->
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = 1
        self.pageControl.pageIndicatorTintColor = UIColor(hex: "#0D3530")
        self.pageControl.currentPageIndicatorTintColor = .white
        
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.bottomAnchor.constraint(equalTo: container.view.bottomAnchor, constant: -1).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: container.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: container.view.centerXAnchor).isActive = true
        
        
        // <---------- CENTER VIEW ---------->
        self.centerView.translatesAutoresizingMaskIntoConstraints = false
        self.centerView.backgroundColor = UIColor(hex: "#9EBFC0")
        centerView.layer.borderWidth = 2.5
        centerView.layer.borderColor = UIColor(hex: "#0D3530").cgColor
        centerView.layer.shadowColor = UIColor.black.cgColor
        centerView.layer.shadowOpacity = 1
        centerView.layer.shadowOffset = .zero
        centerView.layer.shadowRadius = 20
        
        self.view.addSubview(centerView)
        constraints.append(NSLayoutConstraint(item: centerView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: centerView, attribute: .top, relatedBy: .equal, toItem: container.view, attribute: .bottom, multiplier: 1, constant: self.view.frame.height / 80))
        constraints.append(NSLayoutConstraint(item: centerView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.95, constant: 0))
        constraints.append(NSLayoutConstraint(item: centerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -self.view.frame.height / 100))
        
        var centerConstraints:[NSLayoutConstraint] = []
        
        
        // <---------- CONSTRAINTS ---------->
        NSLayoutConstraint.activate(constraints)
        
        // <---------- CHART VIEW ---------->
        chartView = BarChartView()
        chartView.delegate = self
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.layer.cornerRadius = 20
        chartView.backgroundColor = .clear
        chartView.isUserInteractionEnabled = false
        self.centerView.addSubview(chartView)
        
        centerConstraints.append(NSLayoutConstraint(item: chartView, attribute: .centerX, relatedBy: .equal, toItem: centerView, attribute: .centerX, multiplier: 1, constant: 0))
        centerConstraints.append(NSLayoutConstraint(item: chartView, attribute: .top, relatedBy: .equal, toItem: centerView, attribute: .top, multiplier: 1, constant: self.view.frame.height/80))
        centerConstraints.append(NSLayoutConstraint(item: chartView, attribute: .height, relatedBy: .equal, toItem: centerView, attribute: .height, multiplier: 0.7, constant: 0))
        centerConstraints.append(NSLayoutConstraint(item: chartView, attribute: .width, relatedBy: .equal, toItem: centerView, attribute: .width, multiplier: 0.95, constant: 0))
        
        
    
        
        // <---------- PICKER VIEW ---------->
        monthYearPicker = UIPickerView()
        monthYearPicker.dataSource = self
        monthYearPicker.delegate = self
        monthYearPicker.clipsToBounds = true
        monthYearPicker.translatesAutoresizingMaskIntoConstraints = false
        monthYearPicker.backgroundColor = .clear
        monthYearPicker.layer.addBorder(edge: .top, color: UIColor(hex: "#0D3530"), thickness: 4, width: self.view.frame.width * 0.95)
        self.centerView.addSubview(monthYearPicker)
        
        centerConstraints.append(NSLayoutConstraint(item: monthYearPicker, attribute: .height, relatedBy: .equal, toItem: centerView, attribute: .height, multiplier: 0.25, constant: 0))
        centerConstraints.append(NSLayoutConstraint(item: monthYearPicker, attribute: .bottom, relatedBy: .equal, toItem: centerView, attribute: .bottom, multiplier: 1, constant: 0))
        centerConstraints.append(NSLayoutConstraint(item: monthYearPicker, attribute: .width, relatedBy: .equal, toItem: centerView, attribute: .width, multiplier: 1, constant: 0))
        centerConstraints.append(NSLayoutConstraint(item: monthYearPicker, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        
        
        monthYearPicker.selectRow(currentMonth-1, inComponent: 0, animated: false)
        monthYearPicker.selectRow(5, inComponent: 1, animated: false)
        
        
        NSLayoutConstraint.activate(centerConstraints)
    }
    
    
    
}
