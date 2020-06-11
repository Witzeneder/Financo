//
//  ChartView.swift
//  Financer
//
//  Created by Valentin Witzeneder on 24.02.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Charts
import Lottie

class ChartView: UIViewController, ChartViewDelegate, UIGestureRecognizerDelegate {
    
    private var chartView: BarChartView!
    private var chartDescription: String = ""
    private var chartColor = UIColor.init(hex: "#00cd00", opacity: 0.75)
    private var chartID: Int!
    private let animationView: AnimationView!
    
    /// Data retrieved from RealmManager with same month data combined for chart
    private var monthlySortedEntries: [MonthEntry] = []
    
    init(id: Int, month: Int, year: Int) {
        animationView = AnimationView(name: "wal")
        chartID = id
        super.init(nibName: nil, bundle: nil)
        setupUI()
        loadData()
        setupChart(month: month, year: year)
        self.view.backgroundColor = UIColor.init(hex: "#9EBFC0")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.view.isUserInteractionEnabled = false
        var constraints: [NSLayoutConstraint] = []
        
        // <---------- CHART VIEW ---------->
        chartView = BarChartView()
        chartView.backgroundColor = UIColor(hex: "9EBFC0")
        chartView.delegate = self
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.isUserInteractionEnabled = false
        
        var inset = 0
//        if chartID == 1 {
//            inset = -5
//        } else if chartID == 3 {
//            inset = 5
//        }
        
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: CGFloat(inset)))
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.95, constant: 0))
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.95, constant: 0))
        
        self.view.addSubview(chartView)
        
        self.view.addConstraints(constraints)
    }
    
    /// Sets the charts with data from specific Date (Year + Month) +- 2 Months
    ///
    /// - Parameters:
    ///   - month: Specific Month where data is wanted
    ///   - year: Specific Year where data is wanted
    internal func setupChart(month: Int, year: Int) {
        var dataEntries: [ChartDataEntry] = []
        
        var shouldShowAnimation = true
        
        var months = Array(repeating: "", count: 5)
        var amountFound = Array(repeating: 0.0, count: 5)
        
        for i in -2...2 {
            var newMonth = month + i
            var newYear = year
            
            if newMonth < 1 {
                newMonth = 12 - abs(newMonth)
                newYear = year - 1
            }
            else if newMonth > 12 {
                newMonth = newMonth - 12
                newYear = year + 1
            }
            
            // CHANGE DATA IN ARRAYS
            months[i+2] = monthsString[newMonth - 1]
            
            for entry in monthlySortedEntries {
                if entry.year == newYear {
                    if entry.month == newMonth {
                        amountFound[i+2] = entry.amount
                        shouldShowAnimation = false
                        continue
                    }
                }
            }
        }
        
        dataEntries.append(BarChartDataEntry(x: 0, y: amountFound[0]))
        dataEntries.append(BarChartDataEntry(x: 1, y: amountFound[1]))
        dataEntries.append(BarChartDataEntry(x: 2, y: amountFound[2]))
        dataEntries.append(BarChartDataEntry(x: 3, y: amountFound[3]))
        dataEntries.append(BarChartDataEntry(x: 4, y: amountFound[4]))
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: chartDescription)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.colors = [chartColor]
        chartView.data = chartData
        chartView.leftAxis.spaceBottom = 0.0
        chartView.rightAxis.enabled = false
        chartView.chartDescription?.text = ""
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chartView.xAxis.granularity = 1
        chartView.animate(yAxisDuration: 0.1, easingOption: .linear)
        
        if shouldShowAnimation {
            setupLoadingAnimation()
        } else {
            animationView.removeFromSuperview()
        }
    }
    
    internal func loadData() {
        var sortedEntries: [SortedEntry] = []
        switch chartID {
        case 1:
            sortedEntries = realmManager.getIncomesSorted()
            monthlySortedEntries = realmManager.getIncOutMonthly(sortedEntries: sortedEntries)
            chartDescription = NSLocalizedString("incomes.name", comment: "")
            chartColor = UIColor.init(hex: "#28B463", opacity: 1)
        case 3:
            sortedEntries = realmManager.getOutcomesSorted()
            monthlySortedEntries = realmManager.getIncOutMonthly(sortedEntries: sortedEntries)
            chartDescription = NSLocalizedString("outcomes.name", comment: "")
            chartColor = UIColor.init(hex: "#A93226", opacity: 1)
        case 2:
            sortedEntries = realmManager.getBalanceSorted()
            monthlySortedEntries = realmManager.getBalanceMonthly(sortedEntries: sortedEntries)
            chartDescription = NSLocalizedString("balances.name", comment: "")
            chartColor = UIColor.init(hex: "#2471A3", opacity: 1)
        default:
            fatalError("default in switchting tabID can never happen")
        }
    }
    
    private func setupLoadingAnimation() {
        // <---------- ANIMATION VIEW ---------->
        animationView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.isUserInteractionEnabled = false
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundColor = UIColor(hex: "#9EBFC0")
        animationView.loopMode = .loop
        self.view.addSubview(animationView)
        
        var constraints: [NSLayoutConstraint] = []
        var inset = 0
        if chartID == 1 {
            inset = -5
        } else if chartID == 3 {
            inset = 5
        }
                
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: CGFloat(inset)))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.95, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.95, constant: 0))
        
        self.view.addConstraints(constraints)
        
        animationView.animationSpeed = 0.8
        animationView.play()
    }
}
