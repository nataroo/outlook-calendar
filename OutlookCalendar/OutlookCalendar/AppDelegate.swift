//
//  AppDelegate.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 3/31/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Capture the main screen and set navigationController as the rootViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = MainViewController() as UIViewController
        // navigationController's first screen would be mainViewController
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.accessibilityIdentifier = "Navigation-Bar"
        let barAppearance = UINavigationBar.appearance()
        barAppearance.barTintColor = UIColor.white
        barAppearance.tintColor = UIColor.black
        barAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        CoreDataStack.sharedInstance.applicationDocumentsDirectory()
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
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataStack.sharedInstance.saveContext()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

