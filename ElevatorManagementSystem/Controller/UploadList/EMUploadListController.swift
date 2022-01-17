//
//  EMUploadListController.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/19.
//

import Foundation
import UIKit

enum EMUploadCellStatus {
	case loading
	case waiting
	case failure
}

class EMUploadListCell: UITableViewCell {
	
	var timer: String? {
		didSet {
			timerLab.text = timer
		}
	}
	
	var title: String? {
		didSet {
			titleLab.text = title
		}
	}
	
	var progress: Float = 0.0 {
		didSet {
			progressView.setProgress(progress, animated: true)
		}
	}
    
    func updateProgress(animated: Bool, progress: Float) {
        progressView.setProgress(progress, animated: animated)
    }
	
	var status:EMUploadCellStatus = .waiting {
		didSet {
			switch status {
			case .loading:
				statusButton.setTitle(EMLocalizable("upload_list_status_loading"), for: .normal)
				statusButton.isEnabled = false
				statusButton.setTitleColor(UIColor.B3, for: .normal)
				statusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
				statusButton.backgroundColor = UIColor.clear
				break
			case .waiting:
				statusButton.setTitle(EMLocalizable("upload_list_status_waitting"), for: .normal)
				statusButton.isEnabled = false
				statusButton.setTitleColor(UIColor.B3, for: .normal)
				statusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
				statusButton.backgroundColor = UIColor.clear
				break
			case .failure:
				statusButton.setTitle(EMLocalizable("upload_list_status_continue"), for: .normal)
				statusButton.isEnabled = true
				statusButton.setTitleColor(UIColor.white, for: .normal)
				statusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
				statusButton.cornerRadius = 13
				statusButton.backgroundColor = UIColor.Main
				break
			}
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
			make.left.top.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0))
		}
		
		contentView.addSubview(statusButton)
		statusButton.snp.makeConstraints { make in
			make.centerY.equalTo(titleLab)
			make.right.equalToSuperview().offset(-20)
			make.width.equalTo(68)
			make.height.equalTo(26)
		}
		
		contentView.addSubview(timerLab)
		timerLab.snp.makeConstraints { make in
			make.left.equalTo(titleLab)
			make.top.equalTo(titleLab.snp.bottom).offset(6)
		}
		
		contentView.addSubview(cancelBtn)
		cancelBtn.snp.makeConstraints { make in
			make.right.equalToSuperview().offset(-20)
			make.top.equalTo(statusButton.snp.bottom).offset(20)
			make.width.equalTo(68)
			make.height.equalTo(26)
		}

		contentView.addSubview(progressView)
		progressView.snp.makeConstraints { make in
			make.left.equalTo(titleLab)
			make.top.equalTo(timerLab.snp.bottom).offset(10)
			make.right.equalTo(cancelBtn.snp.left).offset(-37)
			make.height.equalTo(14)
//			make.bottom.equalToSuperview().offset(-20)
		}
		
		contentView.addSubview(line)
		line.snp.makeConstraints { make in
			make.top.equalTo(progressView.snp.bottom).offset(20)
			make.left.right.equalToSuperview()
			make.height.equalTo(4)
			make.bottom.equalToSuperview().offset(0)
		}
		
	}
	
	private lazy var titleLab:UILabel = {
		
		let lab = UILabel.init(frame: .zero)
		lab.textColor = UIColor.B3
		lab.font = UIFont.boldSystemFont(ofSize: 16)
		lab.text = "一号电梯"
		return lab
	}()
	
	private lazy var timerLab:UILabel = {
		
		let lab = UILabel.init(frame: .zero)
		lab.textColor = UIColor.B9
		lab.font = UIFont.boldSystemFont(ofSize: 12)
		lab.text = "上传时间：2020-12-19 12:17"
		return lab
	}()

	private lazy var statusButton:UIButton = {
		
		let btn = UIButton.init(type: .custom)
		btn.setTitleColor(UIColor.B3, for: .normal)
		btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		btn.tag = 2018
		btn.addTarget(self, action: #selector(userAction(sender:)), for: .touchUpInside)
		return btn
	}()
	
	lazy var cancelBtn:UIButton = {
		
		let btn = UIButton.init(type: .custom)
		btn.setTitle(EMLocalizable("upload_list_cancel"), for: .normal)
		btn.setTitleColor(UIColor.Main, for: .normal)
		btn.borderColor = UIColor.Main
		btn.borderWidth = 1
		btn.cornerRadius = 13
		btn.tag = 2017
		btn.addTarget(self, action: #selector(userAction(sender:)), for: .touchUpInside)
		btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
		return btn
	}()
	
	private lazy var progressView: UIProgressView = {
		
		let progress = UIProgressView(progressViewStyle: .default)
		progress.progressTintColor = UIColor.Main
		progress.trackTintColor = UIColor.colorFormHex(0xeaeaea)
		progress.setProgress(0.0, animated: true)
		for tview in progress.subviews {
			tview.layer.cornerRadius = 7
			tview.clipsToBounds = true
		}
		return progress
	}()
	
	private lazy var line:UIView = {
		
		let tView = UIView()
		tView.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
		return tView
	}()
	
	@objc func userAction(sender:UIButton) {
		if sender.tag == 2017 {
			print("取消")
		}
		else if sender.tag == 2018 {
			print("继续")
		}
	}
}

class EMUploadListController: EMBaseViewController,UITableViewDataSource,UITableViewDelegate {
	
	final let CellIdentifier = "UploadListCell"
	
	lazy var tasks:[EMUploadModel] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = EMLocalizable("upload_list_title")
		
		tasks = EMUploadManager.shared.tasks
		if tasks.count > 0 {
			
			EMUploadManager.shared.service?.progressHandler =  { [weak self] progress in
                
                guard let self = self else {
                    return
                }
                if let cell = self.tableView.visibleCells.first as? EMUploadListCell {
                    cell.updateProgress(animated: true, progress: progress)
                }
                
			}
			EMUploadManager.shared.service?.completeHandler = { [weak self] result in
				guard let self = self else {
					return
				}
				self.tasks = EMUploadManager.shared.tasks
				self.tableView.reloadData()
                
                //完成后要将所有进度条置为0，不然有些还没开始的cell会保持100%
                for value in self.tableView.visibleCells {
                    let cell: EMUploadListCell = value as! EMUploadListCell
                    cell.updateProgress(animated: false, progress: 0)
                }
			}
			setupUI()
		}
		
	}
	
	func setupUI() {
		self.view.addSubview(self.tableView)
		self.tableView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(NavigationBarHeight + 6)
			make.left.right.bottom.equalToSuperview()
		}
	}
	
	///MARK: table view data source
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return tasks.count == 0 ? 0 : (tasks.count > 1 ? 2 : 1)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		guard tasks.count != 0 else {
			return 0
		}
		if section == 0 {
			return 1
		}
		return tasks.count - 1
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.01
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 42
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: currentMode_width, height: 42))
		headView.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
		
		let titleLab = UILabel(frame: .zero)
		titleLab.textColor = UIColor.B3
		titleLab.font = UIFont.boldSystemFont(ofSize: 16)
		titleLab.text = EMLocalizable(section == 0 ? "upload_list_section_loading" : "upload_list_section_waitting")
		headView.addSubview(titleLab)
		titleLab.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(20)
			make.centerY.equalToSuperview()
		}
		return headView
	}
	
	///MARK: table view delegate
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:EMUploadListCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! EMUploadListCell
		let model: EMUploadModel = tasks[indexPath.section + indexPath.row]
		
		if indexPath.section == 0 {
			cell.status = model.status == .EMUploading ? .loading : .failure
			cell.progress = model.progress
		} else {
			cell.status = .waiting
		}
		cell.timer = model.uploadTimer
		cell.title = model.name
		return cell
	}
	
	///MARK: lazy
	lazy var tableView:UITableView = {
		let tableView = UITableView.init(frame: .zero, style: .grouped)
		tableView.separatorStyle = .none
		tableView.dataSource = self
		tableView.delegate = self
		tableView.allowsSelection = false
		tableView.backgroundColor = UIColor.white
		tableView.register(EMUploadListCell.self, forCellReuseIdentifier: CellIdentifier)
		return tableView
	}()
    
    deinit {
        NSLog("EMUploadListController deinit")
    }

}
