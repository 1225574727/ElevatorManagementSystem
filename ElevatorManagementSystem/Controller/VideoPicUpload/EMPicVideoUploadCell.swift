//
//  EMPicVideoUploadCell.swift
//  ElevatorManagementSystem
//
//  Created by 姚李刚 on 2021/12/12.
//

import UIKit

enum EMPicVideoUploadCellType {
	case category
	case textInput
	case videoUpload
	case picUpload
	case noteInput
}

typealias InputCallBack = (_ text: String) -> Void
typealias UpdateCellHeight = (_ currentHeightMultiple: Int) -> Void

class EMPicVideoUploadCell: UITableViewCell {
	
	var inputCallBack:InputCallBack?
	var updateCellHeight:UpdateCellHeight?
	
	var currentPictureMap :[Int: UIImage] = Dictionary()
	var currentSelectPicTag = 3000
	
	//MARK: category
	private lazy var calibrationLabel: UILabel = {
		let lab = UILabel()
		lab.text = "*\(EMLocalizable("upload_record_lab")):"
		lab.font = UIFont.boldSystemFont(ofSize: 14)
		lab.textColor = UIColor.B3
		return lab
	}()
	
	private lazy var doorLabel: UILabel = {
		let lab = UILabel()
		lab.text = "*\(EMLocalizable("upload_part_lab")):"
		lab.font = UIFont.boldSystemFont(ofSize: 14)
		lab.textColor = UIColor.B3
		return lab
	}()
	
	private lazy var calibrationBtn: UIButton = {
		let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 161, height: 60))
		btn.sg.setImage(location: .right, space: 60) { (btn) in
			btn.setImage(UIImage(named: "selected_arrow"), for: .selected)
			btn.setImage(UIImage(named: "deselect_arrow"), for: .normal)
			btn.setTitle(EMLocalizable("record_type"), for: .normal)
			btn.setTitleColor(UIColor.B3, for: .normal)
			btn.setTitleColor(UIColor.Main, for: .selected)
			btn.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
			btn.layer.cornerRadius = 8
			btn.layer.masksToBounds = true
			btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
			btn.tag = 2021
			btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
		}
		return btn
	}()
	
	private  lazy  var doorBtn: UIButton = {
		let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 161, height: 60))
		btn.sg.setImage(location: .right, space: 60) { (btn) in
			btn.setImage(UIImage(named: "selected_arrow"), for: .selected)
			btn.setImage(UIImage(named: "deselect_arrow"), for: .normal)
			btn.setTitle(EMLocalizable("record_type"), for: .normal)
			btn.setTitleColor(UIColor.B3, for: .normal)
			btn.setTitleColor(UIColor.Main, for: .selected)
			btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
			btn.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
			btn.layer.cornerRadius = 8
			btn.layer.masksToBounds = true
			btn.tag = 2022
			btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
		}
		return btn
	}()
	
	//点击事件
	@objc private func didClickButton(sender:UIButton){
		
		NSLog("\(sender.tag)")
		if sender.tag == 2021 { //选择记录类型
			EMAlertService.show(title: nil, message: nil, cancelTitle: EMLocalizable("alert_cancel"), otherTitles:["正常检查", "校准后"] , style: .actionSheet) { title, index in
				NSLog("\(index) ---\(title)")
			}
		}else if sender.tag == 2022 { //零件类别
			EMAlertService.show(title: nil, message: nil, cancelTitle: EMLocalizable("alert_cancel"), otherTitles:["interlock Device Rollers", "厅门"] , style: .actionSheet) { title, index in
				NSLog("\(index) ---\(title)")
			}
		}else if sender.tag == 100 { //拍摄视频上传
			EMPhotoService.shared.showBottomAlert(resourceType: .media) { videoUrl, image in
				
				for subView in self.contentView.subviews {
					
					if subView.isKind(of: UIImageView.self) && subView.tag == 300 {//视频的imageV
						let imageV: UIImageView = subView as! UIImageView
						imageV.image = image as? UIImage
						
						for imageSubView in imageV.subviews {
							
							if imageSubView.isKind(of: UIButton.self) && imageSubView.tag == 100 {//视频的点击按钮
								let uploadBtn :UIButton = imageSubView as! UIButton
								uploadBtn.setImage(UIImage(named: "video_logo"), for: .normal)
								uploadBtn.isEnabled = false
								
							}else if imageSubView.isKind(of: UIButton.self) && imageSubView.tag == 200 {//视频的移除按钮
								let clearBtn :UIButton = imageSubView as! UIButton
								clearBtn.isHidden = false
							}
						}
						
					}
					
				}
			}
			
		}else if sender.tag == 1000 { //1000 拍对应位置照片上传
			
			EMPhotoService.shared.showBottomAlert(resourceType: .photo) { _, image in
				
				let imageViewCount = self.contentView.subviews.count - 1
				
				
				guard imageViewCount > 0 else {
					return
				}
				
				for subView in self.contentView.subviews {
					
					if subView.isKind(of: UIImageView.self) {//照片的imageV
						
						let imageV: UIImageView = subView as! UIImageView
						
						if imageV.image == nil {
							
							imageV.image = image as? UIImage
							
							for imageSubView in imageV.subviews {
								
								if imageSubView.isKind(of: UIButton.self) && imageSubView.tag == 1000 {//照片的点击按钮
									let uploadBtn :UIButton = imageSubView as! UIButton
									uploadBtn.isHidden = true
									
								}else if imageSubView.isKind(of: UIButton.self) && imageSubView.tag == 2000 {//照片的移除按钮
									let clearBtn :UIButton = imageSubView as! UIButton
									clearBtn.isHidden = false
								}
							}
							
							self.currentPictureMap.updateValue(image as! UIImage, forKey: subView.tag)
						}
					}
				}
				
				guard imageViewCount < 9 else {//最多只增加到九张图片
					return
				}
				
				self.updateCellHeight?((imageViewCount + 1) / 3 + ((imageViewCount + 1) % 3 != 0 ? 1 :0))
				
				self.createImageViewIndex(index: imageViewCount)
			}
		}else if sender.tag == 200 { //删除视频
			
			for subView in self.contentView.subviews {
				
				if subView.isKind(of: UIImageView.self) && subView.tag == 300 {//视频的imageV
					let imageV: UIImageView = subView as! UIImageView
					imageV.image = nil
					
					for imageSubView in imageV.subviews {
						
						if imageSubView.isKind(of: UIButton.self) && imageSubView.tag == 100 {//视频的点击按钮
							let uploadBtn :UIButton = imageSubView as! UIButton
							uploadBtn.setImage(UIImage(named: "upload_action_bg"), for: .normal)
							uploadBtn.isEnabled = true
							
						}else if imageSubView.isKind(of: UIButton.self) && imageSubView.tag == 200 {//视频的移除按钮
							let clearBtn :UIButton = imageSubView as! UIButton
							clearBtn.isHidden = true
						}
					}
					
				}
				
			}
			
		}
		else if sender.tag == 2000  {//删除对应位置图片
			
			var imageViewCount = self.contentView.subviews.count - 1
			
			guard imageViewCount > 0 else {//只有一张图片的情况
				
				return
			}
			
			let superView = sender.superview
			
			var allImageViews: [UIImageView] = Array()
			for subView in self.contentView.subviews {
				if subView.isKind(of: UIImageView.self) {
					let imageV: UIImageView = subView as! UIImageView
					allImageViews.append(imageV)
				}
			}
			
			allImageViews.sort {$0.tag < $1.tag}
			
			
			if let imageView = superView, imageView.isKind(of: UIImageView.self) {
				
				if imageViewCount == 1 {
					let imageV: UIImageView = imageView as! UIImageView
					imageV.image = nil
					
					for imageSubView in imageV.subviews {
						
						if imageSubView.isKind(of: UIButton.self) && imageSubView.tag == 1000 {//照片的点击按钮
							let uploadBtn :UIButton = imageSubView as! UIButton
							uploadBtn.setImage(UIImage(named: "upload_action_bg"), for: .normal)
							uploadBtn.isEnabled = true
							
						}else if imageSubView.isKind(of: UIButton.self) && imageSubView.tag == 2000 {//照片的移除按钮
							let clearBtn :UIButton = imageSubView as! UIButton
							clearBtn.isHidden = true
						}
					}
					return
				}
				
				let imageViewIndex = imageView.tag - 3000
				
				imageView.removeFromSuperview()
				
				allImageViews.remove(at: imageViewIndex)
				
				for subView in allImageViews {
					
					if  let index = allImageViews.firstIndex(of: subView) {
						
						let horizontalIndex: Int = index % 3
						let verticalIndex: Int = index / 3
						
						let imageViewWidth = (ScreenInfo.Width - 18 * 4) / 3
						
						
						let masToTop = 10 + (10 + Int(imageViewWidth)) * verticalIndex
						let masToLeft = 18 + (18 + Int(imageViewWidth)) * horizontalIndex
						
						subView.tag = 3000 + index
						
						subView.snp.remakeConstraints { make in
							make.top.equalTo(self.videoTitleLab.snp.bottom).offset(masToTop)
							make.left.equalTo(masToLeft)
							make.width.height.equalTo(imageViewWidth)
						}
						
					}
					
				}
				   
				if (imageViewCount == 9) {

					let last = allImageViews.last
					if let uploadBtn = last?.viewWithTag(1000)  {
						if uploadBtn.isHidden {
							createImageViewIndex(index: 8)
						}
					}
				} else {
					imageViewCount = imageViewCount - 1
				}
				
				self.updateCellHeight?(imageViewCount / 3 + (imageViewCount%3 == 0 ? 0 : 1))
			}
			
		}
		
	}
	
	
	private func createImageViewIndex(index: Int) {
		
		let startUploadTag = 1000
		let startClearTag = 2000
		let startImageViewTag = 3000
		
		let imagV = UIImageView.init(frame: .zero)
		imagV.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
		imagV.isUserInteractionEnabled = true
		imagV.layer.cornerRadius = 8
		imagV.tag = startImageViewTag + index
		imagV.layer.masksToBounds = true
		
		let uploadBtn = UIButton()
		uploadBtn.setImage(UIImage(named: "upload_action_bg"), for: .normal)
		uploadBtn.tag = startUploadTag
		uploadBtn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
		
		let closeBtn = UIButton()
		closeBtn.setImage(UIImage(named: "clear_upload_source"), for: .normal)
		closeBtn.tag = startClearTag
		closeBtn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
		closeBtn.isHidden = true
		
		contentView.addSubview(imagV)
		imagV.addSubview(uploadBtn)
		imagV.addSubview(closeBtn)
		
		let imageViewWidth = (ScreenInfo.Width - 18 * 4) / 3
		
		let horizontalIndex: Int = index % 3
		let verticalIndex: Int = index / 3
		
		let masToTop = 10 + (10 + Int(imageViewWidth)) * verticalIndex
		let masToLeft = 18 + (18 + Int(imageViewWidth)) * horizontalIndex
		
		imagV.snp.makeConstraints { make in
			make.top.equalTo(self.videoTitleLab.snp.bottom).offset(masToTop)
			make.left.equalTo(masToLeft)
			make.width.height.equalTo(imageViewWidth)
		}
		uploadBtn.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.height.equalTo(70)
		}
		closeBtn.snp.makeConstraints { make in
			make.top.equalTo(6)
			make.right.equalTo(-6)
			make.width.height.equalTo(30)
		}
	}
	
	private func setUpChooseTypeUI(){
		contentView.addSubview(self.calibrationLabel)
		contentView.addSubview(self.doorLabel)
		
		contentView.addSubview(self.calibrationBtn)
		contentView.addSubview(self.doorBtn)
		
		self.calibrationLabel.snp.makeConstraints { make in
			make.top.equalTo(10)
			make.left.equalTo(20)
			make.width.equalTo(161)
			make.height.equalTo(20)
		}
		
		self.doorLabel.snp.makeConstraints { make in
			make.top.equalTo(10)
			make.right.equalTo(-20)
			make.width.equalTo(161)
			make.height.equalTo(20)
		}
		
		self.calibrationBtn.snp.makeConstraints { make in
			make.top.equalTo(self.calibrationLabel.snp.bottom).offset(10)
			make.left.equalTo(20)
			make.width.equalTo(161)
			make.height.equalTo(60)
		}
		
		self.doorBtn.snp.makeConstraints { make in
			make.top.equalTo(self.calibrationLabel.snp.bottom).offset(10)
			make.right.equalTo(-20)
			make.width.equalTo(161)
			make.height.equalTo(60)
		}
		
	}
	
	private func setUpNoticeInputUI() {
		
		contentView.addSubview(titleLab)
		titleLab.text = "\(EMLocalizable("upload_remark_lab"))："
		titleLab.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(20)
			make.top.equalToSuperview().offset(10)
		}
		
		let noticeBg = UIView()
		noticeBg.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
		noticeBg.layer.cornerRadius = 8
		contentView.addSubview(noticeBg)
		noticeBg.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20))
			make.top.equalTo(titleLab.snp.bottom).offset(10)
//			make.height.equalTo(170)
		}
		
		noticeBg.addSubview(self.inputText)
		self.inputText.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10))
		}
	}
	
	//MARK: textInput
	
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
	
	
	
	var data:String? {
		didSet {
			textField.text = data
		}
	}
	
	private lazy var titleLab:UILabel = {
		
		let lab = UILabel.init(frame: .zero)
		lab.textColor = UIColor.colorFormHex(0x333333)
		lab.font = UIFont.boldSystemFont(ofSize: 14)
		lab.text = "\(EMLocalizable("manage_dis"))："
		return lab
	}()
	
	private lazy var textField:UITextField = {
		
		let tf = UITextField()
		tf.textColor = UIColor.colorFormHex(0x333333)
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.keyboardType = .decimalPad
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
	
	//MARK: videoUpload && picUpload
	private lazy var videoTitleLab:UILabel = {
		
		let lab = UILabel.init(frame: .zero)
		lab.textColor = UIColor.colorFormHex(0x333333)
		lab.font = UIFont.boldSystemFont(ofSize: 14)
		lab.text = "\(EMLocalizable("upload_video_lab"))："
		return lab
	}()
	
	private lazy var inputText:EMTextView = {
		let tv = EMTextView()
		tv.placeholder = EMLocalizable("upload_remark_placeholder")
		tv.textColor = UIColor.B6
		tv.font = UIFont.systemFont(ofSize: 14)
		tv.backgroundColor = UIColor.clear
		return tv
	}()
	
	//    private lazy var bgImageV: UIImageView = {
	//
	//        let imagV = UIImageView.init(frame: .zero)
	//        imagV.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
	//        imagV.layer.cornerRadius = 8
	//        imagV.layer.masksToBounds = true
	//        return imagV
	//    }()
	//
	//    private lazy var centerBtn: UIButton = {
	//        let btn = UIButton()
	//        btn.setImage(UIImage(named: "upload_action_bg"), for: .normal)
	//        btn.tag = 101
	//        btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
	//        return btn
	//    }()
	//
	//    private lazy var clearBtn: UIButton = {
	//        let btn = UIButton()
	//        btn.setImage(UIImage(named: "clear_upload_source"), for: .normal)
	//        btn.tag = 100
	//        btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
	//        return btn
	//    }()
	
	
	private func setUpVideoOrPicUploadUI(isPic: Bool){
		contentView.addSubview(videoTitleLab)
		videoTitleLab.snp.makeConstraints { make in
			make.top.equalTo(10)
			make.left.equalTo(20)
			make.width.equalTo(161)
			make.height.equalTo(20)
		}
		
		var needUpLoadCount = 1
		var startUploadTag = 100
		var startClearTag = 200
		var startImageViewTag = 300
		
		
		if isPic {
			videoTitleLab.text = "\(EMLocalizable("upload_pic_lab"))："
			needUpLoadCount = 1
			startUploadTag = 1000
			startClearTag = 2000
			startImageViewTag = 3000
		}
		for index in 0..<needUpLoadCount {
			let imagV = UIImageView.init(frame: .zero)
			imagV.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
			imagV.isUserInteractionEnabled = true
			imagV.layer.cornerRadius = 8
			imagV.tag = startImageViewTag
			imagV.layer.masksToBounds = true
			
			let uploadBtn = UIButton()
			uploadBtn.setImage(UIImage(named: "upload_action_bg"), for: .normal)
			uploadBtn.tag = startUploadTag + index
			uploadBtn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
			
			let closeBtn = UIButton()
			closeBtn.setImage(UIImage(named: "clear_upload_source"), for: .normal)
			closeBtn.tag = startClearTag + index
			closeBtn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
			closeBtn.isHidden = true
			
			contentView.addSubview(imagV)
			imagV.addSubview(uploadBtn)
			imagV.addSubview(closeBtn)
			
			let imageViewWidth = (ScreenInfo.Width - 18 * 4) / 3
			
			let horizontalIndex: Int = index % 3
			let verticalIndex: Int = index / 3
			
			let masToTop = 10 + (10 + Int(imageViewWidth)) * verticalIndex
			let masToLeft = 18 + (18 + Int(imageViewWidth)) * horizontalIndex
			
			imagV.snp.makeConstraints { make in
				make.top.equalTo(self.videoTitleLab.snp.bottom).offset(masToTop)
				make.left.equalTo(masToLeft)
				make.width.height.equalTo(imageViewWidth)
			}
			uploadBtn.snp.makeConstraints { make in
				make.center.equalToSuperview()
				make.width.height.equalTo(70)
			}
			closeBtn.snp.makeConstraints { make in
				make.top.equalTo(6)
				make.right.equalTo(-6)
				make.width.height.equalTo(30)
			}
			
		}
		
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.selectionStyle = .none
		
		if reuseIdentifier == EMPicVideoUploadController.kCategoryCell {
			setupUI(type: .category)
		}else if reuseIdentifier == EMPicVideoUploadController.kTextInputCell {
			setupUI(type: .textInput)
		}else if reuseIdentifier == EMPicVideoUploadController.kVideoUploadCell {
			setupUI(type: .videoUpload)
		}else if reuseIdentifier == EMPicVideoUploadController.kPicUploadCell {
			setupUI(type: .picUpload)
		}else if reuseIdentifier == EMPicVideoUploadController.kNoteInputCell {
			setupUI(type: .noteInput)
		}
	}
	
	func setupUI(type: EMPicVideoUploadCellType) -> Void {
		switch type {
		case .category:
			setUpChooseTypeUI()
			break
		case .textInput:
			setupTextFieldUI()
			break
		case .videoUpload:
			setUpVideoOrPicUploadUI(isPic: false)
			break
		case .picUpload:
			setUpVideoOrPicUploadUI(isPic: true)
			break
		case .noteInput:
			setUpNoticeInputUI()
			break
		}
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension EMPicVideoUploadCell :UITextFieldDelegate {
	
	func setupTextFieldUI() {
		
		contentView.addSubview(titleLab)
		titleLab.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(20)
			make.top.equalToSuperview().offset(10)
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
		
		bgView.addSubview(textField)
		textField.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(10)
			make.centerY.equalToSuperview()
			make.right.equalTo(desc.snp.left).offset(-10)
		}
		
	}
	
	///MARK: textField delegate
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		if let handler = inputCallBack {
			handler(textField.text ?? "")
		}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
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
