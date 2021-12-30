//
//  Data+Extension.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/28.
//

import Foundation
import CommonCrypto

extension Data {
	func hexString() -> String {
		var t = ""
		let ts = [UInt8](self)
		for one in ts {
			t.append(String.init(format: "%02x", one))
		}
		return t
	}
	
	func MD5() -> Data {
		let da = Data.init(count: Int(CC_MD5_DIGEST_LENGTH))
		let unsafe = [UInt8](self)
		return da.withUnsafeBytes { (bytes) -> Data in
			let b = bytes.baseAddress!.bindMemory(to: UInt8.self, capacity: 4).predecessor()
			let mb = UnsafeMutablePointer(mutating: b)
			CC_MD5(unsafe, CC_LONG(count),mb)
			return da
		}
		// use:
		// let t = "Hello world!!"
		// var d = t.data(using: .utf8)!
		// print(d.MD5().hexString())
		// 1d94dd7dfd050410185a535b9575e184
	}
}
