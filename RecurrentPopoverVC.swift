//
//  RecurrentPopoverVC.swift
//  Financer
//
//  Created by Valentin Witzeneder on 11.10.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//
 
import UIKit
import Lottie

class RecurrentPopoverVC: UIViewController {

    private lazy var amountLabel: UILabel = {
        return UILabel()
    }()
    
    private lazy var actualAmountLabel: UILabel = {
        return UILabel()
    }()
    
    private lazy var useLabel: UILabel = {
        return UILabel()
    }()
    
    private lazy var useTextView: UITextView = {
        return UITextView()
    }()
    
    private lazy var recurrentTimeLabel: UILabel = {
        return UILabel()
    }()
    
    private lazy var infoLabel: UILabel = {
        return UILabel()
    }()
    
    private let entry: RecurrentEntry!
    
    init(entry: RecurrentEntry) {
        self.entry = entry
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        
        var height = 450
        if !isX {
            height = 300
        }
        
        self.view.backgroundColor = UIColor(hex: "#DCDFE0")
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat(height)))
        
        useLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(useLabel)
        constraints.append(NSLayoutConstraint(item: useLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: useLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: useLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.15, constant: 0))
        constraints.append(NSLayoutConstraint(item: useLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.5, constant: 0))
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(amountLabel)
        constraints.append(NSLayoutConstraint(item: amountLabel, attribute: .top, relatedBy: .equal, toItem: useLabel, attribute: .bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.15, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.5, constant: 0))
        
        actualAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(actualAmountLabel)
        constraints.append(NSLayoutConstraint(item: actualAmountLabel, attribute: .top, relatedBy: .equal, toItem: useLabel, attribute: .bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: actualAmountLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: actualAmountLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.15, constant: 0))
        constraints.append(NSLayoutConstraint(item: actualAmountLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.5, constant: 0))
        
        useTextView.translatesAutoresizingMaskIntoConstraints = false
        useTextView.layer.borderColor = UIColor.init(hex: "#0D3530").cgColor
        useTextView.layer.borderWidth = 2.5
        useTextView.backgroundColor = .clear
        self.view.addSubview(useTextView)
        constraints.append(NSLayoutConstraint(item: useTextView, attribute: .top, relatedBy: .equal, toItem: actualAmountLabel, attribute: .bottom, multiplier: 1, constant: CGFloat(height/30)))
        constraints.append(NSLayoutConstraint(item: useTextView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.85, constant: 0))
        constraints.append(NSLayoutConstraint(item: useTextView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: useTextView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.4, constant: 0))
        
        recurrentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(recurrentTimeLabel)
        constraints.append(NSLayoutConstraint(item: recurrentTimeLabel, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: recurrentTimeLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: recurrentTimeLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0))
        constraints.append(NSLayoutConstraint(item: recurrentTimeLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.5, constant: 0))
        
        
        self.view.addConstraints(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        amountLabel.text = NSLocalizedString("entry.amount", comment: "")
        amountLabel.textAlignment = .center
        amountLabel.font = UIFont(name: "Avenir-Light", size: amountLabel.frame.height/2)
        amountLabel.adjustsFontSizeToFitWidth = true
        
        actualAmountLabel.text = String(entry.amount) + currency
        actualAmountLabel.textAlignment = .center
        actualAmountLabel.font = UIFont(name: "Avenir-Heavy", size: actualAmountLabel.frame.height/2)
        actualAmountLabel.textColor = UIColor(hex: "0D3530")
        actualAmountLabel.adjustsFontSizeToFitWidth = true
        
        useLabel.text = entry.label
        useLabel.textAlignment = .center
        useLabel.font = UIFont(name: "Avenir-Heavy", size: useLabel.frame.height/2)
        useLabel.textColor = UIColor(hex: "0D3530")
        useLabel.adjustsFontSizeToFitWidth = true
        
        useTextView.text = entry.use
        useTextView.textAlignment = .center
        useTextView.font = UIFont(name: "Avenir-Light", size: useTextView.frame.height/8)
        useTextView.textColor = UIColor(hex: "0D3530")
        useTextView.isUserInteractionEnabled = false
        
        recurrentTimeLabel.text = ""
        if entry.months == 1 && entry.days == 0 {
            recurrentTimeLabel.text = NSLocalizedString("recurrent.monthly", comment: "")
        } else if entry.months == 0 && entry.days == 1 {
            recurrentTimeLabel.text = NSLocalizedString("recurrent.daily", comment: "")
        } else {
            if entry.months > 0 {
                recurrentTimeLabel.text = NSLocalizedString("recurrent.every", comment: "") + String(entry.months) + NSLocalizedString("recurrent.month", comment: "")
                if entry.months > 1 {
                    recurrentTimeLabel.text?.append(NSLocalizedString("recurrent.plural", comment: ""))
                }
                if entry.days > 0 {
                    recurrentTimeLabel.text?.append(NSLocalizedString("recurrent.and", comment: "") + String(entry.days) + NSLocalizedString("recurrent.day", comment: ""))
                    if entry.days > 1 {
                        recurrentTimeLabel.text?.append(NSLocalizedString("recurrent.plural", comment: ""))
                    }
                }
            } else {
                recurrentTimeLabel.text = NSLocalizedString("recurrent.every", comment: "") + String(entry.days) + NSLocalizedString("recurrent.day", comment: "")
                if entry.days > 1 {
                    recurrentTimeLabel.text?.append(NSLocalizedString("recurrent.plural", comment: ""))
                }
            }
        }
            
        recurrentTimeLabel.textAlignment = .center
        recurrentTimeLabel.font = UIFont(name: "Avenir-Light", size: recurrentTimeLabel.frame.height/2)
        recurrentTimeLabel.textColor = UIColor(hex: "0D3530")
        recurrentTimeLabel.adjustsFontSizeToFitWidth = true
        
    }

}
