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
		self.view.backgroundColor = UIColor.colorFormHex(0xffffff)
        hideBackButtonTitle()
//		languageUpdate()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = false
	}
	
//	func languageUpdate() {
//
//	}

    
    func showActivity() {
        hudMB = MBProgressHUD.showAdded(to: self.view, animated: true)
        hudMB?.mode = .indeterminate
        hudMB?.label.text = "正在请求数据..."
    }
	
	func showActivity(message: String) {
		hudMB = MBProgressHUD.showAdded(to: self.view, animated: true)
		hudMB?.mode = .indeterminate
		hudMB?.label.text = message
	}
    
    func hideActivity() {
        hudMB?.hide(animated: true)
    }
    
    func hideBackButtonTitle() {
		
		self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage=UIImage()
	
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButtonItem.tintColor = .B6
        self.navigationItem.backBarButtonItem = backButtonItem
    }
    
}
