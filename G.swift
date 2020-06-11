//
//  GoalsView.swift
//  Financer
//
//  Created by Valentin Witzeneder on 28.09.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit

class GoalsView: UIViewController {

    init(id: Int) {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Goals"
        self.view.backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
