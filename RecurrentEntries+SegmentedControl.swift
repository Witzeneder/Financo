//
//  RecurrentEntries+SegmentedControl.swift
//  Financer
//
//  Created by Valentin Witzeneder on 01.05.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import Foundation
import UIKit

extension RecurrentEntries {
    
    internal func setupSegmentedControl() {
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = .clear
        } else {
            // Under iOS 13 no need to do sth
        }
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: segmentedControl.frame.height/2) ?? UIFont.boldSystemFont(ofSize: segmentedControl.frame.height/2),
            NSAttributedString.Key.foregroundColor: UIColor(hex: "#DCDFE0", opacity: 1.0)
            ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: segmentedControl.frame.height/2) ?? UIFont.boldSystemFont(ofSize: segmentedControl.frame.height/2),
            NSAttributedString.Key.foregroundColor: UIColor(hex: "#DCDFE0", opacity: 1.0)
            ], for: .selected)
    }
    
    @objc internal func changeCollectionView(_ sender : UISegmentedControl) {
        reloadCollectionView()
        animateSegmentedControl()
    }
    
    
    internal func reloadCollectionView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            recurrentEntries = realmManager.getRecurrentEntries(isIncome: true)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            recurrentEntries = realmManager.getRecurrentEntries(isIncome: false)
        }
        collectionView.reloadData()
    }
    
    internal func animateSegmentedControl() {
        var centerXPoint:CGFloat!
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            centerXPoint = self.view.center.x - segmentedControl.frame.width/4
        case 1:
            centerXPoint = self.view.center.x + segmentedControl.frame.width/4
        default:
            // can't happen
            return
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.buttonBar.center.x = centerXPoint
            self.buttonBar.transform = CGAffineTransform(scaleX: 0.5, y: 1)
        }) { (continue) in
            UIView.animate(withDuration: 0.25, animations: {
                self.buttonBar.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            })
        }
    }
}
