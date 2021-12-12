//
//  EMManagController.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/11.
//

import Foundation
import UIKit

typealias ManageEditHandler = () -> Void

class EMManageCell: UITableViewCell {
	
	var editHandler:ManageEditHandler?
	private lazy var titleLab:UILabel = {
		
		let lab = UILabel.init(frame: .zero)
		lab.textColor = UIColor.colorFormHex(0x333333)
		lab.font = UIFont.boldSystemFont(ofSize: 16)
		lab.text = "x号电梯"
		return lab
	}()
	
	lazy var editBtn:UIButton = {
		
		let btn = UIButton.init(type: .custom)
		btn.setTitle(EMLocalizable("manage_edit"), for: .normal)
		btn.setTitleColor(UIColor.Main, for: .normal)
		btn.addTarget(self, action: #selector(manageEditAction), for: .touchUpInside)
		btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		return btn
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	
	func setupUI() {
		
		let contentIV = UIImageView.init(image: UIImage.init(named: "manage_bg"))
		contentView.addSubview(contentIV)
		contentIV.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
		}
		
		contentView.addSubview(titleLab)
		titleLab.snp.makeConstraints { make in
			make.left.equalTo(contentIV).offset(16)
			make.centerY.equalTo(contentIV)
		}
		
		contentView.addSubview(editBtn)
		editBtn.snp.makeConstraints { make in
			make.right.equalTo(contentIV).offset(-16)
			make.centerY.equalTo(contentIV)
		}
		
	}
	
	@objc func manageEditAction() {
		
		if let handler = editHandler {
			handler()
		}
	}
}

class EMManageController: EMBaseViewController,UITableViewDataSource,UITableViewDelegate {

	final let CellIdentifier = "ManageCell"
	///MARK: life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = EMLocalizable("manage_title")
		
		self.automaticallyAdjustsScrollViewInsets = false
		setupUI()
	}
	
	/// private
	private func setupUI() {
		
		self.view.addSubview(self.createBtn)
		self.createBtn.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 60, right: 20))
			make.height.equalTo(48)
		}
		
		self.view.addSubview(self.tableView)
		self.tableView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(NavigationBarHeight + 6)
			make.left.right.equalToSuperview()
			make.bottom.equalTo(self.createBtn.snp.top).offset(-10)
		}
	}
	
	///MARK: table view data source
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 6
	}
	
	///MARK: table view delegate
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:EMManageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! EMManageCell
		cell.editHandler =  {
			let vc = EMCreateController()
			vc.createType = .edit
			vc.editData = ["id":"12345678","name":"x号电梯","distance":"12.00"]
			self.navigationController?.pushViewController(vc, animated: true)
		}
		return cell
	}
	
	///MARK: lazy
	lazy var tableView:UITableView = {
		let tableView = UITableView.init(frame: .zero, style: .plain)
		tableView.separatorStyle = .none
		tableView.dataSource = self
		tableView.delegate = self
		tableView.allowsSelection = false
		tableView.register(EMManageCell.self, forCellReuseIdentifier: CellIdentifier)
		return tableView
	}()
	
	lazy var createBtn:UIButton = {
		let btn = UIButton.init(type: .custom)
		btn.setTitle(EMLocalizable("manage_create"), for: .normal)
		btn.setTitleColor(UIColor.colorFormHex(0xffffff), for: .normal)
		btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
		btn.layer.cornerRadius = 24
		btn.backgroundColor = UIColor.Main
		btn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
		return btn
	}()
	
	@objc func createAction() {
		let vc = EMCreateController()
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
