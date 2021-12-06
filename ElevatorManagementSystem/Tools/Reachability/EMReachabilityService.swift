//
//  EMReachabilityService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/3.
//

import Foundation
import Alamofire

enum EMReachabilityStatus {
	case notReachable
	case unknown
	case ethernetOrWiFi
	case wwan
}

class EMReachabilityService: NSObject {
	
	static let rlHttpManage = EMReachabilityService()
	func netWorkReachability(reachabilityStatus: @escaping(EMReachabilityStatus)->Void){
		let manager = NetworkReachabilityManager.init()
		manager!.startListening { (status) in

			//wifi
			if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi){

				print("------.wifi")
				reachabilityStatus(.ethernetOrWiFi)

			}
			//不可用
			if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable{

				print("------没网")
				reachabilityStatus(.notReachable)

			}
			//未知
			if status == NetworkReachabilityManager.NetworkReachabilityStatus.unknown{

				print("------未知")
				reachabilityStatus(.unknown)
			}
			//蜂窝
			if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.cellular){

				print("------蜂窝")
				reachabilityStatus(.wwan)
			}
		}
	}
}

