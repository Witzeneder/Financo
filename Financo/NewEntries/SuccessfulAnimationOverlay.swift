//
//  SuccessfulAnimationOverlay.swift
//  Financer
//
//  Created by Valentin Witzeneder on 28.09.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Lottie

class SuccessfulAnimationOverlay: UIView {

    let animationView: AnimationView!
    
    init(frameRect: CGRect) {
        self.animationView = AnimationView(name: "checkAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        super.init(frame: frameRect)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // <---------- BLURR EFFECT ---------->
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        // <---------- ANIMATION VIEW ---------->
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        self.addSubview(animationView)
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal,
                                              toItem: self, attribute: .width,
                                              multiplier: 0.8, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal,
                                              toItem: self, attribute: .width,
                                              multiplier: 0.8, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal,
                                              toItem: self, attribute: .centerX,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal,
                                              toItem: self, attribute: .centerY,
                                              multiplier: 1, constant: 0))

        NSLayoutConstraint.activate(constraints)
    }

    func startAnimation(completion: @escaping (Bool) -> Void) {
        animationView.play { (success:Bool) in
            sleep(1)
            completion(success)
        }
    }

}
