//
//  EMPicVideoUploadCell+VideoPic.swift
//  ElevatorManagementSystem
//
//  Created by ylg on 2021/12/28.
//

import UIKit

//用于操作视频和图片的拍摄
extension EMPicVideoUploadCell {
    
    
    //拍摄视频
    func shootingVideo() {
        
        EMPhotoService.shared.showBottomAlert(resourceType: .media) { [weak self] videoUrl, image in
            
            guard let self = self else {
                return
            }
            
            self.videoSelectCallBack?(videoUrl)
            
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
    }
    
    //拍摄图片
    func shootingPicture() {
        EMPhotoService.shared.showBottomAlert(resourceType: .photo) { [weak self] _, image in
            
			guard let self = self else {
				return
			}
			
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
                        
                        self.currentPictureMap.append(image as! UIImage)
                        self.imageSelectCallBack?(self.currentPictureMap)

                    }
                }
            }
            
            guard imageViewCount < 9 else {//最多只增加到九张图片
                return
            }
            
            self.updateCellHeight?((imageViewCount + 1) / 3 + ((imageViewCount + 1) % 3 != 0 ? 1 :0))
            
            self.createImageViewIndex(index: imageViewCount)
        }
    }
    
    func createImageViewIndex(index: Int) {
        
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
    
    //删除视频
    func deleteVideo() {
        
        self.videoSelectCallBack?(nil)

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
    
//    删除图片
    func deletePicture(sender: UIButton) {
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
            
            self.currentPictureMap.remove(at: imageViewIndex)
            self.imageSelectCallBack?(self.currentPictureMap)
            
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
