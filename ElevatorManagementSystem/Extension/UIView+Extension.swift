//
//  UIView+Extension.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/10.
//

import UIKit

extension UIView {
	
	var x: CGFloat {
		get {
			return frame.origin.x
		}
		set(newValue) {
			var tempFrame = frame
			tempFrame.origin.x = newValue
			frame = tempFrame
		}
	}
	
	var y: CGFloat {
		get {
			return frame.origin.y
		}
		set(newValue) {
			var tempFrame = frame
			tempFrame.origin.y = newValue
			frame = tempFrame
		}
	}
	
	var width: CGFloat {
		get {
			return frame.size.width
		}
		set(newValue) {
			var tempFrame = frame
			tempFrame.size.width = newValue
			frame = tempFrame
		}
	}
	
	var height: CGFloat {
		get {
			return frame.size.height
		}
		set(newValue) {
			var tempFrame = frame
			tempFrame.size.height = newValue
			frame = tempFrame
		}
	}
	
	var size: CGSize {
		get {
			return frame.size
		}
		set(newValue) {
			var tempFrame = frame
			tempFrame.size = newValue
			frame = tempFrame
		}
	}
	
	
	var centerX: CGFloat {
		get {
			return center.x
		}
		set(newValue) {
			var tempFrame = center
			tempFrame.x = newValue
			center = tempFrame
		}
	}
	
	var centerY: CGFloat {
		get {
			return center.y
		}
		set(newValue) {
			var tempCenter = center
			tempCenter.y = newValue
			center = tempCenter
		}
	}
	
	var maxX: CGFloat {
		return frame.maxX
	}
	
	var maxY: CGFloat {
		return frame.maxY
	}
	
}
