//
//  MyCustomButton.swift
//  Financer
//
//  Created by Valentin Witzeneder on 12.11.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import Foundation
import PopupDialog

public final class MyCustomButton: PopupDialogButton {

    override public func setupView() {
        defaultTitleFont        = UIFont.boldSystemFont(ofSize: 16)
        defaultTitleColor       = .black
        super.setupView()
    }
}
