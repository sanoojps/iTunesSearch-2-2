//
//  AppDelegate.swift
//  iTunesSearch
//
//  Created by Maddiee on 18/08/18.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        self.createAndConfigureSplitView(window: self.window, delgate: self)
        
        self.applyNavigationbarPreferences()

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

//MARK: - SplitView Controller
extension AppDelegate
{
    ///
    /// create And Configure A SplitView Controller
    ///
    @discardableResult
    fileprivate func createAndConfigureSplitView(window:UIWindow?,delgate:UISplitViewControllerDelegate) -> UISplitViewController?{
        // Override point for customization after application launch.
        
        // get the splitViewController
        let splitViewController = (window?.rootViewController) as? UISplitViewController
        
        // sanity check
        guard let viewControllersCount = splitViewController?.viewControllers.count else {
            return nil
        }
        guard viewControllersCount > 0 else {
            return nil
        }
        
        // get the navigationController
        let navigationController =
            (splitViewController?.viewControllers[viewControllersCount - 1]) as? UINavigationController
        
        // get the master view Controller
        navigationController?.topViewController?.navigationItem.leftBarButtonItem =
            splitViewController?.displayModeButtonItem
        
        // assign delegate
        splitViewController?.delegate = delgate
        
        return splitViewController
    }
    
    // MARK: - Split view
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
   
        // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
       
        return true
    }

}

//MARK: - NavigationbarPreferences
extension AppDelegate
{
    fileprivate func applyNavigationbarPreferences() {
        // set navigation bar appearance preferencres
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white], for: UIControlState.normal)
        
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).tintColor =
            UIColor.white
    }
}
