//
//  CustomSegmentedControl.swift
//  Financer
//
//  Created by Valentin Witzeneder on 28.02.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import Foundation
import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    private var container: UIPageViewController
    
    init(container: UIPageViewController) {
        self.container = container
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        container.view.isUserInteractionEnabled = false
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            self.container.view.isUserInteractionEnabled = true
        }
        
    }
    
    
}
