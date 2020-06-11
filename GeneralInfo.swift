//
//  GeneralInfo.swift
//  Financer
//
//  Created by Valentin Witzeneder on 09.10.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Lottie

class GeneralInfo: UIViewController {

    var infoLabel: UILabel!
    var animationView: AnimationView!
    var isInital: Bool!
    
    init(isInitial: Bool) {
        self.isInital = isInitial
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationView.animationSpeed = 0.65
        animationView.play()
    }
    
    private func setupUI() {
        var constraints: [NSLayoutConstraint] = []
        self.view.setGradientBackgroundMiddle(colorOne: .white, colorTwo: UIColor.init(hex: "#0D3530"))
        // <---------- INFO LABEL ---------->
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(infoLabel)
        infoLabel.numberOfLines = 0
        infoLabel.text = NSLocalizedString("start.letsStart", comment: "")
        if isInital {
            infoLabel.text?.append(NSLocalizedString("start.Dino", comment: ""))
        }
        infoLabel.textColor = .white
        infoLabel.textAlignment = .center
        
        
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.frame.height / 8))

        
        // <---------- ANIMATION VIEW ---------->
        animationView = AnimationView(name: "wal")
        animationView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        self.view.addSubview(animationView)
        
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.25, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.7, constant: 0))
        
        // <---------- BUTTON FOR FIRST START ---------->
        if isInital {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(start), for: .touchUpInside)
            self.view.addSubview(button)
            
            constraints.append(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
            constraints.append(NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.25, constant: 0))
            constraints.append(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
            constraints.append(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.7, constant: 0))
        }
        
        self.view.addConstraints(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        infoLabel.font = UIFont(name:"Avenir-Light", size: 50.0)
        infoLabel.adjustsFontSizeToFitWidth = true
    }
    
    @objc private func start() {
        UserDefaults.standard.set("YES", forKey: "FirstStart")
        //INFO: FIRST LABEL ENTRIES
        let labels: [String] = ["UNLABELED",NSLocalizedString("label.Salary", comment: ""),NSLocalizedString("label.Groceries", comment: ""),NSLocalizedString("label.Housing", comment: "")]
        UserDefaults.standard.set(labels, forKey: "labels")
        
        let vc = MainMenuTabBar()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
