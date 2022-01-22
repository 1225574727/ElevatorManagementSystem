//
//  EMRecordDetailController.swift
//  ElevatorManagementSystem
//
//  Created by ylg on 2021/12/12.
//

import Foundation
import UIKit

class EMRecordDetailController: EMBaseViewController {
    
    static let kEMRecordDetailCell = "kEMRecordDetailCell"
    
    var floorDataArray: [EMFloorItemEntity] = Array()

    
    var orderId: String?
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: EMRecordDetailController.kEMRecordDetailCell)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorColor = .clear
        tableview.backgroundColor = .white
        return tableview
    }()
    
    lazy var emptyBgImageV: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "empty_record")
        return imageV
    }()
    
    lazy var emptyTipLabel: UILabel = {
        let label = UILabel()
        label.text = EMLocalizable("no_more_floorRecord")
        label.textAlignment = .center
        label.textColor = .B6
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = EMLocalizable("choose_floor_title")
        
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(emptyBgImageV)
        self.view .addSubview(emptyTipLabel)

        emptyBgImageV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(166)
            make.top.equalTo(50 + NavigationBarHeight)
        }
        
        emptyTipLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.equalTo(emptyBgImageV.snp.bottom).offset(4)
        }
        
        fetchData()
        
    }
    
    func fetchData() {
        
        guard orderId != nil else {
            showEmptyView(isHide: true)
            return
        }
        
        EMRequestProvider.request(.defaultRequest(url:"/order/getComponentListByOrderId", params: ["orderId":orderId!]), model: EMFloorEntity.self) { [weak self] model in
            
            guard let self = self else {
                return
            }
            if let model = model, let data = model.data {
                
                guard data.count > 0 else {
                    self.showEmptyView(isHide: true)
                    return
                }
                self.showEmptyView(isHide: false)
                self.floorDataArray = data
                self.tableView.reloadData()
            }   else {
                self.showEmptyView(isHide: true)
            }
        }
        
    }
    
    func showEmptyView(isHide: Bool){
        emptyBgImageV.isHidden = isHide
        emptyTipLabel.isHidden = isHide
        self.tableView.isHidden = !isHide
    }
    
    
}

extension EMRecordDetailController : UITableViewDataSource, UITableViewDelegate {
    //MARK:UITableViewDataSource&& UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: EMHistroyMainCell? = tableView.dequeueReusableCell(withIdentifier: EMRecordDetailController.kEMRecordDetailCell) as? EMHistroyMainCell
        if cell == nil {
            cell = EMHistroyMainCell(style: .default, reuseIdentifier: EMRecordDetailController.kEMRecordDetailCell)
        }
        
        let model = self.floorDataArray[indexPath.row]
        cell!.updateCellData(model: RecordModel(timeText: "", titleText: model.name
                                                , checkText: ""), type: .detailRecordCell)
                
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.floorDataArray.count
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
        let model = self.floorDataArray[indexPath.row]
        let vc = EMCheckDataController()
        vc.componentId = model.componentId
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
}
