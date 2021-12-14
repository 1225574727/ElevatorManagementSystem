//
//  EMCreateController.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/11.
//

import Foundation
import UIKit

typealias InputHanlder = (_ text:String)->Void

class EMCreateCell: UITableViewCell,UITextFieldDelegate {
	
	var titleName:String = "" {

		didSet {
			self.titleLab.text = titleName
		}
	}
	
	var placeholder:String? {
		didSet {
			self.textField.placeholder = placeholder
		}
	}
	
	var showUnit:Bool = false {
		didSet {
			if showUnit {
				desc.isHidden = false
				textField.keyboardType = .decimalPad
				textField.snp.remakeConstraints { make in
					make.left.equalToSuperview().offset(10)
					make.centerY.equalToSuperview()
					make.right.equalTo(desc.snp.left).offset(-10)
				}
			} else {
				desc.isHidden = true
			}
		}
	}
	
	var showDescTip:Bool = false {
		didSet {
			descTip.isHidden = !showDescTip
			textField.isEnabled = !showDescTip
		}
	}
	
	var data:String? {
		didSet {
			textField.text = data
		}
	}
	var inputHandler:InputHanlder?
	private lazy var titleLab:UILabel = {
		
		let lab = UILabel.init(frame: .zero)
		lab.textColor = UIColor.colorFormHex(0x333333)
		lab.font = UIFont.boldSystemFont(ofSize: 14)
		lab.text = "*电梯"
		return lab
	}()
	
	private lazy var textField:UITextField = {
		
		let tf = UITextField()
		tf.textColor = UIColor.colorFormHex(0x333333)
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.delegate = self
		return tf
	}()
	
	private lazy var desc:UILabel = {
		
		let lab = UILabel()
		lab.text = "CM"
		lab.font = UIFont.systemFont(ofSize: 14)
		lab.textColor = UIColor.B3
		return lab
	}()
	
	private lazy var descTip:UILabel = {
		
		let lab = UILabel()
		lab.text = EMLocalizable("manage_remark")
		lab.font = UIFont.systemFont(ofSize: 12)
		lab.textColor = UIColor.Main
		return lab
	}()
	
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		if let handler = inputHandler {
			handler(textField.text ?? "")
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	
	func setupUI() {
		
		contentView.addSubview(titleLab)
		titleLab.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(20)
			make.top.equalToSuperview().offset(10)
		}
		
		self.addSubview(descTip)
		descTip.isHidden = true
		descTip.snp.makeConstraints { make in
			make.right.equalToSuperview().offset(-20)
			make.centerY.equalTo(titleLab)
		}
		
		let bgView = UIView()
		bgView.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
		bgView.layer.cornerRadius = 8
		contentView.addSubview(bgView)
		bgView.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20))
			make.top.equalTo(titleLab.snp.bottom).offset(10)
			make.height.equalTo(60)
		}
		
		bgView.addSubview(desc)
		desc.snp.makeConstraints { make in
			make.right.equalToSuperview().offset(-10)
			make.centerY.equalToSuperview()
			make.width.equalTo(30)
		}
		desc.isHidden = true
		
		bgView.addSubview(textField)
		textField.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(10)
			make.centerY.equalToSuperview()
			make.right.equalToSuperview().offset(-10)
		}
	}
	
	///MARK: textField delegate
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if !showUnit {
			return true
		}
		if string.count == 0{
			return true
		}
		// 被替换字符串的range 即将键入或者粘贴的string
		let checkStr = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
		let regex = "^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$"
		return self.isValid(checkStr: checkStr!, regex: regex)
	}
	
	func isValid(checkStr:String, regex:String) ->Bool {
		
		let predicte = NSPredicate(format:"SELF MATCHES %@", regex)
		return predicte.evaluate(with: checkStr)
	}
}


enum EMCreateType {
	case create
	case edit
}

class EMCreateController: EMBaseViewController,UITableViewDataSource,UITableViewDelegate {
	
	final let CellIdentifier = "CreateCell"
	
	final let datas = [
		["name":EMLocalizable("manage_id")],
		["name":EMLocalizable("manage_name")],
		["name":EMLocalizable("manage_dis"), "showUnit":true]
	]
	
	var createType:EMCreateType = .create
	var editData:Dictionary<String, Any>?
	
	var em_id = ""
	var em_name = ""
	var em_distance = ""
	
	///MARK: life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = EMLocalizable("manage_title")
		
		self.automaticallyAdjustsScrollViewInsets = false
		setupUI()
	}
	
	/// private
	private func setupUI() {
		
		if createType == .edit {
			self.view.addSubview(cancelBtn)
			cancelBtn.snp.makeConstraints { make in
				make.left.equalToSuperview().offset(20)
				make.bottom.equalToSuperview().offset(-60)
				make.height.equalTo(48)
			}
		}
		
		self.view.addSubview(self.submitBtn)
		self.submitBtn.snp.makeConstraints { make in
			make.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 20))
			make.height.equalTo(48)
			if createType == .edit {
				make.left.equalTo(cancelBtn.snp.right).offset(27)
				make.width.equalTo(cancelBtn)
			} else {
				make.left.equalToSuperview().offset(20)
			}
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
		let cell:EMCreateCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! EMCreateCell
		cell.selectionStyle = .none
		cell.titleName =  "*\(datas[indexPath.row]["name"] ?? ""):"
		if createType == .edit,let data = editData {
			var content = ""
			switch indexPath.row {
			case 0:
				cell.placeholder = data["id"] as? String
				cell.showDescTip = true
				break
			case 1:
				content = data["name"] as! String
				break
			case 2:
				content = data["distance"] as! String
				break
			default: break
			}
			if content.count > 0 {
				cell.data = content
			}
		}
		if let show = datas[indexPath.row]["showUnit"] {
			cell.showUnit = show as! Bool
			cell.placeholder = "0.00"
		}
		cell.inputHandler =  {
			text in
			switch indexPath.row {
			case 0:
				self.em_id = text
				break
			case 1:
				self.em_name = text
				break
			case 2:
				self.em_distance = text
				break
			default:
				break
			}
			print("\(indexPath.row)--\(text)")
		}
		return cell
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
		tableView.register(EMCreateCell.self, forCellReuseIdentifier: CellIdentifier)
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didHandler))
		tableView.addGestureRecognizer(tap)
		return tableView
	}()
	
	lazy var submitBtn:UIButton = {
		let btn = UIButton.init(type: .custom)
		btn.setTitle(createType == .edit ? EMLocalizable("manage_eidt_save"):EMLocalizable("manage_create"), for: .normal)
		btn.setTitleColor(UIColor.colorFormHex(0xffffff), for: .normal)
		btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
		btn.layer.cornerRadius = 24
		btn.backgroundColor = UIColor.Main
		btn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
		return btn
	}()
	
	lazy var cancelBtn:UIButton = {
		let btn = UIButton.init(type: .custom)
		btn.setTitle(EMLocalizable("manage_eidt_cancel"), for: .normal)
		btn.setTitleColor(UIColor.Main, for: .normal)
		btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
		btn.layer.cornerRadius = 24
		btn.backgroundColor = UIColor.white
		btn.layer.borderWidth = 1.0
		btn.layer.borderColor = UIColor.Main.cgColor
		btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
		return btn
	}()
	
	@objc func didHandler() {
		view.endEditing(true)
	}
	
	@objc func createAction() {
		print("提交电梯")
		if createType == .edit {
			self.navigationController?.popViewController(animated: true)
			return
		}
		let success = inputCheck()
		if success {
			self.navigationController?.popViewController(animated: true)
			return
		}
	}
	
	@objc func cancelAction() {
		print("取消")
		self.navigationController?.popViewController(animated: true)
	}
}
