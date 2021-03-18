//
//  AppDelegate.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import UIKit
import IQKeyboardManagerSwift
import CYLTabBarController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setKeybord()
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        let customeTBC = INSTabBarController.initTabBarController()
        window?.rootViewController = customeTBC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func setKeybord()
    {
        let manager = IQKeyboardManager.shared
        manager.enable = true
        manager.enableAutoToolbar = true
        manager.shouldResignOnTouchOutside = true
        manager.toolbarManageBehaviour = .byPosition
    }
}
