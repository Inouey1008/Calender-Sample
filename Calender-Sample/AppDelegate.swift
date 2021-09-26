//
//  AppDelegate.swift
//  Calender-Sample
//
//  Created by Yus Inoue on 2021/09/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = ViewController()
        window!.makeKeyAndVisible()
        return true
    }
}

