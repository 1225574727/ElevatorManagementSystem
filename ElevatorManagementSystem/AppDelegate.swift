//
//  AppDelegate.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/9/6.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	
        self.window?.rootViewController = UINavigationController(rootViewController: EMMainViewController())
        self.window?.makeKeyAndVisible()
        
		// language setting
		object_setClass(Foundation.Bundle.main, EMBundle.self)
        return true
    }

}

