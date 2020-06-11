//
//  PieChartCV
//  Financer
//
//  Created by Valentin Witzeneder on 24.02.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Lottie
import Charts

class PieChartCV: UIViewController, ChartViewDelegate {
    
    private var chartView: PieChartView!
    private var chartDescription: String = ""
    private var chartColor = UIColor.init(hex: "#00cd00", opacity: 0.75)
    private var chartID: Int!
    private let animationView: AnimationView!
    private var labelEntries: [LabelEntry] = []
    
    /// Data retrieved from RealmManager with same month data combined for chart
    private var monthlySortedEntries: [MonthEntry] = []
    
    init(id: Int, month: Int, year: Int) {
        animationView = AnimationView(name: "wal")
        chartID = id
        super.init(nibName: nil, bundle: nil)
        setupUI()
        loadData(month: month, year: year)
        setupChart()
        self.view.backgroundColor = UIColor.init(hex: "#9EBFC0")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        var constraints: [NSLayoutConstraint] = []
        
        // <---------- CHART VIEW ---------->
        chartView = PieChartView()
        chartView.backgroundColor = .clear
        chartView.delegate = self
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        var inset = 0
        if chartID == 1 {
            inset = -5
        } else if chartID == 2 {
            inset = 5
        }
        
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: CGFloat(inset)))
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.95, constant: 0))
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.95, constant: 0))
        
        self.view.addSubview(chartView)
        
        self.view.addConstraints(constraints)
    }
    
    internal func loadData(month: Int, year: Int) {
        var sortedEntries: [SortedEntry] = []
        switch chartID {
        case 1:
            sortedEntries = realmManager.getIncomesSorted()
            let stringPart = NSLocalizedString("incomes.name", comment: "")
            chartDescription = stringPart + " in %"
            chartColor = UIColor.init(hex: "#00cd00", opacity: 1)
        case 2:
            sortedEntries = realmManager.getOutcomesSorted()
            let stringPart = NSLocalizedString("outcomes.name", comment: "")
            chartDescription = stringPart + " in %"
            chartColor = UIColor.init(hex: "#CD0000", opacity: 1)
        default:
            fatalError("default in switchting tabID can never happen")
        }
        labelEntries = realmManager.getLabelSorted(sortedEntries: sortedEntries, month: month, year: year)
        
    }
    
    internal func setupChart() {
        var dataEntries: [ChartDataEntry] = []
        var sum = 0.0
        
        for entry in labelEntries {
            sum += entry.amount
        }
        
        if labelEntries.count < 1 {
            setupLoadingAnimation()
        } else {
            animationView.removeFromSuperview()
        }
        
        for entry in labelEntries {
            entry.divide(amount: sum)
            let dataEntry = PieChartDataEntry()
            dataEntry.y = entry.getAmount()
            dataEntry.label = entry.label
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet( entries: dataEntries, label: "")
        var colors: [UIColor] = []
        let pieChartColors = PieChartColors()
        colors = pieChartColors.getColors(size: dataEntries.count)
        
        
        chartDataSet.colors = colors
        let chartData = PieChartData(dataSet: chartDataSet)
        chartView.data = chartData

        chartView.chartDescription?.text = chartDescription
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 3.0, easingOption: .easeOutQuart)
    }
    
    private func setupLoadingAnimation() {
        // <---------- ANIMATION VIEW ---------->
        animationView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundColor = UIColor(hex: "#9EBFC0")
        animationView.loopMode = .loop
        self.view.addSubview(animationView)
        
        var constraints: [NSLayoutConstraint] = []
        
        var inset = 0
        if chartID == 1 {
            inset = -5
        } else if chartID == 2 {
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
