//
//  FMMainViewController.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/9/6.
//

import UIKit
import SnapKit
import HandyJSON
import SwiftyJSON
import SVProgressHUD

struct MessageModel: HandyJSON {
    var text: String = ""
    var date: Date?
}

class EMMainViewController: EMBaseViewController{
    
    static let tableviewCellID = "kTableviewCellID"

    var msgArray: [MessageModel] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.view.addSubview(tableView)
		
		tableView.snp.makeConstraints { (make) in
			
			make.edges.equalToSuperview()
		}

		languageUpdate()
        
       refreshData()
		
		// 初始化pickerView
		EMPickerService.shared.setup()
    }
	
	override func languageUpdate() {
		self.title = EMLocalizable("root_page_title")
		if let rightBarItem = self.navigationItem.rightBarButtonItem {
			rightBarItem.title = EMLocalizable("change_language")
		} else {
			self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: EMLocalizable("change_language"), style: .plain, target: self, action: #selector(changeLanguage))
		}
		let textArr = [
			EMLocalizable("elevator_management"),
			EMLocalizable("video_upload"),
			EMLocalizable("history")
		]

		msgArray.removeAll()
		for text in textArr {
			let msgModel = MessageModel(text: text, date: Date())
			msgArray.append(msgModel)
		}
		tableView.reloadData()
	}
    	
    func refreshData() {
        
        showActivity()
        
        EMHomeProvider.request(.fmHomeData(appId: "1", appVersion: "9.5.0", version: "v9"), model: ApvModel.self) { [weak self] model in
            
            self?.hideActivity()
            
            if (model != nil) {
                SVProgressHUD.showSuccess(withStatus: model?.msg)
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: EMMainViewController.tableviewCellID)
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()
    
}


extension EMMainViewController : UITableViewDataSource, UITableViewDelegate {
    
    //MARK:UITableViewDataSource&& UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: EMMainViewController.tableviewCellID, for: indexPath)
        
        cell.textLabel?.text = msgArray[indexPath.row].text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0.01
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return UIView.init()
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let vc = EMVideoRecordingController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}


