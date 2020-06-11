//
//  AppDelegate.swift
//  Financer
//
//  Created by Valentin Witzeneder on 24.08.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

let myRealm = try! Realm()
let realmManager = RealmManager()
var isX = true
var currency = "$"
let monthsString = [NSLocalizedString("month.1", comment: ""),NSLocalizedString("month.2", comment: ""),NSLocalizedString("month.3", comment: ""),NSLocalizedString("month.4", comment: ""),NSLocalizedString("month.5", comment: ""),NSLocalizedString("month.6", comment: ""),NSLocalizedString("month.7", comment: ""),NSLocalizedString("month.8", comment: ""),NSLocalizedString("month.9", comment: ""),NSLocalizedString("month.10", comment: ""),NSLocalizedString("month.11", comment: ""),NSLocalizedString("month.12", comment: "")]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        print(myRealm.configuration.fileURL!)
        
        //ADS
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            // iPhone 5 or 5S or 5C
            isX = false
        case 1334:
            // iPhone 6/6S/7/8
            isX = false
        case 1920, 2208:
            // iPhone 6+/6S+/7+/8+
            isX = false
        default:
            print("iPhone X")
        }

        window?.rootViewController = MainMenuTabBar()
        if UserDefaults.standard.string(forKey: "FirstStart") != nil {
        
            UserDefaults.standard.register(defaults: [String: Any]())
            let userDefaults = UserDefaults.standard
            
            if let savedCurrency = UserDefaults.standard.string(forKey: "Currency") {
                currency = savedCurrency
            }
            
            if let currencyLoc = userDefaults.string(forKey: "user_currency") {
                
                if currencyLoc == "$" || currencyLoc == "€" || currencyLoc == "£" {
                    userDefaults.set(currencyLoc, forKey: "Currency")
                    currency = currencyLoc
                    userDefaults.set(currency, forKey: "Currency")
                }
            }
            
            //check for recurrent Entries to be updated and goals
            realmManager.checkAndSaveRecurrentEntries()
            realmManager.checkAllGoals()
            
            window?.rootViewController = MainMenuTabBar()
            
        
        } else {
            window?.rootViewController = PageViewControllerInfo(isInitial: true)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

