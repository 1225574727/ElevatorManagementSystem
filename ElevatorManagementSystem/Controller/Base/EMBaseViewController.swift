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

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
    }
    
}
