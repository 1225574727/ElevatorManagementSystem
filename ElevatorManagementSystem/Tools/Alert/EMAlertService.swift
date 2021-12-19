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
	
	static var proressAlert: EMAlertController?
	
	static func show(title: String?=nil, message: String?=nil, cancelTitle: String?=nil,otherTitles:[String]?=nil,style:UIAlertController.Style, closure: @escaping((_ action: UIAlertAction, _ index: Int)->())) {
		EMEventAtMain {
			let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
			if style == .actionSheet {
				
				alertController.view.tintColor = UIColor.B3
			}
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
	
	static func showAlertForNet(closure:@escaping EMAlertActionHandler) {
		
		let cAlert = EMAlertController.init(title: EMLocalizable("alert_tip"), message: EMLocalizable("alert_net_tip"), buttons: [EMLocalizable("alert_net_setting"),EMLocalizable("alert_net_close")], image: UIImage.init(named: "alert_tip")!, type: .EMAlertTipVertical,handler: closure)
		cAlert.show((UIApplication.shared.keyWindow?.rootViewController)! as UIViewController)
	}
	
	static func showAlertForUploading(closure:@escaping EMAlertActionHandler) {

		let imageName:String = "alert_success"
		let buttons:[String] = [EMLocalizable("alert_upload_list"), EMLocalizable("alert_upload_sure")]
		let content: String = EMLocalizable("alert_upload_content")
		let cAlert = EMAlertController.init(title: content, message: "", buttons: buttons, image: UIImage.init(named: imageName)!, type: .EMAlertUpload,handler: closure)
		cAlert.imageSize = CGSize(width: 175, height: 175)
		cAlert.show((UIApplication.shared.keyWindow?.rootViewController)! as UIViewController)
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

	/// 进度条相关
	static func showAlertForProgress() {
		
		EMAlertService.proressAlert = EMAlertController.init(progress: "上传中")
		EMAlertService.proressAlert!.show((UIApplication.shared.keyWindow?.rootViewController)! as UIViewController)
	}
	
	static func setProgress(progress:Float) {
		
		EMAlertService.proressAlert!.progress = progress
	}
	
	static func dismissProgress() {
		EMAlertService.proressAlert!.dismiss(animated: true) {
			EMAlertService.proressAlert = nil
		}
	}
}
