//
//  RecurrentEntries+UI.swift
//  Financer
//
//  Created by Valentin Witzeneder on 01.05.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import Foundation
import UIKit

extension RecurrentEntries {
    
    internal func setupUI() {
        self.edgesForExtendedLayout = []
        var constraints: [NSLayoutConstraint] = []
        
        self.view.setGradientBackgroundMiddle(colorOne: UIColor(hex: "#DCDFE0"), colorTwo: UIColor(hex: "0D3530"))
        
        // <---------- TOP CONTAINER ---------->
        let topContainer = UIView()
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topContainer)
        if !isX {
            constraints.append(NSLayoutConstraint(item: topContainer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.frame.height / 30))
        } else {
            constraints.append(NSLayoutConstraint(item: topContainer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.frame.height / 20))
        }
        constraints.append(NSLayoutConstraint(item: topContainer, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: topContainer, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.15, constant: 0))
        
        var topConstraints: [NSLayoutConstraint] = []
        
        // <---------- SEGMENTED CONTROLL ---------->
        let segmentItems = [NSLocalizedString("incomes.name", comment: ""), NSLocalizedString("outcomes.name", comment: "")]
        segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(segmentedControl)
        
        topConstraints.append(NSLayoutConstraint(item: segmentedControl, attribute: .centerY, relatedBy: .equal, toItem: topContainer, attribute: .centerY, multiplier: 1, constant: 0))
        topConstraints.append(NSLayoutConstraint(item: segmentedControl, attribute: .centerX, relatedBy: .equal, toItem: topContainer, attribute: .centerX, multiplier: 1, constant: 0))
        topConstraints.append(NSLayoutConstraint(item: segmentedControl, attribute: .width, relatedBy: .equal, toItem: topContainer, attribute: .width, multiplier: 0.8, constant: 0))
        if !isX {
            topConstraints.append(NSLayoutConstraint(item: segmentedControl, attribute: .height, relatedBy: .equal, toItem: topContainer, attribute: .height, multiplier: 0.5, constant: 0))
        } else {
            topConstraints.append(NSLayoutConstraint(item: segmentedControl, attribute: .height, relatedBy: .equal, toItem: topContainer, attribute: .height, multiplier: 0.4, constant: 0))
        }
            
        segmentedControl.addTarget(self, action: #selector(changeCollectionView(_:)), for: .valueChanged)
        
        
        segmentedControl.layer.masksToBounds = true
        segmentedControl.selectedSegmentIndex = 0
        
        //<-------- BUTTON BAR -------->
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor(hex: "#DCDFE0", opacity: 1.0)
        
        topContainer.addSubview(buttonBar)
        topConstraints.append(NSLayoutConstraint(item: buttonBar, attribute: .top, relatedBy: .equal, toItem: segmentedControl, attribute: .bottom, multiplier: 0.95, constant: 0))
        topConstraints.append(NSLayoutConstraint(item: buttonBar, attribute: .height, relatedBy: .equal, toItem: segmentedControl, attribute: .height, multiplier: 0.075, constant: 0))
        topConstraints.append(NSLayoutConstraint(item: buttonBar, attribute: .width, relatedBy: .equal, toItem: segmentedControl, attribute: .width, multiplier: 0, constant: (self.view.frame.width*0.8)/2.25))
        topConstraints.append(NSLayoutConstraint(item: buttonBar, attribute: .centerX, relatedBy: .equal, toItem: segmentedControl, attribute: .centerX, multiplier: 1, constant: -(self.view.frame.width*0.8)/4))
        
        
        topContainer.addConstraints(topConstraints)
        
        
        // <---------- COLLECTION VIEW ---------->
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.125)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        constraints.append(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal,
                                              toItem: topContainer, attribute: .bottom,
                                              multiplier: 1, constant: self.view.frame.height / 30))
        constraints.append(NSLayoutConstraint(item: collectionView, attribute: .centerX, relatedBy: .equal,
                                              toItem: self.view, attribute: .centerX,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: collectionView, attribute: .width, relatedBy: .equal,
                                              toItem: self.view, attribute: .width,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal,
                                              toItem: self.view, attribute: .bottom,
                                              multiplier: 1, constant: 0))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EntryCellCV.self, forCellWithReuseIdentifier: cellID)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        setupSegmentedControl()
    }
    
    
}
