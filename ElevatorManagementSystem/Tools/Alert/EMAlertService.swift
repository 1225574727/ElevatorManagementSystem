//
//  EMAlertService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/11/29.
//

import Foundation
import UIKit

enum EMAlertUploadType {
	case EMAlertUploadSuccess
	case EMAlertUploadFailure
}

class EMAlertService: NSObject {
	
	static func show(title: String?=nil, message: String?=nil, cancelTitle: String?=nil,otherTitles:[String]?=nil,style:UIAlertController.Style, closure: @escaping((_ action: UIAlertAction, _ index: Int)->())) {
		EMEventAtMain {
			let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
			
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
	
	static func showAlertForLanguage(closure:@escaping EMAlertActionHandler) {
		
		let cAlert = EMAlertController.init(title: EMLocalizable("alert_tip"), message: EMLocalizable("alert_change_language"), buttons: [EMLocalizable("alert_cancel"), EMLocalizable("alert_sure")], image: UIImage.init(named: "alert_tip")!, type: .EMAlertDefault,handler: closure)
		cAlert.show((UIApplication.shared.keyWindow?.rootViewController)! as UIViewController)
	}
	
	static func showAlertForNet(closure:@escaping EMAlertActionHandler) -> Bool {
		
		let cAlert = EMAlertController.init(title: EMLocalizable("alert_tip"), message: EMLocalizable("alert_net_tip"), buttons: [EMLocalizable("alert_net_setting"),EMLocalizable("alert_net_close")], image: UIImage.init(named: "alert_tip")!, type: .EMAlertTipVertical,handler: closure)
		cAlert.show((UIApplication.shared.keyWindow?.rootViewController)! as UIViewController)
		return true
	}
	
	static func showAlertForUpload(type:EMAlertUploadType, closure:@escaping EMAlertActionHandler) {

		var imageName:String
		var buttons:[String]
		var content: String
		if type == .EMAlertUploadSuccess {
			imageName = "alert_success"
			buttons = [EMLocalizable("alert_upload_continue"), EMLocalizable("alert_upload_go_home")]
			content = EMLocalizable("alert_upload_success")
		} else {
			imageName = "alert_failure"
			buttons = [EMLocalizable("alert_upload_fail_continue"), EMLocalizable("alert_upload_fail_cancel")]
			content = EMLocalizable("alert_upload_fail")
		}
		let cAlert = EMAlertController.init(title: content, message: "", buttons: buttons, image: UIImage.init(named: imageName)!, type: .EMAlertUpload,handler: closure)
		cAlert.imageSize = CGSize(width: 175, height: 175)
		cAlert.show((UIApplication.shared.keyWindow?.rootViewController)! as UIViewController)
	}

}