//
//  EMReachabilityService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/3.
//

import Foundation
import Alamofire
import UIKit

let allowNetCacheKey:String = "AllowNet"

enum EMReachabilityStatus {
	case notReachable
	case unknown
	case ethernetOrWiFi
	case wwan
}

class EMReachabilityService: NSObject {
	
//	static let shared = EMReachabilityService()
//	private override init() {}
	
	static func netWorkReachability(reachabilityStatus: @escaping(EMReachabilityStatus)->Void){
		let manager = NetworkReachabilityManager.init()
		manager!.startListening { (status) in
			
			manager?.stopListening()
			if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.cellular){

				reachabilityStatus(.wwan)
			}
			else if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi){
				
				reachabilityStatus(.ethernetOrWiFi)
			}
			else if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable{

				reachabilityStatus(.notReachable)
			}
			else if status == NetworkReachabilityManager.NetworkReachabilityStatus.unknown{

				reachabilityStatus(.unknown)
			}
		}
	}
	
	/// 获取是否允许数据流量上传
	static func allow_wwan() -> Bool {
		
		var rel = true
		if let cacheStatus = UserDefaults.standard.object(forKey: allowNetCacheKey) {
			if cacheStatus as! String == "0" {
				rel = false
			}
		} else {
			UserDefaults.standard.setValue("1", forKey: allowNetCacheKey)
		}
		return rel
	}
	
	static func set_allow_wwan(isAllow:Bool) {
		
		UserDefaults.standard.setValue(isAllow ? "1" : "0", forKey: allowNetCacheKey)
		UserDefaults.standard.synchronize()
	}
}

