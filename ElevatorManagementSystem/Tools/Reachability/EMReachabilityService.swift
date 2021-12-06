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
}

