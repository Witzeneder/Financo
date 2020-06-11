//
//  EntryCellCV.swift
//  Financer
//
//  Created by Valentin Witzeneder on 27.09.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit

class EntryCellCV: UICollectionViewCell {
    
    let recurrentLabel = UILabel()
    let amountLabel = UILabel()
    let useView = UITextView()

    func setupLabels(recurrentEntry: RecurrentEntry) {
        amountLabel.text = String(recurrentEntry.amount) + " " + currency
        
        
        useView.isEditable = false
        useView.backgroundColor = .clear
        useView.text = String(recurrentEntry.use)
        
        
        if recurrentEntry.months == 1 && recurrentEntry.days == 0 {
            recurrentLabel.text = NSLocalizedString("recurrent.monthly", comment: "")
        } else if recurrentEntry.months == 0 && recurrentEntry.days == 1 {
            recurrentLabel.text = NSLocalizedString("recurrent.daily", comment: "")
        } else {
            if recurrentEntry.months > 0 {
                recurrentLabel.text = NSLocalizedString("recurrent.every", comment: "") + String(recurrentEntry.months) + NSLocalizedString("recurrent.month", comment: "")
                if recurrentEntry.months > 1 {
                    recurrentLabel.text?.append(NSLocalizedString("recurrent.plural", comment: ""))
                }
                if recurrentEntry.days > 0 {
                    recurrentLabel.text?.append(NSLocalizedString("recurrent.and", comment: "") + String(recurrentEntry.days) + NSLocalizedString("recurrent.day", comment: ""))
                    if recurrentEntry.days > 1 {
                        recurrentLabel.text?.append(NSLocalizedString("recurrent.plural", comment: ""))
                    }
                }
            } else {
                recurrentLabel.text = NSLocalizedString("recurrent.every", comment: "") + String(recurrentEntry.days) + NSLocalizedString("recurrent.day", comment: "")
                if recurrentEntry.days > 1 {
                    recurrentLabel.text?.append(NSLocalizedString("recurrent.plural", comment: ""))
                }
            }
        }
        setupUI()
    }
    
    private func setupUI() {
        
        var constraints: [NSLayoutConstraint] = []
        
        // <---------- AMOUNT LABEL ---------->
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.font =  UIFont(name: "Avenir-Heavy", size: (self.frame.height * 0.65) / 2)
        
        constraints.append(NSLayoutConstraint(item: amountLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.65, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.9, constant: 0))
        
        self.addSubview(amountLabel)
        
        // <---------- USE TEXTVIEW ---------->
        useView.translatesAutoresizingMaskIntoConstraints = false
        useView.font = UIFont(name: "Avenir-Light", size: (self.frame.height*0.3)/2)
        
        constraints.append(NSLayoutConstraint(item: useView, attribute: .top, relatedBy: .equal, toItem: amountLabel, attribute: .bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: useView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10))
        constraints.append(NSLayoutConstraint(item: useView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5))
        constraints.append(NSLayoutConstraint(item: useView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.3, constant: 0))
        
        self.addSubview(useView)
        
        // <---------- RECURRENT LABEL ---------->
        recurrentLabel.translatesAutoresizingMaskIntoConstraints = false
        recurrentLabel.font = UIFont(name: "Avenir-Light", size: (self.frame.height*0.3)/2)
        
        constraints.append(NSLayoutConstraint(item: recurrentLabel, attribute: .top, relatedBy: .equal, toItem: amountLabel, attribute: .bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: recurrentLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10))
        constraints.append(NSLayoutConstraint(item: recurrentLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5))
        constraints.append(NSLayoutConstraint(item: recurrentLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.6, constant: 0))
        
        self.addSubview(recurrentLabel)
        self.addConstraints(constraints)
        self.amountLabel.textAlignment = .center
        self.useView.textAlignment = .left
        self.recurrentLabel.textAlignment = .right
    }
    
}
