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
		
		//
//		var data = Data()
//		data.append(FileManager.default.contents(atPath: Bundle.main.path(forResource: "0", ofType: "tmp")!)!)
//		data.append(FileManager.default.contents(atPath: Bundle.main.path(forResource: "1", ofType: "tmp")!)!)
//		data.append(FileManager.default.contents(atPath: Bundle.main.path(forResource: "2", ofType: "tmp")!)!)
//
//		let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask, true).first
//		let cachePathUrl = URL(fileURLWithPath: cachePath!)
//		try? FileManager.default.createDirectory(at: cachePathUrl, withIntermediateDirectories: true, attributes: nil)
//
//		let url = cachePathUrl.appendingPathComponent("test.mp4")
//		do {
//			try data.write(to: url)
//		}catch {
//			print("写入失败")
//		}
        
		// language setting
		object_setClass(Foundation.Bundle.main, EMBundle.self)
		
		//加载缓存任务
		EMUploadManager.shared.loadCacheTasks()
		
		// 本地通知
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, erro) in
			if granted {
			}else{
			}
		}
		
        return true
    }
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		
		EMUploadManager.shared.service.isActivity = false
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		
		EMUploadManager.shared.service.isActivity = true
	}
	
	//MARK: 关闭应用保存下载任务
	func applicationWillTerminate(_ application: UIApplication) {
		
		EMUploadManager.shared.saveTasks()
	}
	
	//MARK: - 后台下载上传完成处理
	func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
		self.handler = completionHandler
        NSLog("Appdelegate --> 保存handleEventsForBackgroundURLSession的completionHandler")
//		creatNotificationContent(identifier: identifier)
	}
	
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler(.alert)
	}
	
}

