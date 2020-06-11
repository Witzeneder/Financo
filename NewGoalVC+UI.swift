//
//  NewGoalVC+UI.swift
//  Financer
//
//  Created by Valentin Witzeneder on 14.03.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import Foundation
import UIKit
import Lottie

extension NewGoalVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return ">"
        default:
            return "<"
        }
    }
    
    
    internal func setupUI() {
        setupNavigationTabBar()
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = []
        var constraints: [NSLayoutConstraint] = []
        
        // ---------- Animation ----------
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        self.view.addSubview(animationView)
        
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: self.view.frame.height / 100))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0))
        animationView.animationSpeed = 0.5
        animationView.loopMode = .loop
        animationView.play()
        
        
        // ---------- Picker ----------
        pickerView.layer.cornerRadius = 10
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .white
        pickerView.layer.borderWidth = 5
        pickerView.layer.borderColor = UIColor(hex: "#216260").cgColor
        pickerView.dataSource = self
        pickerView.delegate = self
        self.view.addSubview(pickerView)
        
        constraints.append(NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal, toItem: animationView, attribute: .bottom, multiplier: 1, constant: self.view.frame.height / 50))
        constraints.append(NSLayoutConstraint(item: pickerView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: self.view.frame.height / 80))
        constraints.append(NSLayoutConstraint(item: pickerView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.3, constant: 0))
        constraints.append(NSLayoutConstraint(item: pickerView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.1, constant: 0))
        
        // ---------- Label ---------
        amountTextField.layer.cornerRadius = 10
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.backgroundColor = .white
        amountTextField.layer.borderWidth = 5
        amountTextField.layer.borderColor = UIColor(hex: "#216260").cgColor
        amountTextField.textAlignment = .center
        amountTextField.textColor = .lightGray
        amountTextField.text = currency
        amountTextField.delegate = self

        amountTextField.keyboardType = UIKeyboardType.decimalPad
        self.view.addSubview(amountTextField)
        
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .top, relatedBy: .equal, toItem: animationView, attribute: .bottom, multiplier: 1, constant: self.view.frame.height / 50))
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -self.view.frame.height / 80))
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.6, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.1, constant: 0))
        
        // --------- START DAY Picker --------
        startDayPicker.translatesAutoresizingMaskIntoConstraints = false
        startDayPicker.backgroundColor = .white
        startDayPicker.layer.borderWidth = 5
        startDayPicker.layer.borderColor = UIColor(hex: "#216260").cgColor
        startDayPicker.layer.cornerRadius = 10
        startDayPicker.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        startDayPicker.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        startDayPicker.setDate(Date(), animated: false)
        startDayPicker.datePickerMode = .date
        startDayPicker.layer.masksToBounds = true
        self.view.addSubview(startDayPicker)
        
        constraints.append(NSLayoutConstraint(item: startDayPicker, attribute: .top, relatedBy: .equal, toItem: pickerView, attribute: .bottom, multiplier: 1, constant: self.view.frame.height / 30))
        constraints.append(NSLayoutConstraint(item: startDayPicker, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: startDayPicker, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.9, constant: 0))
        constraints.append(NSLayoutConstraint(item: startDayPicker, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0))
        
        // ---------- "Date to Date" Label ----------
        indicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        indicatorLabel.isUserInteractionEnabled = false
        indicatorLabel.backgroundColor = UIColor(hex: "#216260")
        
        self.view.addSubview(indicatorLabel)
        
        constraints.append(NSLayoutConstraint(item: indicatorLabel, attribute: .top, relatedBy: .equal, toItem: startDayPicker, attribute: .bottom, multiplier: 1, constant: self.view.frame.height / 50))
        constraints.append(NSLayoutConstraint(item: indicatorLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: indicatorLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.05, constant: 0))
        constraints.append(NSLayoutConstraint(item: indicatorLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.01, constant: 0))
        
        // --------- START DAY Picker --------
        endDayPicker.translatesAutoresizingMaskIntoConstraints = false
        endDayPicker.backgroundColor = .white
        endDayPicker.layer.borderWidth = 5
        endDayPicker.layer.borderColor = UIColor(hex: "#216260").cgColor
        endDayPicker.layer.cornerRadius = 10
        endDayPicker.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        endDayPicker.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        endDayPicker.setDate(Date(), animated: false)
        endDayPicker.datePickerMode = .date
        endDayPicker.layer.masksToBounds = true
        self.view.addSubview(endDayPicker)
        
        constraints.append(NSLayoutConstraint(item: endDayPicker, attribute: .top, relatedBy: .equal, toItem: indicatorLabel, attribute: .bottom, multiplier: 1, constant: self.view.frame.height / 50))
        constraints.append(NSLayoutConstraint(item: endDayPicker, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: endDayPicker, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.9, constant: 0))
        constraints.append(NSLayoutConstraint(item: endDayPicker, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0))
        
        // <---------- LABEL BUTTON ---------->
        labelButton.setTitle("UNLABELED", for: .normal)
        labelButton.titleLabel?.textAlignment = .center
        labelButton.translatesAutoresizingMaskIntoConstraints = false
        labelButton.layer.borderColor = UIColor.init(hex: "#216260").cgColor
        labelButton.setTitleColor(UIColor.init(hex: "#216260"), for: .normal)
        labelButton.layer.borderWidth = 5
        labelButton.layer.cornerRadius = 10
        labelButton.backgroundColor = .white
        labelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: (self.view.frame.height * 0.1) / 4)
        labelButton.addTarget(self, action:#selector(labelButtonTouched(sender:)), for: .touchUpInside)
        self.view.addSubview(labelButton)
        
        constraints.append(NSLayoutConstraint(item: labelButton, attribute: .top, relatedBy: .equal, toItem: endDayPicker, attribute: .bottom, multiplier: 1, constant: self.view.frame.height / 30))
        constraints.append(NSLayoutConstraint(item: labelButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: labelButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.9, constant: 0))
        constraints.append(NSLayoutConstraint(item: labelButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.1, constant: 0))
        
        self.view.addConstraints(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        if isIncome {
            pickerView.selectRow(0, inComponent: 0, animated: false)
        } else {
            pickerView.selectRow(1, inComponent: 0, animated: false)
        }
        
    }
    
    internal func setupNavigationTabBar() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(goBack(sender:)))
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(addEntry(sender:)))
        self.navigationItem.leftBarButtonItem = doneItem;
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hex: "#0D3530")
        self.navigationItem.rightBarButtonItem = addItem;
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "#0D3530")
        if isIncome {
            self.navigationItem.title = NSLocalizedString("goal.income", comment: "")
        } else {
            self.navigationItem.title = NSLocalizedString("goal.outcome", comment: "")
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == amountTextField {
            guard let text = textField.text else { return true }
            let count = text.count + string.count - range.length
            return count <= 15
        }
        
        return true
    }
    
}
