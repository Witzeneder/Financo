//
//  GoalsView+CollectionView.swift
//  Financer
//
//  Created by Valentin Witzeneder on 13.03.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog

extension GoalsView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! GoalsCVCell
        cell.setupLabels(goal: goals[indexPath.row])
        cell.amountTextField.adjustsFontSizeToFitWidth = true
        cell.dateTextField.adjustsFontSizeToFitWidth = true
        cell.layer.borderWidth = 2.5
        cell.layer.borderColor = UIColor(hex: "#0D3530").cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 5
        cell.backgroundColor = UIColor(hex: "9EBFC0")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goal = goals[indexPath.row]
        let myVC = GoalPopVC()
        myVC.setupVC(goal: goal)
        
        let randomBool = Bool.random()
        var style = PopupDialogTransitionStyle.bounceUp
        if randomBool {
            style = PopupDialogTransitionStyle.bounceDown
        }
        
        let popover = PopupDialog(viewController: myVC,
                                  buttonAlignment: .vertical,
                                  transitionStyle: style,
                                  tapGestureDismissal: true,
                                  panGestureDismissal: false)
        
        let deleteButton = DestructiveButton(title: NSLocalizedString("buttons.delete", comment: "")) {
            try! myRealm.write {
                myRealm.delete(goal)
                self.goals.remove(at: indexPath.row)
                self.collectionView.reloadData()
            }
        }
        let button = MyCustomButton(title: NSLocalizedString("buttons.cancel", comment: "")) {}
        
        popover.addButtons([deleteButton,button])
        
        // Present dialog
        self.present(popover, animated: true, completion: nil)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goals.count
    }
    
    internal func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GoalsCVCell.self, forCellWithReuseIdentifier: cellID)
    }
}
