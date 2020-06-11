//
//  GoalPopVC.swift
//  Financer
//
//  Created by Valentin Witzeneder on 17.03.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Charts

class GoalPopVC: UIViewController, ChartViewDelegate {
    
    func setupVC(goal: Goal) {
        self.view.backgroundColor = .clear
        let chartView = LineChartView()
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let startDate = format.string(from: goal.startDate)
        let endDate = format.string(from: goal.endDate)
    
        let entries = realmManager.getCurrentGoalEntries(goal: goal)
        
        var amount = 0.0
        for entry in entries {
            amount += entry.amount
        }
        
        chartView.backgroundColor = .clear
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.isUserInteractionEnabled = false
        chartView.delegate = self
        
        chartView.gridBackgroundColor = UIColor.init(hex: "#0C6980", opacity: 0.2)
        chartView.drawGridBackgroundEnabled = true

        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = goal.amount * 1.1
        if amount > goal.amount {
            leftAxis.axisMaximum = amount * 1.1
        }
        leftAxis.axisMinimum = 0
        leftAxis.drawAxisLineEnabled = false

        chartView.rightAxis.enabled = false

        var constraints: [NSLayoutConstraint] = []
        var height = 300
        if isX {
            height = 500
        }
        constraints.append(NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat(height)))
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.85, constant: 0))
        constraints.append(NSLayoutConstraint(item: chartView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.95, constant: 0))
        
        self.view.addSubview(chartView)
        self.view.addConstraints(constraints)
        
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: goal.startDate)
        let date2 = calendar.startOfDay(for: goal.endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        guard let daysInBetween = components.day else { return }
        
        var goalDataSet: [ChartDataEntry] = []
        goalDataSet.append(ChartDataEntry(x: 0, y: goal.amount))
        goalDataSet.append(ChartDataEntry(x: Double(daysInBetween), y: goal.amount))
        
        var entriesDataSet: [ChartDataEntry] = []
        var dataEntries = [Double](repeating: 0.0, count: daysInBetween + 1)
        
        for entry in entries {
            let date = calendar.startOfDay(for: entry.date)
            let dateComp = calendar.dateComponents([.day], from: date1, to: date)
            guard let daysBetween = dateComp.day else { continue }
            
            dataEntries[daysBetween] += entry.amount
        }
        
        for i in 0..<dataEntries.count {
            if i+1 < dataEntries.count {
                dataEntries[i+1] += dataEntries[i]
            }
        }
        
        
        for i in 0..<dataEntries.count {
            entriesDataSet.append(ChartDataEntry(x: Double(i), y: dataEntries[i]))
        }
        
        let line1 = LineChartDataSet(entries: goalDataSet, label: NSLocalizedString("goal.goalLine", comment: ""))
        line1.colors = [UIColor.init(hex: "#CD0000", opacity: 1.0)]
        line1.axisDependency = .left
        line1.lineWidth = 3
        line1.drawCirclesEnabled = false
        
        let line2 = LineChartDataSet(entries: entriesDataSet, label: NSLocalizedString("goal.actualLine", comment: ""))
        line2.colors = [UIColor.init(hex: "#00cd00", opacity: 1.0)]
        line2.axisDependency = .left
        line2.lineWidth = 3
        line2.drawCirclesEnabled = false
        line2.drawValuesEnabled = false

        let data = LineChartData()
        data.addDataSet(line1)
        data.addDataSet(line2)
        
        chartView.data = data
        chartView.chartDescription?.text = startDate + NSLocalizedString("goal.to", comment: "") + endDate + " [" + String(daysInBetween) + NSLocalizedString("goal.days", comment: "")
    }
}
