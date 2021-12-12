//
//  EMSettingController.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/11.
//

import Foundation
import UIKit

class EMSettingController: EMBaseViewController {
	
	@IBOutlet weak var switchNet:UISwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = EMLocalizable("setting_title")
		self.view.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
		switchNet.isOn = EMReachabilityService.allow_wwan()
	}
	
	@IBAction func valueChange(sender:UISwitch) {

		EMReachabilityService.set_allow_wwan(isAllow: sender.isOn)
	}
}
