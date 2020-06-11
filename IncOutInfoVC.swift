//
//  IncOutInfoVC.swift
//  Financer
//
//  Created by Valentin Witzeneder on 27.02.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit

class IncOutInfoVC: UIViewController {
    
    private var infoLabel: UILabel!
    private let isIncome: Bool!
    private var numberOfEntriesLabel: UILabel!
    private var numberOfEntries: UILabel!
    
    private var mostFrequentLabel: UILabel!
    private var mostFrequent: UILabel!
    
    init(isIncome: Bool) {
        infoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        numberOfEntriesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        numberOfEntries = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        mostFrequentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        mostFrequent = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.isIncome = isIncome
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.view.backgroundColor = .clear
        var constraints: [NSLayoutConstraint] = []
        
        //<---------- INFO LABEL ---------->
        
        if isIncome {
            infoLabel.text = NSLocalizedString("incomes.name", comment: "").uppercased()
        } else {
            infoLabel.text = NSLocalizedString("outcomes.name", comment: "").uppercased()
        }
        
        infoLabel.textColor = UIColor(hex: "#DCDFE0")
        infoLabel.textAlignment = .center
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 0.9, constant:0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.5, constant: 0))
        
        self.view.addSubview(infoLabel)
        
        //<---------- NUMBER OF ENTRIES LABEL ---------->
        numberOfEntriesLabel.numberOfLines = 0
        numberOfEntriesLabel.text = NSLocalizedString("info.NumberOfEntriesMonth", comment: "")
        numberOfEntriesLabel.textColor = UIColor(hex: "#DCDFE0")
        numberOfEntriesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(NSLayoutConstraint(item: numberOfEntriesLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: self.view.frame.width/20))
        constraints.append(NSLayoutConstraint(item: numberOfEntriesLabel, attribute: .top, relatedBy: .equal, toItem: infoLabel, attribute: .bottom, multiplier: 0.9, constant:0))
        constraints.append(NSLayoutConstraint(item: numberOfEntriesLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0))
        constraints.append(NSLayoutConstraint(item: numberOfEntriesLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.65, constant: 0))
        
        self.view.addSubview(numberOfEntriesLabel)
        
        //<---------- NUMBER OF ENTRIES ---------->
        numberOfEntries.numberOfLines = 0
        numberOfEntries.text = "0"
        numberOfEntries.textColor = UIColor(hex: "#DCDFE0")
        numberOfEntries.textAlignment = .right
        numberOfEntries.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(NSLayoutConstraint(item: numberOfEntries, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -self.view.frame.width/20))
        constraints.append(NSLayoutConstraint(item: numberOfEntries, attribute: .top, relatedBy: .equal, toItem: infoLabel, attribute: .bottom, multiplier: 0.9, constant:0))
        constraints.append(NSLayoutConstraint(item: numberOfEntries, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0))
        constraints.append(NSLayoutConstraint(item: numberOfEntries, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.35, constant: 0))
        
        self.view.addSubview(numberOfEntries)
        
        //<---------- MOST FREQUENT LABEL ---------->
        mostFrequentLabel.numberOfLines = 0
        mostFrequentLabel.text = NSLocalizedString("info.HighestLabel", comment: "")
        mostFrequentLabel.textColor = UIColor(hex: "#DCDFE0")
        mostFrequentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(NSLayoutConstraint(item: mostFrequentLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: self.view.frame.width/20))
        constraints.append(NSLayoutConstraint(item: mostFrequentLabel, attribute: .top, relatedBy: .equal, toItem: numberOfEntriesLabel, attribute: .bottom, multiplier: 0.9, constant:0))
        constraints.append(NSLayoutConstraint(item: mostFrequentLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0))
        constraints.append(NSLayoutConstraint(item: mostFrequentLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.65, constant: 0))
        
        self.view.addSubview(mostFrequentLabel)
        
        //<---------- MOST FREQUENT ---------->
        mostFrequent.numberOfLines = 0
        mostFrequent.text = "-"
        mostFrequent.textColor = UIColor(hex: "#DCDFE0")
        mostFrequent.textAlignment = .right
        mostFrequent.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(NSLayoutConstraint(item: mostFrequent, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -self.view.frame.width/20))
        constraints.append(NSLayoutConstraint(item: mostFrequent, attribute: .top, relatedBy: .equal, toItem: numberOfEntriesLabel, attribute: .bottom, multiplier: 0.9, constant:0))
        constraints.append(NSLayoutConstraint(item: mostFrequent, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0))
        constraints.append(NSLayoutConstraint(item: mostFrequent, attribute: .left, relatedBy: .equal, toItem: mostFrequentLabel, attribute: .right, multiplier: 1, constant: 0))
        
        self.view.addSubview(mostFrequent)
        
        
        
        self.view.addConstraints(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        infoLabel.font = UIFont.init(name: "Avenir-Heavy", size: 200)
        infoLabel.numberOfLines = 0
        infoLabel.adjustsFontSizeToFitWidth = true
        
        numberOfEntriesLabel.font = UIFont.init(name: "Avenir-Book", size: 200)
        numberOfEntriesLabel.numberOfLines = 0
        numberOfEntriesLabel.adjustsFontSizeToFitWidth = true
        
        numberOfEntries.font = UIFont.init(name: "Avenir-Heavy", size: 200)
        numberOfEntries.numberOfLines = 0
        numberOfEntries.adjustsFontSizeToFitWidth = true
        
        mostFrequentLabel.font = UIFont.init(name: "Avenir-Book", size: 200)
        mostFrequentLabel.numberOfLines = 0
        mostFrequentLabel.adjustsFontSizeToFitWidth = true
        
        mostFrequent.font = UIFont.init(name: "Avenir-Heavy", size: 200)
        mostFrequent.numberOfLines = 0
        mostFrequent.adjustsFontSizeToFitWidth = true
                
    }
    
    func setLabelsNew(numberOfEntries: Int, mostLabel: String) {
        self.numberOfEntries.numberOfLines = 0
        self.numberOfEntries.text = String(numberOfEntries)
        self.numberOfEntries.adjustsFontSizeToFitWidth = true
        
        self.mostFrequent.numberOfLines = 0
        self.mostFrequent.text = mostLabel
        self.mostFrequent.adjustsFontSizeToFitWidth = true
    }
    
}
