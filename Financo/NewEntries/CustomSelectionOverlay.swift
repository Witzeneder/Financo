//
//  CustomSelectionOverlay.swift
//  Financer
//
//  Created by Valentin Witzeneder on 24.09.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit

/// Overlay for selecting the time period for reacurring entries

class CustomSelectionOverlay: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var recurrentPicker: UIPickerView!
    
    init(frameRect: CGRect) {
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
        
        // <---------- PICKER VIEW ---------->
        var constraints: [NSLayoutConstraint] = []
        recurrentPicker = UIPickerView()
        recurrentPicker.dataSource = self
        recurrentPicker.delegate = self
        recurrentPicker.backgroundColor = UIColor.init(hex: "#216260")
        recurrentPicker.setValue(UIColor.init(hex: "#FFFFFF"), forKeyPath: "textColor")
        recurrentPicker.layer.cornerRadius = 10
        recurrentPicker.translatesAutoresizingMaskIntoConstraints = false
        
        recurrentPicker.center = blurEffectView.center
        
        constraints.append(NSLayoutConstraint(item: recurrentPicker, attribute: .centerX, relatedBy: .equal,
                                              toItem: self, attribute: .centerX,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: recurrentPicker, attribute: .centerY, relatedBy: .equal,
                                              toItem: self, attribute: .centerY,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: recurrentPicker, attribute: .height, relatedBy: .equal,
                                              toItem: self, attribute: .height,
                                              multiplier: 0.3, constant: 0))
        constraints.append(NSLayoutConstraint(item: recurrentPicker, attribute: .width, relatedBy: .equal,
                                              toItem: self, attribute: .width,
                                              multiplier: 0.9, constant: 0))
        self.addSubview(recurrentPicker)
        NSLayoutConstraint.activate(constraints)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return 32
        } else {
            return 13
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            switch row {
            case 0:
                return NSLocalizedString("picker.days", comment: "")
            default:
                return String(row)
            }
        } else {
            switch row {
            case 0:
                return NSLocalizedString("picker.months", comment: "")
            default:
                return String(row)
            }
        }
    }
    
}
