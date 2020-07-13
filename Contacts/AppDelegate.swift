//
//  AppDelegate.swift
//  Contacts
//
//  Created by Madi Kabdrash on 7/2/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController()
        let navController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }


}

