//
//  EMChooseRecordController.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/12/11.
//

import UIKit

class EMChooseRecordController: EMBaseViewController{
    static let kEMChooseRecordCell = "kEMChooseRecordCell"

    var recordDataArray: [RecordModel] = Array()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: EMChooseRecordController.kEMChooseRecordCell)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorColor = .clear
        tableview.backgroundColor = .white
        return tableview
    }()
    
    lazy var bgImageV: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "empty_record")
        return imageV
    }()
    
    lazy var recordSelectView: EMRecordSelectView = {
        let view = EMRecordSelectView.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 0))
        view.selectCallBack = { [weak self] (type, isSelected) in
            guard let self = self else {
                return
            }
            if isSelected {
                self.recordResultView.chooseDatePicker(isSelected: type == .time)
                UIView.animate(withDuration: 0.25) {
                    self.recordResultView.isHidden = false
                    self.recordResultView.snp.removeConstraints()
                    self.recordResultView.snp.remakeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.height.equalTo(250)
                        make.top.equalTo(self.recordSelectView.snp.bottom)
                    }
                    self.view.layoutIfNeeded()
                } completion: { isComplete in
                    self.recordResultView.reloadDatePicker()
                }
            }else {
                
                UIView.animate(withDuration: 0.25) {
                    self.recordResultView.snp.removeConstraints()
                    self.recordResultView.snp.remakeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.height.equalTo(0)
                        make.top.equalTo(self.recordSelectView.snp.bottom)
                    }
                    self.view.layoutIfNeeded()
                    self.recordResultView.isHidden = true
                } completion: { isComplete in
                }

            }
            
        }
        return view
    }()
    
    lazy var recordResultView: EMRecordResultView = {
        let view = EMRecordResultView.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 150))
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "选择记录"

        recordDataArray.append(RecordModel(timeText: "2020-02-02 12:17", titleText: "记录一", checkText: CheckStyle.afterCalibration.checkText))
        recordDataArray.append(RecordModel(timeText: "2020-02-02 12:17", titleText: "记录一", checkText: CheckStyle.afterCalibration.checkText))
        recordDataArray.append(RecordModel(timeText: "2020-02-02 12:17", titleText: "记录一", checkText: CheckStyle.afterCalibration.checkText))
        
        self.view.addSubview(recordSelectView)
        self.view.addSubview(tableView)
        self.view.addSubview(bgImageV)
        self.view.addSubview(recordResultView)

        
        recordSelectView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
            make.top.equalTo(NavigationBarHeight)
        }
        
        bgImageV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(166)
            make.top.equalTo(50 + NavigationBarHeight)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(recordSelectView.snp.bottom)
        }
        
        recordResultView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.top.equalTo(recordSelectView.snp.bottom)
        }
        
        recordResultView.isHidden = true
        bgImageV.isHidden = true
        
    }
}

extension EMChooseRecordController : UITableViewDataSource, UITableViewDelegate {
    //MARK:UITableViewDataSource&& UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: EMHistroyMainCell? = tableView.dequeueReusableCell(withIdentifier: EMChooseRecordController.kEMChooseRecordCell) as? EMHistroyMainCell
        if cell == nil {
            cell = EMHistroyMainCell(style: .default, reuseIdentifier: EMChooseRecordController.kEMChooseRecordCell)
        }
        
        let model = recordDataArray[indexPath.row]
        cell!.updateCellData(model: model, type: .chooseRecordCell)
                
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.recordDataArray.count
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
        
        self.navigationController?.pushViewController(EMRecordDetailController(), animated: true)
        
    }
}
