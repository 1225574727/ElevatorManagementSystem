//
//  EMPicVideoUploadCell.swift
//  ElevatorManagementSystem
//
//  Created by ylg on 2021/12/12.
//

import UIKit

enum EMPicVideoUploadCellType {
    case record
    case part
	case category
	case textInput
	case videoUpload
	case picUpload
	case noteInput
}

typealias SelectRecordPartCallBack = (_ sysID: String, _ type: EMPubType) -> Void
typealias InputCallBack = (_ text: String) -> Void
typealias VideoSelectCallBack = (_ videoUrl: URL?) -> Void
typealias ImageSelectCallBack = (_ imageArray: [UIImage]) -> Void
typealias RemarkInputCallBack = (_ text: String) -> Void
typealias UpdateCellHeight = (_ currentHeightMultiple: Int) -> Void

class EMPicVideoUploadCell: UITableViewCell {
	
    var selectRecordPartCallBack:SelectRecordPartCallBack?
	var inputCallBack:InputCallBack?
    var videoSelectCallBack: VideoSelectCallBack?
    var imageSelectCallBack:ImageSelectCallBack?
    var remarkInputCallBack: RemarkInputCallBack?

	var updateCellHeight:UpdateCellHeight?
	
	var currentPictureMap :[UIImage] = Array()
    
	var currentSelectPicTag = 3000
	
	//MARK: category
	 lazy var calibrationLabel: UILabel = {
		let lab = UILabel()
		lab.text = "*\(EMLocalizable("upload_record_lab")):"
		lab.font = UIFont.boldSystemFont(ofSize: 14)
		lab.textColor = UIColor.B3
		return lab
	}()
	
	 lazy var doorLabel: UILabel = {
		let lab = UILabel()
		lab.text = "*\(EMLocalizable("upload_part_lab")):"
		lab.font = UIFont.boldSystemFont(ofSize: 14)
		lab.textColor = UIColor.B3
		return lab
	}()
    
    lazy var selectCaliLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.B3
        return lab
    }()
    
    lazy var selectDoorLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.B3
        return lab
    }()
	
	 lazy var calibrationBtn: UIButton = {
		let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 161, height: 60))
//        btn.setTitle(EMLocalizable("record_type"), for: .normal)
        btn.setTitleColor(UIColor.B3, for: .normal)
        btn.setTitleColor(UIColor.Main, for: .selected)
        btn.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tag = 2021
        btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
         
         
         let arrowImageV = UIImageView()
         arrowImageV.image = UIImage(named: "deselect_arrow")
         btn.addSubview(arrowImageV)
         arrowImageV.snp.makeConstraints { make in
             make.top.equalTo(15)
             make.right.equalTo(-5)
             make.width.height.equalTo(30)
         }
         
         btn.addSubview(selectCaliLabel)
        selectCaliLabel.snp.makeConstraints { make in
             make.top.equalTo(15)
            make.left.equalTo(10)
            make.right.equalTo(arrowImageV.snp.left).offset(0)
             make.height.equalTo(30)
         }
		return btn
	}()
	
	  lazy  var doorBtn: UIButton = {
		let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 161, height: 60))
//        btn.setTitle(EMLocalizable("upload_part_lab"), for: .normal)
        btn.setTitleColor(UIColor.B3, for: .normal)
        btn.setTitleColor(UIColor.Main, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 0)
        btn.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.tag = 2022
        btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
          
          let arrowImageV = UIImageView()
          arrowImageV.image = UIImage(named: "deselect_arrow")
          btn.addSubview(arrowImageV)
          arrowImageV.snp.makeConstraints { make in
              make.top.equalTo(15)
              make.right.equalTo(-5)
              make.width.height.equalTo(30)
          }
          
          btn.addSubview(selectDoorLabel)
          selectDoorLabel.snp.makeConstraints { make in
               make.top.equalTo(15)
              make.left.equalTo(10)
              make.right.equalTo(arrowImageV.snp.left).offset(0)
               make.height.equalTo(30)
           }
          
		return btn
	}()
	
	
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
	
	 lazy var titleLab:UILabel = {
		
		let lab = UILabel.init(frame: .zero)
		lab.textColor = UIColor.colorFormHex(0x333333)
		lab.font = UIFont.boldSystemFont(ofSize: 14)
		lab.text = "\(EMLocalizable("manage_dis"))："
		return lab
	}()
	
	 lazy var textField:UITextField = {
		
		let tf = UITextField()
		tf.textColor = UIColor.colorFormHex(0x333333)
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.keyboardType = .decimalPad
		tf.delegate = self
		return tf
	}()
	
	 lazy var desc:UILabel = {
		
		let lab = UILabel()
		lab.text = "CM"
		lab.font = UIFont.systemFont(ofSize: 14)
		lab.textColor = UIColor.B3
		return lab
	}()
	
	//MARK: videoUpload && picUpload
    lazy var videoTitleLab:UILabel = {
		
		let lab = UILabel.init(frame: .zero)
		lab.textColor = UIColor.colorFormHex(0x333333)
		lab.font = UIFont.boldSystemFont(ofSize: 14)
		lab.text = "\(EMLocalizable("upload_video_lab"))："
		return lab
	}()
	
	lazy var inputText:EMTextView = {
		let tv = EMTextView()
		tv.delegate = self
		tv.placeholder = EMLocalizable("upload_remark_placeholder")
		tv.textColor = UIColor.B6
		tv.font = UIFont.systemFont(ofSize: 14)
		tv.backgroundColor = UIColor.clear
		return tv
	}()
	
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.selectionStyle = .none
        if reuseIdentifier == EMPicVideoUploadController.kRecordCell {
            setupUI(type: .record)
        }else if reuseIdentifier == EMPicVideoUploadController.kPartCell {
            setupUI(type: .part)
        }else if reuseIdentifier == EMPicVideoUploadController.kCategoryCell {
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
    
    //点击事件
    @objc func didClickButton(sender:UIButton){
        
        NSLog("\(sender.tag)")
        if sender.tag == 2021 { //选择记录类型
            
            chooseRecordOrPart(type: .records)
            
        }else if sender.tag == 2022 { //零件类别
            
            chooseRecordOrPart(type: .part)
            
        }else if sender.tag == 100 { //拍摄视频上传
            
            shootingVideo()
            
        }else if sender.tag == 1000 { //1000 拍对应位置照片上传
            
            shootingPicture()
            
        }else if sender.tag == 200 { //删除视频
            
            deleteVideo()
            
        }
        else if sender.tag == 2000  {//删除对应位置图片
            
            deletePicture(sender: sender)
        }
        
    }
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		print("cell 释放-\(self.reuseIdentifier!)")
		if currentPictureMap.count > 0 {
			currentPictureMap.removeAll()
		}
	}
	
}


