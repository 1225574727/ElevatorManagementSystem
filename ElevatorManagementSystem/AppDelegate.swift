//
//  AppDelegate.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/9/6.
//

import UIKit
import UserNotifications

//后台下载完成后处理闭包
typealias HanderCompletion = () -> Void

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
	var handler:HanderCompletion!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	
//        self.window?.rootViewController = UINavigationController(rootViewController: EMMainViewController())
//        self.window?.makeKeyAndVisible()
        
		// language setting
		object_setClass(Foundation.Bundle.main, EMBundle.self)
		
		// 本地通知
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, erro) in
			if granted {
			}else{
			}
		}
		
        return true
    }
	
	//MARK: - 后台下载上传完成处理
	func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
		
		self.handler = completionHandler
		creatNotificationContent(identifier: identifier)
	}
	
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler(.alert)
	}

	//MARK: - 创建一个通知
	func creatNotificationContent(identifier: String){
		let content = UNMutableNotificationContent()
		content.title = "上传完成通知"
		content.body = "任务\(identifier)完成上传啦"
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
		
		let requestIdentfier = "com.lmf.EMLocalNotification"
		
		let request = UNNotificationRequest(identifier: requestIdentfier, content: content, trigger: trigger)
		
		UNUserNotificationCenter.current().add(request) { (error) in
			if error == nil {
				
			}
		}
		
		
	}
}

