//
//  ChartVC.swift
//  Financer
//
//  Created by Valentin Witzeneder on 01.09.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Charts

class ChartVC: UIViewController, ChartViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /// Used for PickerView data
    private var years: [Int] = []
    
    /// Used for getting the actual current Month/Year when opening first time - then selected value from picker
    internal var currentMonth: Int!
    internal var currentYear: Int!
    
    /// Determines which Tab is selected for switching between Incomes/Outcomes/Balance
    private var tabID: Int!
    
    /// The Picker for selecting which Month/Year should be displayed
    internal var monthYearPicker: UIPickerView!
    
    /// Segmented Control to change what chart should be displayed [ BarChart/PieChart ]
    internal var segmentedControl: CustomSegmentedControl!
    
    /// If the numeric representation should be shown (= BarChart)
    internal var isNumericChart = true
    
    /// Container which holds the chart views
    internal var container: UIPageViewController!
    
    /// The 3 different bar chart views which are displayed in the container
    internal var pages = [ChartView]()
    
    /// The 2 different pie chart views which are displayed in the container
    internal var pagesPie = [PieChartCV]()
    
    /// The page controls which displayes on which page of the container the user is on
    internal let pageControl = UIPageControl()
    
    internal lazy var buttonBar: UIView = {
        return UIView()
    }()
    
    internal lazy var topContainer: UIView = {
        return UIView()
    }()
    
    init(id: Int) {
        super.init(nibName: nil, bundle: nil)
        self.container = TestPVC(superView: self)
        self.tabID = id
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        currentYear = year
        for i in year-5...year+5 {
            years.append(i)
        }
        let month = calendar.component(.month, from: date)
        currentMonth = month
        setupUI()
        
        for subview in self.view.subviews {
            subview.isExclusiveTouch = true
        }
        self.view.isMultipleTouchEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if segmentedControl.selectedSegmentIndex == 0 {
            for page in pages {
                page.loadData()
                page.setupChart(month: currentMonth, year: currentYear)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 12
        } else {
            return 11
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleData = ""
        
        if component == 0 {
            titleData = monthsString[row]
        } else {
            titleData = String(years[row])
        }
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            currentMonth = row + 1
        } else {
            currentYear = years[row]
        }
        if segmentedControl.selectedSegmentIndex == 0 {
            for cv in pages {
                cv.setupChart(month: currentMonth, year: currentYear)
            }
        }
        else {
            for cv in pagesPie {
                cv.loadData(month: currentMonth, year: currentYear)
                cv.setupChart()
            }
        }
    }
    
    
    @objc internal func changeChartType(_ sender : UISegmentedControl) {
        animateSegmentedControl()
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            let transform = self.container.view.transform
            if self.segmentedControl.selectedSegmentIndex == 1 {
                for page in self.pagesPie {
                    page.loadData(month: self.currentMonth, year: self.currentYear)
                    page.setupChart()
                }
                UIView.animate(withDuration: 0.1, animations: {
                    self.container.setViewControllers([self.pagesPie[0]], direction: .forward, animated: true, completion: nil)
                    self.pageControl.numberOfPages = self.pagesPie.count
                    self.pageControl.currentPage = 0
                }) { (finished) in
                    if finished {
                        UIView.animate(withDuration: 0.1, delay: 0.2, animations: {
                            self.container.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        }, completion: { (finished) in
                            if finished {
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.container.view.transform = transform
                                }, completion: { (finished) in
                                    if finished {
                                        self.view.isUserInteractionEnabled = true
                                    }
                                })
                            }
                        })
                    }
                }
            } else if self.segmentedControl.selectedSegmentIndex == 0 {
                for page in self.pages {
                    page.loadData()
                    page.setupChart(month: self.currentMonth, year: self.currentYear)
                }
                UIView.animate(withDuration: 0.1, animations: {
                    self.container.setViewControllers([self.pages[1]], direction: .forward, animated: true, completion: nil)
                    self.pageControl.numberOfPages = self.pages.count
                    self.pageControl.currentPage = 1
                }) { (finished) in
                    if finished {
                        UIView.animate(withDuration: 0.1, delay: 0.2, animations: {
                            self.container.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        }, completion: { (finished) in
                            if finished {
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.container.view.transform = transform
                                }, completion: { (finished) in
                                    if finished {
                                        self.view.isUserInteractionEnabled = true
                                    }
                                })
                            }
                        })
                    }
                }
            }
        }
    }
}

