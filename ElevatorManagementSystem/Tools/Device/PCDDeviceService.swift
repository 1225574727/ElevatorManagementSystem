//
//  PCDDeviceService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/15.
//

import Foundation
import UIKit
import KeychainSwift

class PCDDeviceService {
	private static let keychain = KeychainSwift()

	/// 设备别名
	static let deviceName = UIDevice.current.name
	
	/// 系统版本
	static let sysVersion = UIDevice.current.systemVersion
	
	/// uuid
	static var deviceUUID:String {
		get {
			var cuuid = keychain.get("em_uuid")
			guard cuuid != nil  else {
				cuuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
				if cuuid != "" {
					keychain.set(cuuid!, forKey: "em_uuid")
				}
				return cuuid!
			}
			return cuuid!
		}
	}
	
	/// 设备类型
	static let deviceModel = UIDevice.current.model
}

extension Bundle {
	
	/// 应用名称
	var appDisplayName: String {
		if let name = infoDictionary?["CFBundleDisplayName"] as? String {
			return name
		}
		return ""
	}
	
	/// 版本号
	var appVersion: String {
		if let version = infoDictionary?["CFBundleShortVersionString"] as? String {
			return version
		}
		return ""
	}
	
	/// build号
	var buildVersion: String {
		if let version = infoDictionary?["CFBundleVersion"] as? String {
			return version
		}
		return ""
	}
	
}
