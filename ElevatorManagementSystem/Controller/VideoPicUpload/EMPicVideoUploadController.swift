//
//  EMPicVideoUploadController.swift
//  ElevatorManagementSystem
//
//  Created by 姚李刚 on 2021/12/12.
//

import UIKit

class EMPicVideoUploadController: EMBaseViewController,UITableViewDataSource,UITableViewDelegate {

    static let kCategoryCell = "kCategoryCell"
    static let kTextInputCell = "kTextInputCell"
    static let kVideoUploadCell = "kVideoUploadCell"
    static let kPicUploadCell = "kPicUploadCell"
    static let kNoteInputCell = "kNoteInputCell"

    final let datas = [
        ["name":EMLocalizable("manage_id")],
        ["name":EMLocalizable("manage_dis"), "showUnit":true]
    ]
    
    var editData:Dictionary<String, Any>?
    
    var em_id = ""
    var em_name = ""
    var em_distance = ""
    
    ///MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图片视频上传"//EMLocalizable("manage_title")
        
        self.automaticallyAdjustsScrollViewInsets = false
        setupUI()
    }
    
    /// private
    private func setupUI() {
        
       
        
        self.view.addSubview(self.submitBtn)
        self.submitBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(48)
            make.bottom.equalTo(-38)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(NavigationBarHeight + 6)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.submitBtn.snp.top).offset(-10)
        }
    }
    
    ///MARK: table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    ///MARK: table view delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kCategoryCell) as! EMPicVideoUploadCell
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 1 {
            let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kTextInputCell) as! EMPicVideoUploadCell
            cell.selectionStyle = .none
            return cell
        }else {
            let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kTextInputCell) as! EMPicVideoUploadCell
            cell.titleName = "门与手机之间的距离："
            cell.selectionStyle = .none
            cell.data = "12.03"
            cell.inputCallBack =  { [weak self] text in
                guard let self = self else {
                    return
                }
                self.em_distance = text
            }
            return cell
        }
        
    }
    
    ///MARK: private
    private func inputCheck() -> Bool {
        var msg = ""
        if em_id.count == 0 {
            msg = EMLocalizable("manage_error_id")
        } else if em_name.count == 0 {
            msg = EMLocalizable("manage_error_name")
        } else if em_distance.count == 0 {
            msg = EMLocalizable("manage_error_dis")
        }
        if msg.count > 0 {
            EMAlertService.show(title:EMLocalizable("alert_tip") , message: msg, cancelTitle: EMLocalizable("alert_sure"), otherTitles: [], style: .alert) { _, _ in
                
            }
            return false
        }
        return true
    }
    
    ///MARK: lazy
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EMPicVideoUploadCell.self, forCellReuseIdentifier: EMPicVideoUploadController.kCategoryCell)
        tableView.register(EMPicVideoUploadCell.self, forCellReuseIdentifier: EMPicVideoUploadController.kTextInputCell)
        tableView.register(EMPicVideoUploadCell.self, forCellReuseIdentifier: EMPicVideoUploadController.kVideoUploadCell)
        tableView.register(EMPicVideoUploadCell.self, forCellReuseIdentifier: EMPicVideoUploadController.kPicUploadCell)
        tableView.register(EMPicVideoUploadCell.self, forCellReuseIdentifier: EMPicVideoUploadController.kNoteInputCell)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didHandler))
        tableView.addGestureRecognizer(tap)
        return tableView
    }()
    
    lazy var submitBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(EMLocalizable("manage_create"), for: .normal)
        btn.setTitleColor(UIColor.colorFormHex(0xffffff), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = 24
        btn.backgroundColor = UIColor.Main
        btn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        return btn
    }()
    
    
    @objc func didHandler() {
        view.endEditing(true)
    }
    
    @objc func createAction() {
        print("提交电梯")
       
    }
    
    @objc func cancelAction() {
        print("取消")
        self.navigationController?.popViewController(animated: true)
    }
}
