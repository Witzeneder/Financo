//
//  PieChartColors.swift
//  Financer
//
//  Created by Valentin Witzeneder on 25.02.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import UIKit

class PieChartColors {
    
    
    init() {}
    
    func getColors(size: Int) -> [UIColor] {
        var colors: [UIColor] = []
        var loops = 0
        
        while loops < size {
            let red = Double(arc4random_uniform(100) + 40)
            let green = Double(arc4random_uniform(50) + 0)
            let blue = Double(arc4random_uniform(100) + 40)
            colors.append(UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1))
            loops += 1
        }
        return colors
    }
    
    
    
}
