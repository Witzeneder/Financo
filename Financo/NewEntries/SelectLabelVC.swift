//
//  SelectLabelVC.swift
//  Financer
//
//  Created by Valentin Witzeneder on 21.02.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit

class SelectLabelVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    private var pickerViewItems: [String] = []
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: "#216260", opacity: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    
    var selectedLabel: String = "UNLABELED"
    
    init(pickerItems: [String]) {
        pickerViewItems = pickerItems
        super.init(nibName: nil, bundle: nil)
        
        var constraints: [NSLayoutConstraint] = []
        var height = 300
        if isX {
            height = 200
        }
        constraints.append(NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat(height)))
    
        self.view.addSubview(backgroundView)
        constraints.append(NSLayoutConstraint(item: backgroundView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: backgroundView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.9, constant: 0))
        constraints.append(NSLayoutConstraint(item: backgroundView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.95, constant: 0))
        
        self.view.addSubview(pickerView)
        constraints.append(NSLayoutConstraint(item: pickerView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: pickerView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: pickerView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.85, constant: 0))
        constraints.append(NSLayoutConstraint(item: pickerView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.9, constant: 0))
        
        self.view.addConstraints(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewItems.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedLabel = pickerViewItems[row]
    }
    
}
