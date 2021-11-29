//
//  EMAlertService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/11/29.
//

import Foundation
import UIKit

class EMAlertService: NSObject {
	
	static func show(title: String?=nil, message: String?=nil, cancelTitle: String?=nil,otherTitles:[String]?=nil,style:UIAlertController.Style, closure: @escaping((_ action: UIAlertAction, _ index: Int)->())) {
		
		let alertController = UIAlertController.init(title: title, message: (title == nil&&message == nil) ? "":message, preferredStyle: style)
		
		var titles:[String] = []
		if cancelTitle != nil {
			titles.insert(cancelTitle!, at: 0)
		}
		if otherTitles != nil {
			titles = titles + otherTitles!
		}

		for (index, value) in titles.enumerated() {
			var actionStyle:UIAlertAction.Style = .default
			if cancelTitle != nil && index == 0 {
				actionStyle = .cancel
			}
			let tAction = UIAlertAction.init(title: value, style: actionStyle) { action in
				closure(action, index)
			}
			alertController.addAction(tAction)
		}
		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
	}
}
