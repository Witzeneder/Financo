//
//  NewGoalVC.swift
//  Financer
//
//  Created by Valentin Witzeneder on 14.03.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit
import Lottie
import PopupDialog
import GoogleMobileAds

class NewGoalVC: UIViewController, GADInterstitialDelegate {

    let isIncome: Bool!
    let animationView: AnimationView!
    let pickerView: UIPickerView!
    let amountTextField: UITextField!
    let startDayPicker: UIDatePicker!
    let endDayPicker: UIDatePicker!
    let indicatorLabel: UILabel!
    let labelButton: UIButton!
    
    private lazy var interstitialAD: GADInterstitial = {
        //TODO: Change to newGoalAD ID
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-2891745232433162/5321233032")
        interstitial.delegate = self
        return interstitial
    }()

    init(isIncome: Bool) {
        animationView = AnimationView(name: "gears")
        animationView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        amountTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        startDayPicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        endDayPicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        indicatorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.labelButton = UIButton(type: .custom)
        self.isIncome = isIncome
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        //REQUEST AD
        let request = GADRequest()
        interstitialAD.load(request)
    }
    
    @objc func goBack(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addEntry(sender: UIBarButtonItem) {
        
        if !checkAmount() {
          throwError(errorType: NSLocalizedString("goal.invalidAmount", comment: ""))
            return
        }
        
        if !checkDatePickers() {
            throwError(errorType: NSLocalizedString("goal.invalidDate", comment: ""))
            return
        }
        
        guard let amount = amountTextField.text else { return }
        guard let label = labelButton.titleLabel?.text else { return }
        
        let myVC = PopoverOverviewVC(startDate: startDayPicker.date, endDate: endDayPicker.date, amount: amount, indicator: pickerView.selectedRow(inComponent: 0), label: label, isIncome: isIncome, screenHight: self.view.frame.height)
        
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
        
        let startButton = DefaultButton(title: NSLocalizedString("goal.startGoal", comment: "")) {
            let goal = Goal()
            if let amountD = Double(amount) {
                goal.amount = amountD
            } else {
                //TODO??
                return
            }
        
            goal.label = label
            goal.isIncome = self.isIncome
            goal.startDate = myVC.startDate
            goal.endDate = myVC.endDate
            goal.isIncome = self.isIncome
            goal.goalType = GoalType.more.rawValue
            if myVC.indicator == 1 {
                goal.goalType = GoalType.less.rawValue
            }

            goal.isFinished = false
            goal.shouldReacurre = false
            
            self.saveGoal(goal: goal)
            
        }
        let startWithRecButton = CancelButton(title: "Start repeating Plan") {
            let goal = Goal()
            if let amountD = Double(amount) {
                goal.amount = amountD
            } else {
                //TODO??
                return
            }
            
            goal.label = label
            goal.isIncome = self.isIncome
            goal.startDate = myVC.startDate
            goal.endDate = myVC.endDate
            goal.isIncome = self.isIncome
            goal.goalType = GoalType.more.rawValue
            if myVC.indicator == 1 {
                goal.goalType = GoalType.less.rawValue
            }
            
            goal.isFinished = false
            goal.shouldReacurre = true
            
            self.saveGoal(goal: goal)
        }
        
        let cancleButton = CancelButton(title: NSLocalizedString("buttons.cancel", comment: "")) {}
        startButton.setTitleColor(UIColor(hex: "#216260"), for: .normal)
        popover.addButtons([startButton,cancleButton])
        
        // Present dialog
        self.present(popover, animated: true, completion: nil)
    }
    
    private func saveGoal(goal: Goal) {
        
        // Save it to myRealm
        try! myRealm.write {
            myRealm.add(goal)
        }
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        amountTextField.resignFirstResponder()
        let successAnimation = SuccessfulAnimationOverlay(frameRect: self.view.bounds)
        self.view.addSubview(successAnimation)
        successAnimation.startAnimation { (animationEnded) in
            if animationEnded {
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
                // SHOW ADD OR GO BACK
                if self.interstitialAD.isReady {
                    self.interstitialAD.present(fromRootViewController: self)
                    successAnimation.removeFromSuperview()
                }
                    
                else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func labelButtonTouched(sender: UIButton) {
        var pickerViewItems = UserDefaults.standard.stringArray(forKey: "labels") ?? []
        pickerViewItems.append(NSLocalizedString("label.everything", comment: ""))
        let myVC = SelectLabelVC(pickerItems: pickerViewItems)
        
        let randomBool = Bool.random()
        var style = PopupDialogTransitionStyle.bounceUp
        if randomBool {
            style = PopupDialogTransitionStyle.bounceDown
        }
        
        let popover = PopupDialog(viewController: myVC, buttonAlignment: .vertical, transitionStyle: style, preferredWidth: self.view.frame.width*0.95, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false, completion: nil)
        
        // Create buttons
        let selectButton = CancelButton(title: NSLocalizedString("buttons.select", comment: "")) {
            let selectedLabel = myVC.selectedLabel
            DispatchQueue.main.async {
                self.labelButton.setTitle(selectedLabel, for: .normal)
                self.labelButton.shakeY()
            }
        }
        let cancelButton = CancelButton(title: NSLocalizedString("buttons.cancel", comment: "")) {}
        
        selectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        selectButton.titleColor = UIColor.init(hex: "#216260", opacity: 1)
        
        popover.addButtons([selectButton,cancelButton])
        
        // Present dialog
        self.present(popover, animated: true, completion: nil)
    }
    
    private func throwError(errorType: String) {
        let alert = UIAlertController(title: NSLocalizedString("newEntry.mistrial", comment: ""), message: errorType, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel , handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func checkAmount() -> Bool {
        if amountTextField.text != nil && amountTextField.text != "" && amountTextField.textColor != .lightGray {
            return true
        }
        return false
    }
    
    internal func checkDatePickers() -> Bool {
        let calendar = Calendar.current
        
        let startYear = calendar.component(.year, from: startDayPicker.date)
        let startMonth = calendar.component(.month, from: startDayPicker.date)
        let startDay = calendar.component(.day, from: startDayPicker.date)
        
        let endYear = calendar.component(.year, from: endDayPicker.date)
        let endMonth = calendar.component(.month, from: endDayPicker.date)
        let endDay = calendar.component(.day, from: endDayPicker.date)
        
        if endYear < startYear || (endYear == startYear && endMonth < startMonth) || (endYear == startYear && endMonth == startMonth && endDay <= startDay) {
            return false
        }
        return true
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
