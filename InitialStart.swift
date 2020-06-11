//
//  InitialStart.swift
//  Financer
//
//  Created by Valentin Witzeneder on 09.10.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Lottie

class InitialStart: UIViewController {

    private var infoLabel: UILabel!
    private var animationView: AnimationView!
    
    init() {
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
        infoLabel.numberOfLines = 2
        infoLabel.backgroundColor = .clear
        
        
        
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0))
        constraints.append(NSLayoutConstraint(item: infoLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.frame.height/10))
        
        
        // <---------- ANIMATION VIEW ---------->
        animationView = AnimationView(name: "wal")
        animationView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.backgroundColor = .clear
        self.view.addSubview(animationView)
        
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .top, relatedBy: .equal, toItem: infoLabel, attribute: .bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.view.addConstraints(constraints)
    }

    override func viewDidLayoutSubviews() {
        infoLabel.text = NSLocalizedString("info.startGreetings", comment: "")
        infoLabel.font = UIFont(name:"Avenir-Light", size: 100)
        infoLabel.textColor = .white
        infoLabel.textAlignment = .center
        infoLabel.adjustsFontSizeToFitWidth = true
    }
    
}
