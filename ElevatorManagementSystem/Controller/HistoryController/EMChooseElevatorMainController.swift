//
//  EMChooseElevatorMainController.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/12/11.
//

import Foundation
import UIKit

enum EMFromFunctionType {
    case fromPicVideoUpload
    case fromCheckHistory
}

class EMChooseElevatorMainController: EMBaseViewController {
    
    static let kEMHistroyMainCell = "kEMHistroyMainCell"

    var fromType: EMFromFunctionType?
    
    var emDataArray: [EMListItemEntity] = Array()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: EMChooseElevatorMainController.kEMHistroyMainCell)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorColor = .clear
        tableview.backgroundColor = .white
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = EMLocalizable("choose_elevator_title")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        fetchEquipmentListData()
    }
    
    func fetchEquipmentListData() {
        
		EMRequestProvider.request(.defaultRequest(url:"/equipment/getEquipmentList", params: [:]), model: EMListEntity.self) { model in
            
            if let model = model, let dataArray = model.data {
                
                self.emDataArray = dataArray
                EMEventAtMain {
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
   

}

extension EMChooseElevatorMainController : UITableViewDataSource, UITableViewDelegate {
    //MARK:UITableViewDataSource&& UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: EMHistroyMainCell? = tableView.dequeueReusableCell(withIdentifier: EMChooseElevatorMainController.kEMHistroyMainCell) as? EMHistroyMainCell
        if cell == nil {
            cell = EMHistroyMainCell(style: .default, reuseIdentifier: EMChooseElevatorMainController.kEMHistroyMainCell)
        }
        let model: EMListItemEntity = emDataArray[indexPath.section]
        cell!.updateCellData(model: RecordModel(timeText: "", titleText:model.name , checkText: ""), type: .elevatorCell)
                
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.emDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model: EMListItemEntity = emDataArray[indexPath.section]
       
        if fromType == .fromCheckHistory {
            
            let vc = EMChooseRecordController()
            vc.itemEntity = model
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
			if !EMReachabilityService.allow_wwan() {
				EMReachabilityService.netWorkReachability { status in
					if status == .wwan {
						EMAlertService.showAlertForNet { index in
							if index == 0 {
								let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "setting")
								self.navigationController?.pushViewController(vc, animated: true)
							}
						}
					} else {
                        let videoVC = EMPicVideoUploadController()
                        videoVC.equipmentId = model.equipmentId
                        videoVC.equipmentName = model.name
						videoVC.doorDistance = model.doorDistance ?? ""
						self.navigationController?.pushViewController(videoVC, animated: true)
					}
				}
				return
			}
            
            let videoVC = EMPicVideoUploadController()
            videoVC.equipmentId = model.equipmentId
			videoVC.equipmentName = model.name
			
			if let tDistance = model.doorDistance {
				
				videoVC.doorDistance = String(format: "%.2f", Float(tDistance)!)
			}
            self.navigationController?.pushViewController(videoVC, animated: true)
            
        }
        
        
    }
}

