//
//  ChartVC+UI.swift
//  Financer
//
//  Created by Valentin Witzeneder on 24.02.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//


import UIKit
import Charts

extension ChartVC {
    
    internal func setupUI() {
        // This ensures that view is below the navigation bar
        self.edgesForExtendedLayout = []
        var constraints: [NSLayoutConstraint] = []
        
        self.view.setGradientBackgroundMiddle(colorOne: UIColor(hex: "#DCDFE0"), colorTwo: UIColor(hex: "0D3530"))
        
        // <---------- TOP CONTAINER ---------->
        let topContainer = UIView()
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topContainer)
        if !isX {
            constraints.append(NSLayoutConstraint(item: topContainer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.frame.height / 30))
        } else {
            constraints.append(NSLayoutConstraint(item: topContainer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.frame.height / 20))
        }
        constraints.append(NSLayoutConstraint(item: topContainer, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: topContainer, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.15, constant: 0))
        
        var topConstraints: [NSLayoutConstraint] = []
        
        // <---------- SEGMENTED CONTROLL ---------->
        segmentedControl = CustomSegmentedControl(container: self.container)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: NSLocalizedString("chartPicker.absolute", comment: ""), at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: NSLocalizedString("chartPicker.percentage", comment: ""), at: 1, animated: false)
        topContainer.addSubview(segmentedControl)
        
        topConstraints.append(NSLayoutConstraint(item: segmentedControl, attribute: .centerY, relatedBy: .equal, toItem: topContainer, attribute: .centerY, multiplier: 1, constant: 0))
        topConstraints.append(NSLayoutConstraint(item: segmentedControl, attribute: .centerX, relatedBy: .equal, toItem: topContainer, attribute: .centerX, multiplier: 1, constant: 0))
        topConstraints.append(NSLayoutConstraint(item: segmentedControl, attribute: .width, relatedBy: .equal, toItem: topContainer, attribute: .width, multiplier: 0.8, constant: 0))
        if !isX{
            topConstraints.append(NSLayoutConstraint(item: segmentedControl, attribute: .height, relatedBy: .equal, toItem: topContainer, attribute: .height, multiplier: 0.5, constant: 0))
        } else {
            topConstraints.append(NSLayoutConstraint(item: segmentedControl, attribute: .height, relatedBy: .equal, toItem: topContainer, attribute: .height, multiplier: 0.4, constant: 0))
        }
        segmentedControl.addTarget(self, action: #selector(changeChartType(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        
        //<-------- BUTTON BAR -------->
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor(hex: "#DCDFE0", opacity: 1.0)
        
        topContainer.addSubview(buttonBar)
        topConstraints.append(NSLayoutConstraint(item: buttonBar, attribute: .top, relatedBy: .equal, toItem: segmentedControl, attribute: .bottom, multiplier: 0.95, constant: 0))
        topConstraints.append(NSLayoutConstraint(item: buttonBar, attribute: .height, relatedBy: .equal, toItem: segmentedControl, attribute: .height, multiplier: 0.075, constant: 0))
        topConstraints.append(NSLayoutConstraint(item: buttonBar, attribute: .width, relatedBy: .equal, toItem: segmentedControl, attribute: .width, multiplier: 0, constant: (self.view.frame.width*0.8)/2.25))
        topConstraints.append(NSLayoutConstraint(item: buttonBar, attribute: .centerX, relatedBy: .equal, toItem: segmentedControl, attribute: .centerX, multiplier: 1, constant: -(self.view.frame.width*0.8)/4))
        
        
        topContainer.addConstraints(topConstraints)
        // <---------- CENTER VIEW ---------->
        let centerView = UIView()
        centerView.translatesAutoresizingMaskIntoConstraints = false
        centerView.backgroundColor = UIColor(hex: "#9EBFC0")
        centerView.layer.borderWidth = 2.5
        centerView.layer.borderColor = UIColor(hex: "#0D3530").cgColor
        centerView.layer.shadowColor = UIColor.black.cgColor
        centerView.layer.shadowOpacity = 1
        centerView.layer.shadowOffset = .zero
        centerView.layer.shadowRadius = 20
        
        self.view.addSubview(centerView)
        constraints.append(NSLayoutConstraint(item: centerView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: centerView, attribute: .top, relatedBy: .equal, toItem: topContainer, attribute: .bottom, multiplier: 1, constant: self.view.frame.height / 80))
        constraints.append(NSLayoutConstraint(item: centerView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.95, constant: 0))
        constraints.append(NSLayoutConstraint(item: centerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -self.view.frame.height / 100))
        
        var centerConstraints: [NSLayoutConstraint] = []
        
        // <---------- PAGE CONTROLLER VIEW ---------->
        container.dataSource = self
        container.delegate = self
        setupChartViews()
        container.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChild(container)
        centerView.addSubview(container.view)
        centerConstraints.append(NSLayoutConstraint(item: container.view, attribute: .centerX, relatedBy: .equal, toItem: centerView, attribute: .centerX, multiplier: 1, constant: 0))
        centerConstraints.append(NSLayoutConstraint(item: container.view, attribute: .top, relatedBy: .equal, toItem: centerView, attribute: .top, multiplier: 1, constant: self.view.frame.height/80))
        centerConstraints.append(NSLayoutConstraint(item: container.view, attribute: .height, relatedBy: .equal, toItem: centerView, attribute: .height, multiplier: 0.7, constant: 0))
        centerConstraints.append(NSLayoutConstraint(item: container.view, attribute: .width, relatedBy: .equal, toItem: centerView, attribute: .width, multiplier: 0.95, constant: 0))
        container.didMove(toParent: self)
        
        // <---------- PAGE CONTROLL ---------->
        self.pageControl.frame = CGRect()
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = 1
        self.pageControl.pageIndicatorTintColor = UIColor(hex: "#0D3530")
        self.pageControl.currentPageIndicatorTintColor = .white
        
        centerView.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.bottomAnchor.constraint(equalTo: container.view.bottomAnchor, constant: 10).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: container.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: container.view.centerXAnchor).isActive = true
        
        // <---------- PICKER VIEW ---------->
        monthYearPicker = UIPickerView()
        monthYearPicker.dataSource = self
        monthYearPicker.delegate = self
        monthYearPicker.translatesAutoresizingMaskIntoConstraints = false
        monthYearPicker.backgroundColor = UIColor.init(hex: "#9EBFC0", opacity: 1)
        monthYearPicker.layer.addBorder(edge: .top, color: UIColor(hex: "#0D3530"), thickness: 4, width: self.view.frame.width * 0.95)
        centerView.addSubview(monthYearPicker)
        
        centerConstraints.append(NSLayoutConstraint(item: monthYearPicker, attribute: .height, relatedBy: .equal, toItem: centerView, attribute: .height, multiplier: 0.25, constant: 0))
        centerConstraints.append(NSLayoutConstraint(item: monthYearPicker, attribute: .bottom, relatedBy: .equal, toItem: centerView, attribute: .bottom, multiplier: 1, constant: 0))
        centerConstraints.append(NSLayoutConstraint(item: monthYearPicker, attribute: .width, relatedBy: .equal, toItem: centerView, attribute: .width, multiplier: 1, constant: 0))
        centerConstraints.append(NSLayoutConstraint(item: monthYearPicker, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        
        monthYearPicker.selectRow(currentMonth-1, inComponent: 0, animated: false)
        monthYearPicker.selectRow(5, inComponent: 1, animated: false)
        
        // <---------- CONSTRAINTS ---------->
        NSLayoutConstraint.activate(centerConstraints)
        NSLayoutConstraint.activate(constraints)
    }
    
    internal func setupChartViews() {
        let page2 = ChartView(id: 1, month: currentMonth, year: currentYear)
        let page1 = ChartView(id: 2, month: currentMonth, year: currentYear)
        let page3 = ChartView(id: 3, month: currentMonth, year: currentYear)
        
        self.pages.append(page2)
        self.pages.append(page1)
        self.pages.append(page3)
        
        let pagePie1 = PieChartCV(id: 1, month: currentMonth, year: currentYear)
        let pagePie2 = PieChartCV(id: 2, month: currentMonth, year: currentYear)
        
        self.pagesPie.append(pagePie1)
        self.pagesPie.append(pagePie2)

        container.setViewControllers([self.pages[1]], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        setupSegmentedControl()
//        pages[0].view.round(corners: [.topLeft, .bottomLeft], radius: 20)
//        pages[0].view.frame = pages[0].view.frame.offsetBy(dx: 10, dy: 0)
//        pages[2].view.round(corners: [.topRight, .bottomRight], radius: 20)
//        pages[2].view.frame = pages[2].view.frame.offsetBy(dx: -10, dy: 0)
//        pagesPie[0].view.round(corners: [.topLeft, .bottomLeft], radius: 20)
//        pagesPie[0].view.frame = pagesPie[0].view.frame.offsetBy(dx: 10, dy: 0)
//        pagesPie[1].view.round(corners: [.topRight, .bottomRight], radius: 20)
//        pagesPie[1].view.frame = pagesPie[1].view.frame.offsetBy(dx: -10, dy: 0)
    }
}
