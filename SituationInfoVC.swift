//
//  SituationInfoVC.swift
//  Financer
//
//  Created by Valentin Witzeneder on 26.02.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Lottie

class SituationInfoVC: UIViewController {
    
    private let currentYear: Int!
    private let currentMonth: Int!
    
    private var monthIncome = 0.0
    private var monthOutcome = 0.0
    
    private var outcomeAmountLabel: UILabel!
    
    private var incomeAmountLabel: UILabel!
    
    private var imageView: UIImageView!
    
    init(currentMonth: Int, currentYear: Int) {
        self.currentYear = currentYear
        self.currentMonth = currentMonth
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let incomesSorted = realmManager.getIncomesSorted()
        let outcomesSorted = realmManager.getOutcomesSorted()
        
        let incomesMonth = realmManager.getIncOutMonthly(sortedEntries: incomesSorted)
        let outcomesMonth = realmManager.getIncOutMonthly(sortedEntries: outcomesSorted)
        
        for incomes in incomesMonth {
            if incomes.month == self.currentMonth && incomes.year == self.currentYear {
                monthIncome = incomes.amount
            }
        }
        for outcomes in outcomesMonth {
            if outcomes.month == self.currentMonth && outcomes.year == self.currentYear {
                monthOutcome = outcomes.amount
            }
        }
        incomeAmountLabel.text = String(monthIncome) + currency
        outcomeAmountLabel.text = String(monthOutcome) + currency

    }
    

    
    private func setupUI() {
        self.view.backgroundColor = .clear
        var constraints:[NSLayoutConstraint] = []
        
        // <---------- OUTCOME LABEL ---------->
        
        incomeAmountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        incomeAmountLabel.textColor = UIColor(hex: "#DCDFE0")
        incomeAmountLabel.text = "0.0" + currency
        incomeAmountLabel.textAlignment = .center
        incomeAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(NSLayoutConstraint(item: incomeAmountLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: incomeAmountLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: self.view.frame.width / 30))
        constraints.append(NSLayoutConstraint(item: incomeAmountLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.3, constant: 0))
        constraints.append(NSLayoutConstraint(item: incomeAmountLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0))
        
        self.view.addSubview(incomeAmountLabel)
        
        // <---------- INCOME LABEL ---------->

        outcomeAmountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        outcomeAmountLabel.textColor = UIColor(hex: "#DCDFE0")
        outcomeAmountLabel.text = "0.0" + currency
        outcomeAmountLabel.textAlignment = .center
        outcomeAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(NSLayoutConstraint(item: outcomeAmountLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: outcomeAmountLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -self.view.frame.width / 30))
        constraints.append(NSLayoutConstraint(item: outcomeAmountLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.3, constant: 0))
        constraints.append(NSLayoutConstraint(item: outcomeAmountLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0))
        
        self.view.addSubview(outcomeAmountLabel)
        
        // <---------- IMAGE VIEW ---------->
        
        imageView = UIImageView(image: UIImage(named: "arrow_LR"))
        imageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        self.view.addSubview(imageView)
        
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.5, constant: 0))
        constraints.append(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.5, constant: 0))
        
        
        self.view.addConstraints(constraints)
    }
 
    
    override func viewDidLayoutSubviews() {
        outcomeAmountLabel.font = UIFont.boldSystemFont(ofSize: 200)
        outcomeAmountLabel.numberOfLines = 0
        outcomeAmountLabel.adjustsFontSizeToFitWidth = true
        
        incomeAmountLabel.font = UIFont.boldSystemFont(ofSize: 200)
        incomeAmountLabel.numberOfLines = 0
        incomeAmountLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    func setLabelsNew(income: Double, outcome: Double) {
        incomeAmountLabel.text = String(income) + currency
        outcomeAmountLabel.text = String(outcome) + currency
    }
    
}
