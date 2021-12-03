//
//  EMPhotoService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/3.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import MobileCoreServices

typealias PhotoHandler = (_ resource:Any)->Void;

enum EMResourceType {
	case photo
	case media
}

class EMPhotoService: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	
	static let shared = EMPhotoService()
		
	// Make sure the class has only one instance
	// Should not init or copy outside
	private override init() {
	}
	
	override func copy() -> Any {
		return self // SingletonClass.shared
	}
	
	override func mutableCopy() -> Any {
		return self // SingletonClass.shared
	}
	
	// Optional
	func reset() {
		// Reset all properties to default value
	}
	
	private var parent = UIApplication.shared.keyWindow?.rootViewController
	
	var handler:PhotoHandler?
	var resourceType:EMResourceType = .photo
	
	func showBottomAlert(resourceType:EMResourceType, _ handler:@escaping PhotoHandler) {
		
		self.resourceType = resourceType
		self.handler = handler
		EMAlertService.show(title: nil, message: nil, cancelTitle: "取消", otherTitles:[resourceType == .photo ? "相机" : "拍摄", "选择\(resourceType == .photo ? "图片":"视频")"] , style: .actionSheet) { _, index in
			switch (index) {
			case 1:
				self.takeCamera()
				break
			case 2:
				self.tabkePhoto()
				break
			default:
				break
			}
		}
	}
	
	func takeCamera(){
					
		if UIImagePickerController.isSourceTypeAvailable(.camera){
			
			AVCaptureDevice.requestAccess(for: AVMediaType.video) { ist in
				let status:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
				if status == AVAuthorizationStatus.authorized {
					
					EMEventAtMain {
						
						let  cameraPicker = UIImagePickerController()
						cameraPicker.delegate = self
						cameraPicker.sourceType = .camera
						cameraPicker.mediaTypes = self.resourceType == .photo ? [kUTTypeImage as String]: [kUTTypeMovie as String]
						self.parent?.present(cameraPicker, animated: true, completion: nil)
					}
				} else {
					
					EMAlertService.show(title: "温馨提示", message: "app需要授权使用您的相机", cancelTitle: "确认", otherTitles: nil
										, style: .alert) { _, index in
					}
				}
			}
			
		} else {
			
			print("不支持拍照")
		}
	}
	
	func tabkePhoto() {
		PHPhotoLibrary.requestAuthorization { status in
			switch status {
			case .notDetermined,.restricted,.denied:
				EMEventAtMain {
					EMAlertService.show(title: "温馨提示", message: "app需要授权使用您的相册", cancelTitle: "确认", otherTitles: nil
										, style: .alert) { _, index in
					}
				}
				break
			case .authorized://已经有权限
				EMEventAtMain {
					let photoPicker =  UIImagePickerController()
					photoPicker.delegate = self
			//		photoPicker.allowsEditing = true
					photoPicker.sourceType = .photoLibrary
					photoPicker.mediaTypes = self.resourceType == .photo ? [kUTTypeImage as String]: [kUTTypeMovie as String] //["public.image"]:["public.movie"]
					//在需要的地方present出来
					UIApplication.shared.keyWindow?.rootViewController?.present(photoPicker, animated: true, completion: nil)
				}
				break
			case .limited:
				break
			@unknown default: break
			}
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		if (info.keys.contains(UIImagePickerController.InfoKey.originalImage)) {
			
			var image : UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
			image = image.compressImage(maxLength: 100*1024)
			self.handler!(image)
		} else {
			
			let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
			self.handler!(videoURL)
		}

		//显示设置的照片
		self.parent?.dismiss(animated: true, completion: nil)
	}
}
