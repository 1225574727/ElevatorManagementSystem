//
//  EMRootController.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/10.
//

import Foundation
import UIKit
import SVProgressHUD

class EMRootController: EMBaseViewController {
	
	@IBOutlet weak var navLab:UILabel!
	@IBOutlet weak var changeLanuageBtn:UIButton!
	@IBOutlet weak var managerLab:UILabel!
	@IBOutlet weak var uploadLab:UILabel!
	@IBOutlet weak var historyLab:UILabel!
	@IBOutlet weak var settingLab:UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		self.automaticallyAdjustsScrollViewInsets = false
		
		setChangeBtnText()
		
		// 初始化pickerView
		EMPickerService.shared.setup()
		
		refreshData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = true
	}
	
	
	override func languageUpdate() {
		navLab.text = EMLocalizable("root_manage")
		managerLab.text = EMLocalizable("root_manage")
		uploadLab.text = EMLocalizable("root_upload")
		historyLab.text = EMLocalizable("root_history")
		settingLab.text = EMLocalizable("root_setting")
	}
	
	func setChangeBtnText() {
		var rangeDefault:NSRange
		var rangeSelect:NSRange
		if EMLanguageSetting.shared.language == .Chinese {
			rangeDefault = NSRange(location: 2, length: 3)
			rangeSelect = NSRange(location: 0, length: 2)
		} else {
			rangeDefault = NSRange(location: 0, length: 3)
			rangeSelect = NSRange(location: 3, length: 2)
		}
		let att:NSMutableAttributedString = NSMutableAttributedString(string: "EN/CN")
		att.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white], range: rangeDefault)
		att.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorFormHex(0xffffff, alpha: 0.4)], range: rangeSelect)
		changeLanuageBtn.setAttributedTitle(att, for: .normal)
	}
	
//	var progress:Float = 0
//	@objc func addTimer() {
//		if (progress >= 1) {
//			EMAlertService.dismissProgress()
//			progress = 0.0
//			return
//		}
//		progress += 0.1
//		EMAlertService.setProgress(progress: progress)
//		perform(#selector(addTimer), with: nil, afterDelay: 1)
//	}
	
	@IBAction override func changeLanguage() {
		
		EMAlertService.showAlertForLanguage { index in
			if index == 1 {
				super.changeLanguage()
				self.setChangeBtnText()
			}
		}
	}
	@IBAction func userAction(sender:UIButton) {
		print("\(sender.tag)")
		switch sender.tag {
		case 2017:
			let vc = EMManageController()
			self.navigationController?.pushViewController(vc, animated: true)
			break
        case 2018:
            let vc = EMChooseElevatorMainController()
            vc.fromType = .fromPicVideoUpload
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2019:
            let vc = EMChooseElevatorMainController()
            vc.fromType = .fromCheckHistory
            self.navigationController?.pushViewController(vc, animated: true)
            break
		case 2020:

			let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "setting")
			self.navigationController?.pushViewController(vc, animated: true)
			break
		default: break
			
		}
	}
	
	/// MARK: test
	func refreshData() {
		
		EMRequestProvider.request(.defaultRequest(url:"/mpcs/apv/queryAPV.do", params: ["appId":"1", "appVersion":"9.5.0", "v":"v9"]), model: ApvModel.self) { model in
			
			if (model != nil) {
				SVProgressHUD.showSuccess(withStatus: model?.msg)
			}
		}
	}
}
