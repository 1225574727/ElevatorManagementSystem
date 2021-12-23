//
//  EMRecordDetailController.swift
//  ElevatorManagementSystem
//
//  Created by 姚李刚 on 2021/12/12.
//

import Foundation
import UIKit

class EMRecordDetailController: EMBaseViewController {
    
    static let kEMRecordDetailCell = "kEMRecordDetailCell"

    var historyDataArray: [String] = Array()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: EMRecordDetailController.kEMRecordDetailCell)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorColor = .clear
        tableview.backgroundColor = .white
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = EMLocalizable("choose_floor_title")
        
        historyDataArray.append("楼层一")
        historyDataArray.append("楼层二")
        historyDataArray.append("楼层三")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
}

extension EMRecordDetailController : UITableViewDataSource, UITableViewDelegate {
    //MARK:UITableViewDataSource&& UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: EMHistroyMainCell? = tableView.dequeueReusableCell(withIdentifier: EMRecordDetailController.kEMRecordDetailCell) as? EMHistroyMainCell
        if cell == nil {
            cell = EMHistroyMainCell(style: .default, reuseIdentifier: EMRecordDetailController.kEMRecordDetailCell)
        }
        
        cell!.updateCellData(model: RecordModel(timeText: "", titleText: historyDataArray[indexPath.row], checkText: ""), type: .detailRecordCell)
                
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.historyDataArray.count
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
        
        self.navigationController?.pushViewController(EMCheckDataController(), animated: true)

        
    }
}
