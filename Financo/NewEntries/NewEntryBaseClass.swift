//
//  NewEntryBaseClass.swift
//  Financer
//
//  Created by Valentin Witzeneder on 25.08.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit
import PopupDialog
import RealmSwift
import GoogleMobileAds

class NewEntryBaseClass: UIViewController, UITextFieldDelegate, UITextViewDelegate, GADInterstitialDelegate {
    
    private var tabID: Int!
    private lazy var amountTextField: UITextField = {
       return UITextField()
    }()
    private lazy var useTextView: UITextView = {
        return UITextView()
    }()
    private lazy var datePickerView: UIView = {
        return UIView()
    }()
    private lazy var datePicker: UIDatePicker = {
        return UIDatePicker()
    }()
    private lazy var labelButton: UIButton = {
        return UIButton()
    }()
    private lazy var newLabelTextfield: UITextField = {
        return UITextField()
    }()
    
    private lazy var interstitialAD: GADInterstitial = {
        //TODO: Change to newEntryAD ID
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-2891745232433162/5321233032")
        interstitial.delegate = self
        return interstitial
    }()
    
    private var overlay: CustomSelectionOverlay?
    private var isCustomEntry = false
    private var customEntry: Entry?
    private var customRecurrentEntry: RecurrentEntry?
    
    init(tabID: Int, title: String) {
        super.init(nibName: nil, bundle: nil)
        self.tabID = tabID
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(goBack(sender:)))
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(addEntry(sender:)))
        self.navigationItem.leftBarButtonItem = doneItem;
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hex: "#0D3530")
        self.navigationItem.rightBarButtonItem = addItem;
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "#0D3530")
        self.navigationItem.title = title
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
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
    
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
         // Constraints for the UI Elements which is added to the view
         var constraints: [NSLayoutConstraint] = []
        
        // This ensures that view is below the navigation bar
        self.edgesForExtendedLayout = []
        
       
        // <---------- AMOUNT TEXTVIEW ---------->
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.delegate = self
        amountTextField.text = currency
        amountTextField.textColor = .lightGray
        amountTextField.layer.cornerRadius = 10
        amountTextField.layer.borderColor = UIColor.init(hex: "#216260").cgColor
        amountTextField.layer.borderWidth = 5
        amountTextField.backgroundColor = .white
        amountTextField.keyboardType = UIKeyboardType.decimalPad
        amountTextField.textAlignment = .center
        self.view.addSubview(amountTextField)
        
        
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .top, relatedBy: .equal,
                                              toItem: self.view, attribute: .top,
                                              multiplier: 1, constant: self.view.frame.height / 18))
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .centerX, relatedBy: .equal,
                                              toItem: self.view, attribute: .centerX,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .width, relatedBy: .equal,
                                              toItem: self.view, attribute: .width,
                                              multiplier: 0.85, constant: 0))
        
        
        if isX {
            constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .height, relatedBy: .equal,
                                                  toItem: self.view, attribute: .height,
                                                  multiplier: 0.1, constant: 0.0))
        } else {
            constraints.append(NSLayoutConstraint(item: amountTextField, attribute: .height, relatedBy: .equal,
                                                  toItem: self.view, attribute: .height,
                                                  multiplier: 0.12, constant: 0.0))
        }
        
        
        
        // <---------- USE TEXTVIEW ---------->
        useTextView.translatesAutoresizingMaskIntoConstraints = false
        useTextView.delegate = self
        useTextView.textAlignment = .center
        useTextView.text = "Use ..."
        useTextView.textColor = .lightGray
        useTextView.layer.borderColor = UIColor.init(hex: "#216260").cgColor
        useTextView.layer.borderWidth = 5
        useTextView.layer.cornerRadius = 10
        self.view.addSubview(useTextView)
        
        
        
        if isX {
            constraints.append(NSLayoutConstraint(item: useTextView, attribute: .top, relatedBy: .equal,
                                                  toItem: amountTextField, attribute: .bottom,
                                                  multiplier: 1, constant: self.view.frame.height / 16))
        } else {
            constraints.append(NSLayoutConstraint(item: useTextView, attribute: .top, relatedBy: .equal,
                                                  toItem: amountTextField, attribute: .bottom,
                                                  multiplier: 1, constant: self.view.frame.height / 20))
        }
        
        
        constraints.append(NSLayoutConstraint(item: useTextView, attribute: .centerX, relatedBy: .equal,
                                              toItem: self.view, attribute: .centerX,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: useTextView, attribute: .width, relatedBy: .equal,
                                              toItem: self.view, attribute: .width,
                                              multiplier: 0.85, constant: 0))
        constraints.append(NSLayoutConstraint(item: useTextView, attribute: .height, relatedBy: .equal,
                                              toItem: self.view, attribute: .height,
                                              multiplier: 0.2, constant: 0.0))
        
        // <---------- LABEL BUTTON ---------->
        labelButton.setTitle("UNLABELED", for: .normal)
        labelButton.titleLabel?.textAlignment = .center
        labelButton.translatesAutoresizingMaskIntoConstraints = false
        labelButton.setTitleColor(UIColor.init(hex: "#216260"), for: .normal)
        labelButton.layer.borderColor = UIColor.init(hex: "#216260").cgColor
        labelButton.layer.borderWidth = 5
        labelButton.layer.cornerRadius = 10
        labelButton.backgroundColor = .white
        labelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: (self.view.frame.height * 0.1) / 4)
        labelButton.addTarget(self, action:#selector(labelButtonTouched(sender:)), for: .touchUpInside)
        self.view.addSubview(labelButton)
        
        constraints.append(NSLayoutConstraint(item: labelButton, attribute: .top, relatedBy: .equal, toItem: useTextView, attribute: .bottom, multiplier: 1, constant: self.view.frame.height / 25))
        constraints.append(NSLayoutConstraint(item: labelButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: labelButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.85, constant: 0))
        
        if isX {
            constraints.append(NSLayoutConstraint(item: labelButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.1, constant: 0))
        } else {
            constraints.append(NSLayoutConstraint(item: labelButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.12, constant: 0))
        }
        
        // <---------- DAY PICKER View---------->
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.backgroundColor = UIColor.init(hex: "#FFFFFF", opacity: 1)
        datePickerView.layer.borderColor = UIColor.init(hex: "#216260").cgColor
        datePickerView.layer.borderWidth = 5
        datePickerView.layer.cornerRadius = 10
        
        self.view.addSubview(datePickerView)
        
        constraints.append(NSLayoutConstraint(item: datePickerView, attribute: .top, relatedBy: .equal,
                                              toItem: labelButton, attribute: .bottom,
                                              multiplier: 1, constant: self.view.frame.height / 13))
        constraints.append(NSLayoutConstraint(item: datePickerView, attribute: .width, relatedBy: .equal,
                                              toItem: self.view, attribute: .width,
                                              multiplier: 0.85, constant: 0))
        constraints.append(NSLayoutConstraint(item: datePickerView, attribute: .centerX, relatedBy: .equal,
                                              toItem: self.view, attribute: .centerX,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: datePickerView, attribute: .bottom, relatedBy: .equal,
                                              toItem: self.view, attribute: .bottom,
                                              multiplier: 1, constant: -self.view.frame.height / 18))
        
        
        self.view.addConstraints(constraints)
        
        // <---------- DAY PICKER ---------->
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.setValue(UIColor.init(hex: "#000000"), forKeyPath: "textColor")
        
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        datePicker.setDate(Date(), animated: false)
        datePicker.datePickerMode = .date
        datePickerView.addSubview(datePicker)
        
        constraints.append(NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal,
                                              toItem: datePickerView, attribute: .top,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: datePicker, attribute: .bottom, relatedBy: .equal,
                                              toItem: datePickerView, attribute: .bottom,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: datePicker, attribute: .width, relatedBy: .equal,
                                              toItem: datePickerView, attribute: .width,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal,
                                              toItem: datePickerView, attribute: .height,
                                              multiplier: 1, constant: 0))
        
    
        self.view.addConstraints(constraints)
    }
    
    
    @objc func goBack(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addEntry(sender: UIBarButtonItem) {
        
        if isCustomEntry {
            saveCustomEntry()
            return
        }
        
        guard let useText = useTextView.text else {
            throwError()
            return
        }
        
        if useTextView.textColor == UIColor.lightGray {
            throwError()
            return
        }
        
        let amountString = amountTextField.text
        guard var amountSplitted = amountString?.split(separator: "."), let amountDollar = amountSplitted.first, var amount = Double(amountDollar) else {
            throwError()
            return
        }
        amountSplitted.remove(at: 0)
        
        if let amountCentsString = amountSplitted.first {
            guard let amountCents = Double(amountCentsString) else {
                throwError()
                return
            }
            amount = amount + (amountCents / 100)
        }
        
        let myEntry = Entry()
        myEntry.amount = amount
        myEntry.useText = useText
        myEntry.date = datePicker.date
        if let label = labelButton.titleLabel?.text {
            myEntry.label = label
        }
    
        switch self.tabID {
            
        case 1:
            //Single entry Income
            myEntry.entryType = EntryType.IncomeSingle.rawValue
            saveEntry(myEntry: myEntry, recurrentEntry: nil)
            
        case 2:
            //Monthly entry Income
            myEntry.entryType = EntryType.IncomeMonthly.rawValue
            makeRecurrentEntryMonthly(entry: myEntry)
            
        case 3:
            //Custom entry Income
            myEntry.entryType = EntryType.IncomeCustom.rawValue
            makeRecurrentEntryCustom(entry: myEntry)
            
        case 4:
            //Single entry Outcome
            myEntry.entryType = EntryType.OutcomeSingle.rawValue
            saveEntry(myEntry: myEntry, recurrentEntry: nil)
            
        case 5:
            //Monthly entry Outcome
            myEntry.entryType = EntryType.OutcomeMonthly.rawValue
            makeRecurrentEntryMonthly(entry: myEntry)
            
        case 6:
            //Custom entry Outcome
            myEntry.entryType = EntryType.OutcomeCustom.rawValue
            makeRecurrentEntryCustom(entry: myEntry)
            
        default:
            throwError()
            return
        }
    }
    
    private func saveEntry(myEntry: Entry, recurrentEntry: RecurrentEntry?) {
        // Save it to myRealm
        try! myRealm.write {
            myRealm.add(myEntry)
            if let recurrent = recurrentEntry {
                recurrent.entries.append(myEntry)
                myRealm.add(recurrent)
            }
        }
        realmManager.checkAllGoals()
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        amountTextField.resignFirstResponder()
        useTextView.resignFirstResponder()
        let successAnimation = SuccessfulAnimationOverlay(frameRect: self.view.bounds)
        self.view.addSubview(successAnimation)
        successAnimation.startAnimation { (animationEnded) in
            if animationEnded {
                
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
                // Go Back
                //TODO: SHOW AD HERE
                
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
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func makeRecurrentEntryMonthly(entry: Entry) {
        let recurrentEntry = RecurrentEntry()
        recurrentEntry.months = 1
        recurrentEntry.lastDate = entry.date
        recurrentEntry.entryType = entry.entryType
        recurrentEntry.amount = entry.amount
        recurrentEntry.use = entry.useText
        recurrentEntry.label = entry.label
        saveEntry(myEntry: entry, recurrentEntry: recurrentEntry)
    }
    
    private func makeRecurrentEntryCustom(entry: Entry) {
        overlay = CustomSelectionOverlay(frameRect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        if let overlay = overlay {
            self.view.addSubview(overlay)
            customEntry = entry
            isCustomEntry = true
        }
    }
    
    private func saveCustomEntry() {
        guard let entry = customEntry else {
            let alert = UIAlertController(title: "", message: NSLocalizedString("newEntry.failedSaving", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel , handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let selectedDay = overlay?.recurrentPicker.selectedRow(inComponent: 0)
        let selectedMonth = overlay?.recurrentPicker.selectedRow(inComponent: 1)
        
        let recurrentEntry = RecurrentEntry()
        
        if let month = selectedMonth {
            recurrentEntry.months = month
        }
        
        if let day = selectedDay {
            recurrentEntry.days = day
        }
        
        if selectedMonth ?? 0 < 1 && selectedDay ?? 0 < 1 {
            let alert = UIAlertController(title: "", message: NSLocalizedString("newEntry.failedEntry", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel , handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            recurrentEntry.lastDate = entry.date
            recurrentEntry.entryType = entry.entryType
            recurrentEntry.use = entry.useText
            recurrentEntry.amount = entry.amount
            recurrentEntry.label = entry.label
            saveEntry(myEntry: entry, recurrentEntry: recurrentEntry)
        }
    }
    
    private func throwError() {
        let alert = UIAlertController(title: NSLocalizedString("newEntry.mistrial", comment: ""), message: NSLocalizedString("newEntry.checkFail", comment: ""), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel , handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
        useTextView.resignFirstResponder()
    }
    
    @objc func labelButtonTouched(sender: UIButton) {
        self.amountTextField.resignFirstResponder()
        self.useTextView.resignFirstResponder()
        var pickerViewItems = UserDefaults.standard.stringArray(forKey: "labels") ?? []
        let myVC = SelectLabelVC(pickerItems: pickerViewItems)
        
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
        let selectButton = DefaultButton(title: NSLocalizedString("newEntry.labelSelect", comment: "")) {
            let selectedLabel = myVC.selectedLabel
            DispatchQueue.main.async {
                self.labelButton.setTitle(selectedLabel, for: .normal)
                self.labelButton.shakeY()
            }
        }
        
        let newLabel = DefaultButton(title: NSLocalizedString("newEntry.newLabel", comment: "")) {
            let alert = UIAlertController(title: NSLocalizedString("newEntry.enterNewLabel", comment: ""), message: NSLocalizedString("newEntry.alphapetical", comment: ""), preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = NSLocalizedString("newEntry.labelPlaceholder", comment: "")
                textField.delegate = self
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                if var label = alert.textFields?.first?.text {
                    label = label.uppercased()
                    var shouldAdd = true
                    for i in pickerViewItems {
                        if i == label {
                            shouldAdd = false
                        }
                    }
                    if label == NSLocalizedString("label.everything", comment: "") {
                        shouldAdd = false
                    }
                    if shouldAdd && label != "" {
                        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
                        if(label.rangeOfCharacter(from: set.inverted) != nil ){
                            DispatchQueue.main.async {
                                self.labelButton.shakeX()
                            }
                        } else {
                            pickerViewItems.append(label)
                            UserDefaults.standard.set(pickerViewItems, forKey: "labels")
                            DispatchQueue.main.async {
                                self.labelButton.setTitle(label, for: .normal)
                                self.labelButton.shakeY()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.labelButton.shakeX()
                        }
                       
                    }
                } else {
                    DispatchQueue.main.async {
                        self.labelButton.shakeX()
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("alert.cancel", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        }
        
        let cancelButton = CancelButton(title: NSLocalizedString("alert.cancel", comment: "")) {}
        
        
        selectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        selectButton.titleColor = UIColor.init(hex: "#216260", opacity: 1)
        newLabel.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        newLabel.titleColor = UIColor.init(hex: "#216260", opacity: 1)
        
        popover.addButtons([selectButton,newLabel,cancelButton])
    
        // Present dialog
        self.present(popover, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == amountTextField {
            guard let text = textField.text else { return true }
            let count = text.count + string.count - range.length
            return count <= 15
        } else if textField == useTextView {
            guard let text = textField.text else { return true }
            let count = text.count + string.count - range.length
            return count <= 50
        } else {
            guard let text = textField.text else { return true }
            let count = text.count + string.count - range.length
            return count <= 10
        }
    }
}
