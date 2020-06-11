//
//  TestPVC.swift
//  Financer
//
//  Created by Valentin Witzeneder on 27.02.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit

class TestPVC: UIPageViewController, UIGestureRecognizerDelegate {

    private let superView: ChartVC!
    
    init(superView: ChartVC) {
        self.superView = superView
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupGesture()
    }
    
    internal func setupGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        gesture.delegate = self
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        self.view.addGestureRecognizer(gesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleDrag(_ gesture: UIRotationGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            superView.segmentedControl.isUserInteractionEnabled = false
        } else if gesture.state == UIGestureRecognizer.State.ended {
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                self.view.isUserInteractionEnabled = true
                self.superView.segmentedControl.isUserInteractionEnabled = true
            }
        }
    }

}
