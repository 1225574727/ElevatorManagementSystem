//
//  FMBaseViewController.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/9/6.
//

import UIKit
import SVProgressHUD
import MBProgressHUD

class EMBaseViewController: UIViewController {
    
    var hudMB: MBProgressHUD?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackButtonTitle()
		languageUpdate()
		let appSettings = EMLanguageSetting.shared
		appSettings.observableLaunguage.onSet { [self] (oldValue, newValue) in
//			print("oldValue:\(oldValue)  newValue:\(newValue)")
			languageUpdate()
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = false
	}
	
	func languageUpdate() {
		
	}
	
	@objc func changeLanguage () {
		
		if EMLanguageSetting.shared.language == .Chinese {
			EMLanguageSetting.shared.language = .English
		} else {
			EMLanguageSetting.shared.language = .Chinese
		}
		
	}
    
    func showActivity() {
        hudMB = MBProgressHUD.showAdded(to: self.view, animated: true)
        hudMB?.mode = .indeterminate
        hudMB?.label.text = "正在请求数据..."
    }
    
    func hideActivity() {
        hudMB?.hide(animated: true)
    }
    
    
    func hideBackButtonTitle() {
//        let navBar = UINavigationBar.appearance()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .bottom, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage=UIImage()
//
//        self.navigationController?.navigationBar.backgroundColor = .white
//        self.navigationController?.navigationBar.isTranslucent = false
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButtonItem.tintColor = .B6
        self.navigationItem.backBarButtonItem = backButtonItem
        
    }
    
}
