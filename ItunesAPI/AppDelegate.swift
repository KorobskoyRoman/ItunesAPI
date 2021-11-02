//
//  AppDelegate.swift
//  ItunesAPI
//
//  Created by Roman Korobskoy on 01.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AuthViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    

}

