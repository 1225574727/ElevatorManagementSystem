//
//  EMPicVideoUploadController.swift
//  ElevatorManagementSystem
//
//  Created by ylg on 2021/12/12.
//

import UIKit
import MBProgressHUD

class EMPicVideoUploadController: EMBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    static let kRecordCell = "kRecordCell"
    static let kPartCell = "kPartCell"
    static let kCategoryCell = "kCategoryCell"
    static let kTextInputCell = "kTextInputCell"
    static let kVideoUploadCell = "kVideoUploadCell"
    static let kPicUploadCell = "kPicUploadCell"
    static let kNoteInputCell = "kNoteInputCell"
    
    private let oneCellHeight: CGFloat = ( (ScreenInfo.Width - 18 * 4) / 3 + 10 )
    private var picCellHeightMultiple: Int = 1
    
    var equipmentId: String?
	
	var equipmentName: String!
    //用户输入数据
    //选择记录类型
    var recordTypeId: String?
    
    //零件类别
    var componentTypeId: String?
    
    //门与手机之间的距离
    var doorDistance: String = ""
    
    //图片
    var imageArray: [UIImage]?
    
    //视频
    var videoURL: URL?
    
    //备注
    var remark: String?
    
	var imageResolution: CGSize?

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
        self.title = EMLocalizable("upload_title")
        
        self.automaticallyAdjustsScrollViewInsets = false
        setupUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
	}
	
//	deinit {
//		print("deinit")
//	}
	
    
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
        return EMLanguageSetting.shared.language == .Chinese ? 5 : 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if EMLanguageSetting.shared.language == .Chinese {
            if indexPath.row == 0 || indexPath.row == 1 {
                return 110
            }else if indexPath.row == 2 {
                return  CGFloat(oneCellHeight + 40)
            }else if indexPath.row == 3 {
                return CGFloat(Int(oneCellHeight) * picCellHeightMultiple + 40)
            }else {
                return 210
            }
        }else {
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
                return 110
            }else if indexPath.row == 3 {
                return  CGFloat(oneCellHeight + 40)
            }else if indexPath.row == 4 {
                return CGFloat(Int(oneCellHeight) * picCellHeightMultiple + 40)
            }else {
                return 210
            }
        }
       
    }
    
    ///MARK: table view delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if EMLanguageSetting.shared.language == .Chinese {//中文显示

            if indexPath.row == 0 {
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kCategoryCell) as! EMPicVideoUploadCell
                cell.selectRecordPartCallBack = { [weak self](sysId, type) in
                    
                    guard let self = self else {
                        return
                    }
                    
                    if type == .records {
                        
                        self.recordTypeId = sysId
                        
                    }else {
                        
                        self.componentTypeId = sysId
                        
                    }
                    
					self.changeSubmitButtonStatus()
                }
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1 {
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kTextInputCell) as! EMPicVideoUploadCell
				cell.textField.text = self.doorDistance
                cell.inputCallBack = { [weak self] textString in
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.doorDistance = textString
                    
                }
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 2{
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kVideoUploadCell) as! EMPicVideoUploadCell
                cell.videoSelectCallBack = {[weak self] videoUrl in
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.videoURL = videoUrl
					self.changeSubmitButtonStatus()
                }
                return cell
            }else if indexPath.row == 3 {
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kPicUploadCell) as! EMPicVideoUploadCell
                cell.updateCellHeight = { [weak self] currentHeightMultiple in
                    
                    guard let self = self else {
                        return
                    }
                    self.picCellHeightMultiple = currentHeightMultiple
                    self.tableView.reloadData()
                }
                
                cell.imageSelectCallBack = { [weak self] dataArray in
                    
                    guard let self = self else {
                        return
                    }
                    
					self.imageArray = dataArray
					self.changeSubmitButtonStatus()
                }
                return cell
            }else {
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kNoteInputCell) as! EMPicVideoUploadCell
                
                cell.remarkInputCallBack = { [weak self] textString in
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.remark = textString
                    
                }
                return cell
            }
            
        }else {
            if indexPath.row == 0 {
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kRecordCell) as! EMPicVideoUploadCell
                cell.selectRecordPartCallBack = { [weak self](sysId, type) in
                    
                    guard let self = self else {
                        return
                    }
                    
                    if type == .records {
                        
                        self.recordTypeId = sysId
                        
                    }else {
                        
                        self.componentTypeId = sysId
                        
                    }
					
					self.changeSubmitButtonStatus()
                }
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1 {
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kPartCell) as! EMPicVideoUploadCell
                cell.selectRecordPartCallBack = { [weak self](sysId, type) in
                    
                    guard let self = self else {
                        return
                    }
                    
                    if type == .records {
                        
                        self.recordTypeId = sysId
                        
                    }else {
                        
                        self.componentTypeId = sysId
                        
                    }
                    
					self.changeSubmitButtonStatus()
                }
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 2 {
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kTextInputCell) as! EMPicVideoUploadCell
				cell.textField.text = self.doorDistance
                cell.inputCallBack = { [weak self] textString in
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.doorDistance = textString
                    
                }
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 3{
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kVideoUploadCell) as! EMPicVideoUploadCell
                cell.videoSelectCallBack = {[weak self] videoUrl in
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.videoURL = videoUrl
					self.changeSubmitButtonStatus()
                }
                return cell
            }else if indexPath.row == 4 {
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kPicUploadCell) as! EMPicVideoUploadCell
                cell.updateCellHeight = { [weak self] currentHeightMultiple in
                    
                    guard let self = self else {
                        return
                    }
                    self.picCellHeightMultiple = currentHeightMultiple
                    self.tableView.reloadData()
                }
                
                cell.imageSelectCallBack = { [weak self] dataArray in
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.imageArray = dataArray
					self.changeSubmitButtonStatus()
                }
                return cell
            }else {
                let cell:EMPicVideoUploadCell = tableView.dequeueReusableCell(withIdentifier: EMPicVideoUploadController.kNoteInputCell) as! EMPicVideoUploadCell
                
                cell.remarkInputCallBack = { [weak self] textString in
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.remark = textString
                    
                }
                return cell
            }
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
	
	private func changeSubmitButtonStatus() {
		if self.recordTypeId != nil && self.componentTypeId != nil && ((self.imageArray != nil && self.imageArray!.count > 0) || self.videoURL != nil) {
			
			self.submitBtn.setTitleColor(UIColor.colorFormHex(0xffffff), for: .normal)
			self.submitBtn.backgroundColor = UIColor.Main
		} else {
			
			self.submitBtn.setTitleColor(UIColor.colorFormHex(0x999999), for: .normal)
			self.submitBtn.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
		}
	}
    
    ///MARK: lazy
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EMPicVideoUploadCell.self, forCellReuseIdentifier: EMPicVideoUploadController.kRecordCell)
        tableView.register(EMPicVideoUploadCell.self, forCellReuseIdentifier: EMPicVideoUploadController.kPartCell)
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
        btn.setTitle(EMLocalizable("upload_btn_title"), for: .normal)
        btn.setTitleColor(UIColor.colorFormHex(0x999999), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = 24
        btn.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
        btn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        return btn
    }()
    
    
    @objc func didHandler() {
        view.endEditing(true)
    }
    
    @objc func createAction() {
		
		// 记录类型、零件类别必填
		guard self.recordTypeId != nil && self.componentTypeId != nil && ((self.imageArray != nil && self.imageArray!.count > 0) || self.videoURL != nil) else {
			[EMAlertService .show(title: EMLocalizable("alert_tip"), message: EMLocalizable("upload_required_tip"), cancelTitle: EMLocalizable("alert_sure"), otherTitles: [], style: .alert, closure: { action, index in
				
			})];
			return
		}
		
		imageResolution = nil
        if let imageArr = self.imageArray { // if pics 图片上传
			EMEventAtMain {
				self.showActivity(message: EMLocalizable("upload_image_message"))
			}
			
			let firstImage = imageArray?.first
			imageResolution = firstImage!.size
			
			DispatchQueue.global().async {
				EMPicUploadService.uploadUnitWith(imageArr) { response in
					EMEventAtMain {
						self.hideActivity()
					}
					if response?.code == "200" { //图片上传成功

						//视频上传成功，上传表单信息
						if let array = response?.data {
							let imageString = array.joined(separator: ",")
							self.uploadInfo(images: imageString)
						}

					}
				}
			}
		} else {
			self.uploadInfo(images: nil)
		}
		
    }
	
	func uploadInfo(images:String?) {
		
        var params = ["deviceMac":EMDeviceService.deviceUUID,"deviceModel":EMDeviceService.deviceModel,"status":self.recordTypeId,"componentType":self.componentTypeId,"equipmentId":self.equipmentId,"doorDistance":self.doorDistance,"remark":self.remark]
        
		if let images = images {
			params["imageUrl"] = images
		}
		
        if let videoUrl = self.videoURL {
             let videoInfo = videoInfo(videoUrl)
             params["videoResolution"] = "\(videoInfo["width"]!)x\(videoInfo["height"]!)"
             params["videoFrameRate"] = videoInfo["rate"]
             params["videoBitrate"] = videoInfo["bps"]
		 }
		
		if let imageSize = self.imageResolution {
			params["imageResolution"] = "\(imageSize.width)/\(imageSize.height)"
		}
		 
		///order/insertEquipment -> /order/insertOrder
        EMRequestProvider.request(.defaultRequest(url: "/order/insertOrder", params:params as [String : Any]), model: EMBaseModel.self) { model in
			
			if (model?.code == "200") {
				
				if let videoUrl = self.videoURL {
					
					//获取记录id
					if let recordID = (model?.data as? Dictionary<String, Any>)?["orderId"] as? String {
						let formatter = DateFormatter()
						formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
						let dateString = formatter.string(from: Date())
						
						let videoUploadModel = EMUploadModel.init(name:self.equipmentName!,  videoName:"\(videoUrl.lastPathComponent)", token: recordID, timer: dateString)
						EMUploadManager.shared.addTarget(videoUploadModel)
					}
					
					EMAlertService.showAlertForUploading { index in
						if index == 0 {
							self.navigationController?.popViewController(animated: false)

							if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
								(rootVC as! UINavigationController).pushViewController(EMUploadListController(), animated: true)
							}
						} else {
							self.navigationController?.popViewController(animated: true)
						}
					}
				}
				else {
//					EMAlertService.show(title: EMLocalizable("alert_tip"), message: EMLocalizable("upload_submit_success"), cancelTitle: EMLocalizable("alert_sure"), otherTitles: [], style: .alert) { _, _ in
//						self.navigationController?.popViewController(animated: true)
//					}
					EMAlertService.showAlertForUpload(type: .EMAlertUploadSuccess) { index in
						
						if (index == 0) {
							self.navigationController?.popViewController(animated: true)
						} else {
							self.navigationController?.popToRootViewController(animated: true)
						}
					}
					debugPrint("上传成功")
				}
				
			} else {
				
//				let hudMB = MBProgressHUD.showAdded(to: self.view, animated: true)
//				hudMB.mode = .text
//				hudMB.label.text = EMLocalizable("upload_submit_failure")
//				hudMB.hide(animated: false, afterDelay: 3)
				EMAlertService.showAlertForUpload(type: .EMAlertUploadFailure) { index in
					if index == 0 {
						EMUploadManager.shared.continueTask()
					} else {
						self.navigationController?.popViewController(animated: true)
					}
				}
				debugPrint("上传失败")
			}
		}
		
	}
    
    @objc func cancelAction() {
        print("取消")
        self.navigationController?.popViewController(animated: true)
    }
}
