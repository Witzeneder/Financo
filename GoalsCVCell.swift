//
//  GoalsCVCell.swift
//  Financer
//
//  Created by Valentin Witzeneder on 17.03.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit

class GoalsCVCell: UICollectionViewCell {
    
    let amountTextField = UITextField()
    let dateTextField = UITextField()
    let statusImageView = UIImageView()

    func setupLabels(goal: Goal) {
        
        var indicator = " > "
        if goal.goalType == GoalType.less.rawValue {
            indicator = " < "
        }
        let stringAmount = goal.label + indicator + String(goal.amount) + currency
        amountTextField.text = stringAmount
        
        let format = DateFormatter()
        format.dateFormat = "yyyy MM dd"
        
        
        let startDate = format.string(from: goal.startDate)
        let endDate = format.string(from: goal.endDate)
        
        dateTextField.text = startDate + " - " + endDate
    
        var image = UIImage(named: "unchecked")
        
        //TODO: Maybe difference between finished and not finished
        if goal.isFinished {
            if goal.isSuccess {
                image = UIImage(named: "checked")
            } else {
                image = UIImage(named: "failure")
            }
        }
        statusImageView.image = image
        setupUI()
    }
    
    private func setupUI() {
        
        var constraints: [NSLayoutConstraint] = []
        
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.textAlignment = .center
        amountTextField.font =  UIFont(name: "Avenir-Heavy", size: (self.frame.height * 0.65) / 2)
        
        self.addSubview(amountTextField)
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.65, constant: 0))
        
        
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.textAlignment = .left
        dateTextField.font = UIFont(name: "Avenir-Light", size: (self.frame.height*0.2)/1.5)
        self.addSubview(dateTextField)
        constraints.append(NSLayoutConstraint(item: dateTextField, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: self.frame.width / 15))
        constraints.append(NSLayoutConstraint(item: dateTextField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -self.frame.height / 15))
        constraints.append(NSLayoutConstraint(item: dateTextField, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.7, constant: 0))
        constraints.append(NSLayoutConstraint(item: dateTextField, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.3, constant: 0))
        
        
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.contentMode = .scaleAspectFit
        self.addSubview(statusImageView)
        constraints.append(NSLayoutConstraint(item: statusImageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -self.frame.width / 100))
        constraints.append(NSLayoutConstraint(item: statusImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -self.frame.height / 15))
        constraints.append(NSLayoutConstraint(item: statusImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.2, constant: 0))
        constraints.append(NSLayoutConstraint(item: statusImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.4, constant: 0))
        self.addConstraints(constraints)
        
        
        amountTextField.isUserInteractionEnabled = false
        dateTextField.isUserInteractionEnabled = false
    }
}
