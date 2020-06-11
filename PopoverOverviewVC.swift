//
//  PopoverOverviewVC.swift
//  Financer
//
//  Created by Valentin Witzeneder on 16.03.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit

class PopoverOverviewVC: UIViewController {

    let inOrOutcome: UITextField!
    let sectionTextField: UITextField!
    let startDateTextField: UITextField!
    let endDateTextField: UITextField!
    let dateSeperator: UIView!
    
    let startDate: Date!
    let endDate: Date!
    let amount: String!
    let label: String!
    let isIncome: Bool!
    let indicator: Int!
    
    var height: CGFloat!
    
    //0D3530
    
    fileprivate func setupUI() {
        self.view.backgroundColor = UIColor(hex: "#DCDFE0")

        var constraints: [NSLayoutConstraint] = []
        
        height = height/2
        
        constraints.append(NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat(height)))
        
        inOrOutcome.translatesAutoresizingMaskIntoConstraints = false
        inOrOutcome.textAlignment = .center
        self.view.addSubview(inOrOutcome)
        constraints.append(NSLayoutConstraint(item: inOrOutcome, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: inOrOutcome, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: height/10))
        constraints.append(NSLayoutConstraint(item: inOrOutcome, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.85, constant: 0))
        constraints.append(NSLayoutConstraint(item: inOrOutcome, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0))
        
        sectionTextField.translatesAutoresizingMaskIntoConstraints = false
        sectionTextField.textAlignment = .center
        self.view.addSubview(sectionTextField)
        constraints.append(NSLayoutConstraint(item: sectionTextField, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: sectionTextField, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: sectionTextField, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.85, constant: 0))
        constraints.append(NSLayoutConstraint(item: sectionTextField, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.25, constant: 0))
        

        
        var multiplier: CGFloat = 0.6
        if !isX {
            multiplier = 0.45
        }
        
        endDateTextField.translatesAutoresizingMaskIntoConstraints = false
        endDateTextField.textAlignment = .center
        self.view.addSubview(endDateTextField)
        constraints.append(NSLayoutConstraint(item: endDateTextField, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: endDateTextField, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -self.view.frame.height / 50))
        constraints.append(NSLayoutConstraint(item: endDateTextField, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: multiplier, constant: 0))
        constraints.append(NSLayoutConstraint(item: endDateTextField, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.08, constant: 0))
        
        dateSeperator.translatesAutoresizingMaskIntoConstraints = false
        dateSeperator.backgroundColor = .black
        self.view.addSubview(dateSeperator)
        constraints.append(NSLayoutConstraint(item: dateSeperator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: dateSeperator, attribute: .bottom, relatedBy: .equal, toItem: endDateTextField, attribute: .top, multiplier: 1, constant: -self.view.frame.height / 70))
        constraints.append(NSLayoutConstraint(item: dateSeperator, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.05, constant: 0))
        constraints.append(NSLayoutConstraint(item: dateSeperator, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.01, constant: 0))
        
        startDateTextField.translatesAutoresizingMaskIntoConstraints = false
        startDateTextField.textAlignment = .center
        self.view.addSubview(startDateTextField)
        constraints.append(NSLayoutConstraint(item: startDateTextField, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: startDateTextField, attribute: .bottom, relatedBy: .equal, toItem: dateSeperator, attribute: .top, multiplier: 1, constant: -self.view.frame.height / 70))
        constraints.append(NSLayoutConstraint(item: startDateTextField, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: multiplier, constant: 0))
        constraints.append(NSLayoutConstraint(item: startDateTextField, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.08, constant: 0))
        
        
        
        self.view.addConstraints(constraints)
    }
    
    fileprivate func setupTexts() {
    
        var inOutString = ""
        
        if isIncome {
            inOutString = NSLocalizedString("incomes.name", comment: "")
        } else {
            inOutString = NSLocalizedString("outcomes.name", comment: "")
        }
    
        if indicator == 0 {
            inOutString += " > "
        } else {
            inOutString += " < "
        }
        
        inOutString += (amount + currency)
        
        inOrOutcome.text = inOutString
        
        if label == NSLocalizedString("label.everything", comment: "") {
            sectionTextField.text = NSLocalizedString("goal.EveryLabel", comment: "")
        } else {
            sectionTextField.text = label
        }
        
        let format = DateFormatter()
        format.dateFormat = "yyyy MM dd"
        
        startDateTextField.text = format.string(from: startDate)
        endDateTextField.text = format.string(from: endDate)
        
    }
    
    init(startDate: Date, endDate: Date, amount: String, indicator: Int, label: String, isIncome: Bool, screenHight: CGFloat) {
        inOrOutcome = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        sectionTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        startDateTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        endDateTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dateSeperator = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.startDate = startDate
        self.endDate = endDate
        self.amount = amount
        self.label = label
        self.isIncome = isIncome
        self.indicator = indicator
        self.height = screenHight
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupTexts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        
        inOrOutcome.font = UIFont(name: "Avenir-Heavy", size: self.view.frame.height*0.2/2)
        inOrOutcome.adjustsFontSizeToFitWidth = true
        inOrOutcome.textColor = UIColor(hex: "0D3530")
        
        sectionTextField.font = UIFont(name: "Avenir-Heavy", size: self.view.frame.height*0.25/2.5)
        sectionTextField.textColor = UIColor(hex: "0D3530")
        
        startDateTextField.font = UIFont(name: "Avenir-Light", size: self.view.frame.height*0.15/2)
        startDateTextField.adjustsFontSizeToFitWidth = true
        startDateTextField.textColor = UIColor(hex: "0D3530")
        
        endDateTextField.font = UIFont(name: "Avenir-Light", size: self.view.frame.height*0.15/2)
        endDateTextField.adjustsFontSizeToFitWidth = true
        endDateTextField.textColor = UIColor(hex: "0D3530")
        
        
    }
}
