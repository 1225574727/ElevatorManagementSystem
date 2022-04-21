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

enum EMUploadEventType {
	case uploadCancel
	case uploadContinue
}

typealias EMUploadListHanlder = (_ eventType:EMUploadEventType) -> Void

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
//				cancelBtn.isEnabled = false
//				cancelBtn.setTitleColor(UIColor.lightGray, for: .normal)
//				cancelBtn.borderColor = UIColor.lightGray
				break
			case .waiting:
				statusButton.setTitle(EMLocalizable("upload_list_status_waitting"), for: .normal)
				statusButton.isEnabled = false
				statusButton.setTitleColor(UIColor.B3, for: .normal)
				statusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
				statusButton.backgroundColor = UIColor.clear
				cancelBtn.isEnabled = true
				cancelBtn.setTitleColor(UIColor.Main, for: .normal)
				cancelBtn.borderColor = UIColor.Main
				break
			case .failure:
				statusButton.setTitle(EMLocalizable("upload_list_status_continue"), for: .normal)
				statusButton.isEnabled = true
				statusButton.setTitleColor(UIColor.white, for: .normal)
				statusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
				statusButton.cornerRadius = 13
				statusButton.backgroundColor = UIColor.Main
				cancelBtn.isEnabled = true
				cancelBtn.setTitleColor(UIColor.Main, for: .normal)
				cancelBtn.borderColor = UIColor.Main
				break
			}
		}
	}
	
	var eventHandler:EMUploadListHanlder?
	
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
			make.width.equalTo(72)
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

		if let handler = eventHandler {
			
			handler(sender.tag == 2017 ? .uploadCancel : .uploadContinue)
		}
	}
}

class EMUploadListController: EMBaseViewController,UITableViewDataSource,UITableViewDelegate {
	
	final let CellIdentifier = "UploadListCell"
	
	lazy var tasks:[EMUploadModel] = []
	
	lazy var emptyBgImageV: UIImageView = {
		let imageV = UIImageView()
		imageV.image = UIImage(named: "empty_record")
		imageV.isHidden = true
		return imageV
	}()
	
	lazy var emptyTipLabel: UILabel = {
		let label = UILabel()
		label.text = EMLocalizable("no_more_record")
		label.textAlignment = .center
		label.textColor = .B6
		label.font = UIFont.systemFont(ofSize: 18)
		label.isHidden = true
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = EMLocalizable("upload_list_title")
		
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

		tasks = EMUploadManager.shared.tasks
		if tasks.count > 0 {
			
			EMUploadManager.shared.service.progressHandler =  { [weak self] progress in
                
                guard let self = self else {
                    return
                }
                if let cell = self.tableView.visibleCells.first as? EMUploadListCell {
                    cell.updateProgress(animated: true, progress: progress)
                }
                
			}
			EMUploadManager.shared.service.completeHandler = { [weak self] result in
				guard let self = self else {
					return
				}
				self.tasks = EMUploadManager.shared.tasks
				self.tableView.reloadData()
				
				if self.tasks.count == 0 {
					self.emptyBgImageV.isHidden = false
					self.emptyTipLabel.isHidden = false
					self.tableView.isHidden = true
				} else {
					self.emptyBgImageV.isHidden = true
					self.emptyTipLabel.isHidden = true
					self.tableView.isHidden = false
				}
                
//                //完成后要将所有进度条置为0，不然有些还没开始的cell会保持100%
//                for value in self.tableView.visibleCells {
//                    let cell: EMUploadListCell = value as! EMUploadListCell
//                    cell.updateProgress(animated: false, progress: 0)
//                }
			}
			setupUI()
		}
		else {
			emptyBgImageV.isHidden = false
			emptyTipLabel.isHidden = false
			self.tableView.isHidden = true
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
            cell.updateProgress(animated: false, progress: 0)
		}
		cell.eventHandler = {
			[weak self] eventType in
			guard let self = self else {
				return;
			}
			if eventType == .uploadCancel {
				
				let arrIndex = indexPath.section + indexPath.row
				EMUploadManager.shared.tasks.remove(at: arrIndex)
				EMUploadManager.shared.saveTasks()
				if cell.status == .loading {
					EMUploadManager.shared.service.model = EMUploadModel(name: "", videoName: "", token: "", timer: "")
				}
				
				if arrIndex == 0 && EMUploadManager.shared.tasks.count > 0{
					EMUploadManager.shared.continueTask()
				}
				self.tasks = EMUploadManager.shared.tasks
				
				self.tableView.reloadData()
			} else {
				
				EMUploadManager.shared.continueTask()
			}
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
