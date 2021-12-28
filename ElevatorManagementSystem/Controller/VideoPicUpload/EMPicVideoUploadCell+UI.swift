//
//  EMPicVideoUploadCell+UI.swift
//  ElevatorManagementSystem
//
//  Created by 姚李刚 on 2021/12/28.
//

import UIKit

//用于设置UI
extension EMPicVideoUploadCell {
    
    //设置UI
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
    
    //选择记录类型 零件类别UI
     func setUpChooseTypeUI(){
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
    
    //门与手机之间的距离UI
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
    
    //视频和图片UI
    func setUpVideoOrPicUploadUI(isPic: Bool){
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
    
    //备注UI
    func setUpNoticeInputUI() {
       
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
       }
       
       noticeBg.addSubview(self.inputText)
       self.inputText.snp.makeConstraints { make in
           make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10))
       }
   }
    
}
