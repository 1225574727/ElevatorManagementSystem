//
//  UIColor+Extension.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/10.
//

import UIKit

extension UIColor {

	static let Main = UIColor.colorFormHex(0xE60012)
	static let B3 = UIColor.colorFormHex(0x333333)
	static let B6 = UIColor.colorFormHex(0x666666)
	static let B9 = UIColor.colorFormHex(0x999999)
    static let Green = UIColor.colorFormHex(0x05CD19)
    static let GrayLine = UIColor.colorFormHex(0xE4E4E4)

    


	/// 用十六进制颜色创建UIColor
	static func colorFormHex(_ hex: Int) -> UIColor {
		
		return UIColor.colorFormHex(hex, alpha: 1.0)
	}
	
	static func colorFormHex(_ hex: Int, alpha: Float) -> UIColor {
		
		return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0,
					 green: ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0,
					  blue: ((CGFloat)(hex & 0xFF)) / 255.0,
					  alpha: CGFloat(alpha))
	}
	
	/// 用十六进制字符串颜色创建UIColor
	convenience init(hexString: String) {
			let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
			let scanner = Scanner(string: hexString)
			 
			if hexString.hasPrefix("#") {
				scanner.scanLocation = 1
			}
			 
			var color: UInt32 = 0
			scanner.scanHexInt32(&color)
			 
			let mask = 0x000000FF
			let r = Int(color >> 16) & mask
			let g = Int(color >> 8) & mask
			let b = Int(color) & mask
			 
			let red   = CGFloat(r) / 255.0
			let green = CGFloat(g) / 255.0
			let blue  = CGFloat(b) / 255.0
			 
			self.init(red: red, green: green, blue: blue, alpha: 1)
		}
}
