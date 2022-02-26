//
//  PCDDeviceService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/15.
//

import Foundation
import UIKit
import KeychainSwift

class EMDeviceService {
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
	static let deviceModel = getDeviceModel()
	
	private static func getDeviceModel() -> String {
		
		var systemInfo = utsname()
		uname(&systemInfo)
		
		let versionCode: String = String(validatingUTF8: NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)!.utf8String!)!

		switch versionCode {
			/*** iPhone ***/
			case "iPhone3,1", "iPhone3,2", "iPhone3,3":      return "iPhone4"
			case "iPhone4,1", "iPhone4,2", "iPhone4,3":      return "iPhone4S"
			case "iPhone5,1", "iPhone5,2":                   return "iPhone5"
			case "iPhone5,3", "iPhone5,4":                   return "iPhone5C"
			case "iPhone6,1", "iPhone6,2":                   return "iPhone5S"
			case "iPhone7,2":                                return "iPhone6"
			case "iPhone7,1":                                return "iPhone6Plus"
			case "iPhone8,1":                                return "iPhone6S"
			case "iPhone8,2":                                return "iPhone6SPlus"
			case "iPhone8,3", "iPhone8,4":                   return "iPhoneSE"
			case "iPhone9,1", "iPhone9,3":                   return "iPhone7"
			case "iPhone9,2", "iPhone9,4":                   return "iPhone7Plus"
			case "iPhone10,1", "iPhone10,4":                 return "iPhone8"
			case "iPhone10,2", "iPhone10,5":                 return "iPhone8Plus"
			case "iPhone10,3", "iPhone10,6":                 return "iPhoneX"
			case "iPhone11,2":                               return "iPhoneXS"
			case "iPhone11,4", "iPhone11,6":                 return "iPhoneXS_Max"
			case "iPhone11,8":                               return "iPhoneXR"
			case "iPhone12,1":                               return "iPhone11"
			case "iPhone12,3":                               return "iPhone11Pro"
			case "iPhone12,5":                               return "iPhone11Pro_Max"
			case "iPhone13,2":                               return "iPhone12"
			case "iPhone13,3":                               return "iPhone12Pro"
			case "iPhone13,4":                               return "iPhone12Pro_Max"
			case "iPhone14,2":                               return "iPhone13Pro"
			case "iPhone14,3":                               return "iPhone13Pro_Max"
			case "iPhone14,4":                               return "iPhone13_Mini"
			case "iPhone14,5":                               return "iPhone13"

			/*** Simulator ***/
			case "i386", "x86_64":                           return "Simulator"

			default:                                         return "unknown"
		}
	}
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
