//
//  GoalsView.swift
//  Financer
//
//  Created by Valentin Witzeneder on 28.09.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit

class GoalsView: UIViewController {
    
    var isIncome: Bool!
    var segmentedControl: UISegmentedControl!
    var collectionView: UICollectionView!
    var addButton: UIButton!
    var goals: [Goal] = []
    let cellID = "goalsCell"
    
    internal lazy var buttonBar: UIView = {
        return UIView()
    }()

    init(isIncome: Bool) {
        self.isIncome = isIncome
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Goals"
        setupUI()
        reloadCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        realmManager.checkAllGoals()
        reloadCollectionView()
    }
    
    @objc internal func newEntry(sender: UIButton) {
        let newEntry = UINavigationController(rootViewController: NewGoalVC(isIncome: isIncome))
        newEntry.navigationBar.setBackgroundImage(UIColor(hex: "#DCDFE0").image(), for: .any, barMetrics: .default)
        newEntry.modalPresentationStyle = .fullScreen
        self.present(newEntry, animated: true, completion: nil)
    }
    
    internal func reloadCollectionView() {
        goals = realmManager.getGoals(isIncome: isIncome)
        let numberOfEntries = goals.count
        
        for i in 0..<numberOfEntries {
            if goals[i].isFinished {
                goals.append(goals[i])
                goals.remove(at: i)
            }
        }
        
        collectionView.reloadData()
    }
}
