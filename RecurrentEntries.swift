//
//  RecurrentEntries.swift
//  Financer
//
//  Created by Valentin Witzeneder on 27.09.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit
import PopupDialog
import Lottie

class RecurrentEntries: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
    internal let cellID = "entryCell"
    internal var recurrentEntries: [RecurrentEntry] = []
    internal var collectionView: UICollectionView!
    private var indexOfDeletion: Int?
    internal var segmentedControl: UISegmentedControl!
    
    internal lazy var realmManager: RealmManager = {
        return RealmManager()
    }()
    
    internal lazy var buttonBar: UIView = {
        return UIView()
    }()
    
    init(isIncome: Bool) {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recurrentEntries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! EntryCellCV
        cell.setupLabels(recurrentEntry: recurrentEntries[indexPath.row])
        cell.layer.borderWidth = 2.5
        cell.layer.borderColor = UIColor(hex: "#0D3530").cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 5
        cell.backgroundColor = UIColor(hex: "9EBFC0")
        cell.amountLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height / 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recurrentEntry = recurrentEntries[indexPath.row]
        
        let myVC = RecurrentPopoverVC(entry: recurrentEntry)
        
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
        
        // Create buttons
        let buttonOne = DestructiveButton(title: NSLocalizedString("buttons.delete", comment: ""), dismissOnTap: false) {
            let alert = UIAlertController(title: NSLocalizedString("buttons.warning", comment: ""), message: NSLocalizedString("recurrent.deleteWarning", comment: ""), preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("buttons.yes", comment: ""), style: UIAlertAction.Style.destructive , handler: { action in
                try! myRealm.write {
                    for entry in recurrentEntry.entries {
                        myRealm.delete(entry)
                    }
                    myRealm.delete(recurrentEntry)
                }
                self.recurrentEntries.remove(at: indexPath.row)
                collectionView.reloadData()
                popover.dismiss()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("buttons.cancel", comment: ""), style: UIAlertAction.Style.default , handler: nil))
            alert.view.tintColor = UIColor(hex: "#0D3530")
            myVC.present(alert, animated: true, completion: nil)
        }

        // This button will not the dismiss the dialog
        let buttonTwo = DestructiveButton(title: NSLocalizedString("recurrent.stopRecurring", comment: ""), dismissOnTap: false) {
            try! myRealm.write {
                myRealm.delete(recurrentEntry)
            }
            self.recurrentEntries.remove(at: indexPath.row)
            collectionView.reloadData()
            popover.dismiss()
        }

        let buttonThree = MyCustomButton(title: NSLocalizedString("buttons.cancel", comment: ""), action: nil)
        popover.addButtons([buttonTwo, buttonOne, buttonThree])
        
        // Present dialog
        self.present(popover, animated: true, completion: nil)
    }
}
