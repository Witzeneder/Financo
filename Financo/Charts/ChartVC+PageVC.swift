//
//  ChartVC+PageVC.swift
//  Financer
//
//  Created by Valentin Witzeneder on 01.05.19.
//  Copyright © 2019 Valentin Witzeneder. All rights reserved.
//

import Foundation
import UIKit

extension ChartVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            guard let vc = viewController as? ChartView else {
                self.segmentedControl.selectedSegmentIndex = 1
                self.pageControl.currentPage = 1
                return self.pages[1]
            }
            
            if let viewControllerIndex = self.pages.index(of: vc) {
                if viewControllerIndex == 0 {
                    return nil
                } else {
                    return self.pages[viewControllerIndex - 1]
                }
            }
            return nil
        }
        else {
            
            guard let vc = viewController as? PieChartCV else {
                self.segmentedControl.selectedSegmentIndex = 0
                self.pageControl.currentPage = 0
                return self.pagesPie[0]
            }
            
            if let viewControllerIndex = self.pagesPie.index(of: vc) {
                if viewControllerIndex == 0 {
                    return nil
                } else {
                    return self.pagesPie[viewControllerIndex - 1]
                }
            }
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            guard let vc = viewController as? ChartView else {
                self.segmentedControl.selectedSegmentIndex = 1
                self.pageControl.currentPage = 1
                return self.pages[1]
            }
            
            if let viewControllerIndex = self.pages.index(of: vc) {
                if viewControllerIndex < self.pages.count - 1 {
                    return self.pages[viewControllerIndex + 1]
                } else {
                    return nil
                }
            }
            return nil
        }
        else {
            
            guard let vc = viewController as? PieChartCV else {
                self.segmentedControl.selectedSegmentIndex = 1
                self.pageControl.currentPage = 0
                return self.pagesPie[0]
            }
            
            if let viewControllerIndex = self.pagesPie.index(of: vc) {
                if viewControllerIndex < self.pagesPie.count - 1 {
                    return self.pagesPie[viewControllerIndex + 1]
                } else {
                    return nil
                }
            }
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if let viewControllers = pageViewController.viewControllers {
                
                guard let vc = viewControllers[0] as? ChartView else { return }
                
                if let viewControllerIndex = self.pages.index(of: vc) {
                    self.pageControl.currentPage = viewControllerIndex
                }
            }
        }
        else {
            if let viewControllers = pageViewController.viewControllers {
                
                guard let vc = viewControllers[0] as? PieChartCV else { return }
                
                if let viewControllerIndex = self.pagesPie.index(of: vc) {
                    self.pageControl.currentPage = viewControllerIndex
                }
            }
        }
    }

}
