//
//  AppDelegate.swift
//  OptimizationBug
//
//  Created by Anders Hasselqvist on 6/14/16.
//

import UIKit

class Helper {
    var allItems: [CombinedInfo] {
        return DB.sharedInstance.allItems!
    }

    init() {
        for i in self.allItems {
            print("\(i.titleName)")
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        WeNeedSomeCToMakeAsanLinkingHappy()

        let h = Helper()
        print(h.allItems)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

