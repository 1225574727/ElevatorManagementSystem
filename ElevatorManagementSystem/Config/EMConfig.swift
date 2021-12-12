//
//  EMConfig.swift
//  ElevatorManagementSystem
//
//  Created by ylg on 2021/11/6.
//

import Foundation
import UIKit

//设备屏幕尺寸
let currentMode_width = (UIScreen.main.currentMode?.size.width ?? 375)
let currentMode_height = (UIScreen.main.currentMode?.size.height ?? 786)

// 判断是否是iPhone X
// iphoneX iPhoneXs 1125, 2436
let iPhoneX = currentMode_height == 2436 ? true : false
// iPhoneXr 828, 1792
let iPhoneXr = currentMode_height == 1792 ? true : false
// iPhoneXs_Max 1242, 2688
let iPhoneXs_Max = currentMode_height == 2688 ? true : false
// iPhone12Mini 1080, 2340
let iPhone12Mini = currentMode_height == 2340 ? true : false
// iPhone12 1170, 2532
let iPhone12 = currentMode_height == 2532 ? true : false
// iPhone12ProMax 1284, 2778
let iPhone12ProMax = currentMode_height == 2778 ? true : false
// isXDevice
let isXDevice = (iPhoneX == true || iPhoneXr == true || iPhoneXs_Max == true || iPhone12Mini == true || iPhone12 == true || iPhone12ProMax == true) ? true : false

// 状态栏高度
let StatusBarHeight:CGFloat = (isXDevice ? 44.0 : 20.0)
// 导航栏高度
let NavigationBarHeight:CGFloat = (isXDevice ? 88.0 : 64.0)
// tabBar高度
let TabBarHeight:CGFloat = (isXDevice ? (49.0+34.0) : 49.0)
// tabBar高度
let HOME_INDICATOR_HEIGHT:CGFloat = (isXDevice ? 34.0 : 0)

let EMUserDefault = UserDefaults.standard

func EMLocalizable(_ s: String) -> String {
	return NSLocalizedString(s, comment: "")
}

func EMEventAtMain(_ clouse: @escaping ()->()) {
	// 判断当前线程是否是主线程
	if Thread.current.isMainThread {
		// UI 事件
		clouse()
	} else {
		// 切换到 main 线程，处理
		DispatchQueue.main.async {
			clouse()
		}
	}
}
