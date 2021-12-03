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
    static let collectionViewCellID = "kCollectionViewCellID"

    var msgArray: [MessageModel] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.addSubview(tableView)
		
		tableView.snp.makeConstraints { (make) in
			make.left.right.top.bottom.equalToSuperview()
		}

		languageUpdate()
        
       refreshData()
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
    
	@objc func changeLanguage () {
		EMPhotoService.shared.showBottomAlert (resourceType: .media){ res in
			print("\(res)")
		}
		return
		if EMLanguageSetting.shared.language == .Chinese {
			EMLanguageSetting.shared.language = .English
		} else {
			EMLanguageSetting.shared.language = .Chinese
		}
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
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectView.delegate = self
        collectView.dataSource = self
        collectView.backgroundColor = UIColor.white
        collectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: EMMainViewController.collectionViewCellID)
        return collectView
    }()
    
}


extension EMMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    
    
    //MARK:UITableViewDataSource&& UITableViewDelegate

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: EMMainViewController.tableviewCellID, for: indexPath)
        
        cell.textLabel?.text = msgArray[indexPath.row].text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let vc = EMVideoRecordingController()
//            vc.title = msgArray[indexPath.row].text
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ViewController()
            vc.title = msgArray[indexPath.row].text
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
    }
    
    
    
    //MARK:UICollectionViewDataSource&& UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.largeContentTitle = "11"
        cell.backgroundColor = UIColor.red
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 200, height: 60)
    }
	
    
}


