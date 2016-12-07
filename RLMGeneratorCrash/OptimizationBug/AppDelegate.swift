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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        WeNeedSomeCToMakeAsanLinkingHappy()

        let h = Helper()
        print(h.allItems)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

