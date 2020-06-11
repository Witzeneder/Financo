//
//  SettingsFirstStart.swift
//  Financer
//
//  Created by Valentin Witzeneder on 09.10.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit

class SettingsFirstStart: UIViewController {

    private lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.numberOfLines = 4
        infoLabel.text = NSLocalizedString("info.settingsText", comment: "")
        infoLabel.textColor = .white
        infoLabel.textAlignment = .center
        return infoLabel
    }()
    
    private lazy var buttonDollar: UIButton = {
        let buttonDollar = UIButton()
        buttonDollar.layer.borderWidth = 4.0
        buttonDollar.layer.cornerRadius = 10
        buttonDollar.translatesAutoresizingMaskIntoConstraints = false
        buttonDollar.setTitle("Dollar $", for: .normal)
        buttonDollar.addTarget(self, action: #selector(dollarSelected), for: .touchUpInside)
        return buttonDollar
    }()
    
    private lazy var buttonEuro: UIButton = {
        let buttonEuro = UIButton()
        buttonEuro.layer.cornerRadius = 10
        buttonEuro.translatesAutoresizingMaskIntoConstraints = false
        buttonEuro.setTitle("Euro €", for: .normal)
        buttonEuro.addTarget(self, action: #selector(euroSelected), for: .touchUpInside)
        return buttonEuro
    }()
    
    private lazy var buttonPound: UIButton  = {
        let buttonPound = UIButton()
        buttonPound.layer.cornerRadius = 10
        buttonPound.translatesAutoresizingMaskIntoConstraints = false
        buttonPound.setTitle("Pound £", for: .normal)
        buttonPound.addTarget(self, action: #selector(pfundSelected), for: .touchUpInside)
        return buttonPound
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        var constraints: [NSLayoutConstraint] = []
        self.view.setGradientBackgroundMiddle(colorOne: .white, colorTwo: UIColor(hex: "0D3530"))
        // <---------- INFO LABEL ---------->
        self.view.addSubview(infoLabel)
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.85, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.frame.height / 10))
        
        
        // <---------- $ BUTTON VIEW ---------->
        self.view.addSubview(buttonDollar)
        constraints.append(NSLayoutConstraint(item: buttonDollar, attribute: .top, relatedBy: .equal, toItem: infoLabel, attribute: .bottom, multiplier: 1, constant: self.view.frame.width / 10))
        constraints.append(NSLayoutConstraint(item: buttonDollar, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.6, constant: 0))
        constraints.append(NSLayoutConstraint(item: buttonDollar, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.1, constant: 0))
        constraints.append(NSLayoutConstraint(item: buttonDollar, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        
        // <---------- $ BUTTON VIEW ---------->
        self.view.addSubview(buttonEuro)
        constraints.append(NSLayoutConstraint(item: buttonEuro, attribute: .top, relatedBy: .equal, toItem: buttonDollar, attribute: .bottom, multiplier: 1, constant: self.view.frame.width / 10))
        constraints.append(NSLayoutConstraint(item: buttonEuro, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.6, constant: 0))
        constraints.append(NSLayoutConstraint(item: buttonEuro, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.1, constant: 0))
        constraints.append(NSLayoutConstraint(item: buttonEuro, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        
        // <---------- $ BUTTON VIEW ---------->
        self.view.addSubview(buttonPound)
        constraints.append(NSLayoutConstraint(item: buttonPound, attribute: .top, relatedBy: .equal, toItem: buttonEuro, attribute: .bottom, multiplier: 1, constant: self.view.frame.width / 10))
        constraints.append(NSLayoutConstraint(item: buttonPound, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.6, constant: 0))
        constraints.append(NSLayoutConstraint(item: buttonPound, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.1, constant: 0))
        constraints.append(NSLayoutConstraint(item: buttonPound, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
       
        
        self.view.addConstraints(constraints)
    }
    
    @objc private func dollarSelected() {
        UIView.animate(withDuration: 0.3) {
            
            self.buttonDollar.layer.borderWidth = 4.0
            self.buttonEuro.layer.borderWidth = 0.0
            self.buttonPound.layer.borderWidth = 0.0
        }
        
        UserDefaults.standard.set("$", forKey: "Currency")
        currency = "$"
    }

    @objc private func euroSelected() {
        UIView.animate(withDuration: 0.3) {
            self.buttonDollar.layer.borderWidth = 0.0
            self.buttonEuro.layer.borderWidth = 4.0
            self.buttonPound.layer.borderWidth = 0.0
        }
        
        UserDefaults.standard.set("€", forKey: "Currency")
        currency = "€"
    }
    
    @objc private func pfundSelected() {
        UIView.animate(withDuration: 0.3) {
            self.buttonDollar.layer.borderWidth = 0.0
            self.buttonEuro.layer.borderWidth = 0.0
            self.buttonPound.layer.borderWidth = 4.0
        }

        UserDefaults.standard.set("£", forKey: "Currency")
        currency = "£"
    }
    
    override func viewDidLayoutSubviews() {
        infoLabel.font = UIFont(name:"Avenir-Light", size: 50)
        infoLabel.adjustsFontSizeToFitWidth = true
        buttonPound.titleLabel?.font = UIFont(name:"Avenir-Heavy", size: 50)
        buttonPound.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonPound.setTitleColor(UIColor(hex: "#216260"), for: .normal)
        buttonPound.layer.borderColor = UIColor(hex: "#216260").cgColor
        buttonEuro.titleLabel?.font = UIFont(name:"Avenir-Heavy", size: 50.0)
        buttonEuro.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonEuro.setTitleColor(UIColor(hex: "#216260"), for: .normal)
        buttonEuro.layer.borderColor = UIColor(hex: "#216260").cgColor
        buttonDollar.titleLabel?.font = UIFont(name:"Avenir-Heavy", size: 50.0)
        buttonDollar.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonDollar.setTitleColor(UIColor(hex: "#216260"), for: .normal)
        buttonDollar.layer.borderColor = UIColor(hex: "#216260").cgColor
        
    }
    
    
    
}
