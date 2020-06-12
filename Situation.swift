//
//  Situation.swift
//  Financer
//
//  Created by Valentin Witzeneder on 26.09.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Charts
import Lottie
import GoogleMobileAds

class Situation: UIViewController, ChartViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GADInterstitialDelegate {
    
    /// Used for PickerView data
    private var years: [Int] = []
    
    /// Used for getting the actual current Month/Year when opening first time - then selected value from picker
    internal var currentMonth: Int!
    internal var currentYear: Int!
    
    /// Data retrieved from RealmManager with same month data combined for chart
    private var monthlySortedEntries: [String: [MonthEntry]] = [:]
    
    /// The actual chartView which displays the chart
    internal var chartView: BarChartView!
    
    /// The Picker for selecting which Month/Year should be displayed
    internal var monthYearPicker: UIPickerView!

    /// Container View for information on the top
    internal var container: UIPageViewController!
    internal var pages:[UIViewController] = []
    internal var pageControl: UIPageControl!
    
    internal var sortedIncomes: [SortedEntry] = []
    internal var sortedOutcomes: [SortedEntry] = []
    
    internal let animationView: AnimationView!

    internal let centerView: UIView!
    
    private lazy var interstitialAD: GADInterstitial = {
        //TODO: Change to newEntryAD ID
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-2891745232433162/5321233032")
        interstitial.delegate = self
        return interstitial
    }()
    
    init() {
        animationView = AnimationView(name: "wal")
        centerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        super.init(nibName: nil, bundle: nil)
        
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
    }
    
    @objc func goBack(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
        
        DispatchQueue.main.async {
            self.setupChart(month: self.currentMonth, year: self.currentYear)
        }
    }

    override func viewDidLoad() {
        let request = GADRequest()
        interstitialAD.load(request)
    }

    
    private func reloadData() {
        var sortedEntries: [SortedEntry] = []
        
        sortedEntries = realmManager.getIncomesSorted()
        monthlySortedEntries["Incomes"] = realmManager.getIncOutMonthly(sortedEntries: sortedEntries)
        sortedIncomes = sortedEntries
        
        sortedEntries = realmManager.getOutcomesSorted()
        monthlySortedEntries["Outcomes"] = realmManager.getIncOutMonthly(sortedEntries: sortedEntries)
        sortedOutcomes = sortedEntries
    
        sortedEntries = realmManager.getBalanceSorted()
        monthlySortedEntries["Balance"] = realmManager.getBalanceMonthly(sortedEntries: sortedEntries)
    }
    
    /// Sets the charts with data from specific Date (Year + Month) +- 2 Months
    ///
    /// - Parameters:
    ///   - month: Specific Month where data is wanted
    ///   - year: Specific Year where data is wanted
    private func setupChart(month: Int, year: Int) {
        var dataEntries: [ChartDataEntry] = []
        var data = [0.0, 0.0, 0.0]
        var numberOfEntries = [0,0]
        
        var animationShouldPlay = true
        
        if let incomes = monthlySortedEntries["Incomes"] {
            for entry in incomes {
                if entry.year == year {
                    if entry.month == month {
                        animationShouldPlay = false
                        data[0] = entry.amount
                        numberOfEntries[0] = entry.entries
                        continue
                    }
                }
            }
        }
        
        if let outcomes = monthlySortedEntries["Outcomes"] {
            for entry in outcomes {
                if entry.year == year {
                    if entry.month == month {
                        animationShouldPlay = false
                        data[1] = entry.amount
                        numberOfEntries[1] = entry.entries
                        continue
                    }
                }
            }
        }
        
        let incomeLabel = realmManager.getMosedFrequentMonthlyLabel(sortedEntries: sortedIncomes, month: month, year: year)
        let outcomeLabel = realmManager.getMosedFrequentMonthlyLabel(sortedEntries: sortedOutcomes, month: month, year: year)
        
        let incomePage = pages[0] as! IncOutInfoVC
        incomePage.setLabelsNew(numberOfEntries: numberOfEntries[0], mostLabel: incomeLabel)
        let outcomePage = pages[2] as! IncOutInfoVC
        outcomePage.setLabelsNew(numberOfEntries: numberOfEntries[1], mostLabel: outcomeLabel)
        
        let infoPage = pages[1] as! SituationInfoVC
        infoPage.setLabelsNew(income: data[0], outcome: data[1])
        
        if let balances = monthlySortedEntries["Balance"] {
            for entry in balances {
                if entry.year == year {
                    if entry.month == month {
                        animationShouldPlay = false
                        data[2] = entry.amount
                        continue
                    }
                }
            }
        }
        
        if animationShouldPlay {
            setupLoadingAnimation()
        } else {
            
            UIView.animate(withDuration: 0.6, animations: {
                self.animationView.alpha = 0
            }) { (finished) in
                if finished {
                    self.animationView.removeFromSuperview()
                }
            }
        }
        
        dataEntries.append(BarChartDataEntry(x: 0, y: data[0]))
        dataEntries.append(BarChartDataEntry(x: 1, y: data[2]))
        dataEntries.append(BarChartDataEntry(x: 2, y: data[1]))
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: monthsString[month - 1] + " " + String(year) )
        let chartData = BarChartData(dataSet: chartDataSet)
        let incomeColor = UIColor.init(hex: "#28B463", opacity: 1)
        let outcomeColor = UIColor.init(hex: "#A93226", opacity: 1)
        let balanceColor = UIColor.init(hex: "#2471A3", opacity: 1)
        chartDataSet.colors = [incomeColor,balanceColor,outcomeColor]
        chartView.data = chartData
        chartView.rightAxis.enabled = false
        let xValues = [NSLocalizedString("incomes.name", comment: ""), NSLocalizedString("balances.name", comment: ""),NSLocalizedString("outcomes.name", comment: "")]
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        chartView.animate(yAxisDuration: 0.5, easingOption: .linear)
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
        setupChart(month: currentMonth, year: currentYear)
        
        if self.interstitialAD.isReady {
            let testMode =  ProcessInfo.processInfo.arguments.contains("testMode")
            if !testMode {
                self.interstitialAD.present(fromRootViewController: self)
            }
        }
        
    }

    override func viewDidLayoutSubviews() {
//        pages[0].view.round(corners: [.topLeft, .bottomLeft], radius: 20)
//        pages[0].view.frame = pages[0].view.frame.offsetBy(dx: 10, dy: 0)
//        pages[2].view.round(corners: [.topRight, .bottomRight], radius: 20)
//        pages[2].view.frame = pages[2].view.frame.offsetBy(dx: -10, dy: 0)
    }
    
    private func setupLoadingAnimation() {
        // <---------- ANIMATION VIEW ---------->
        animationView.alpha = 0
        animationView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundColor = UIColor(hex: "#9EBFC0")
        animationView.loopMode = .loop
        self.centerView.addSubview(animationView)
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: chartView, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal, toItem: chartView, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: chartView, attribute: .height, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: chartView, attribute: .width, multiplier: 1, constant: 0))
        
        self.centerView.addConstraints(constraints)
        
        UIView.animate(withDuration: 0.6, animations: {
            self.animationView.alpha = 1
        }) { (finished) in
            if finished {
                self.animationView.animationSpeed = 0.8
                self.animationView.play()
            }
        }
    }
}
