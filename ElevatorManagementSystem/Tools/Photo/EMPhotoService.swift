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
import AVKit

typealias PhotoHandler = (_ videoUrl: URL?, _ resource:Any)->Void;

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
		EMAlertService.show(title: nil, message: nil, cancelTitle: EMLocalizable("picker_cancel"), otherTitles:[EMLocalizable(resourceType == .photo ? "picker_take_photo" : "picker_take_video"), EMLocalizable(resourceType == .photo ? "picker_select_photo":"picker_select_video")] , style: .actionSheet) { _, index in
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
					
					EMAlertService.show(title: EMLocalizable("alert_tip"), message: EMLocalizable("system_allow_camera"), cancelTitle: EMLocalizable("alert_sure"), otherTitles: nil
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
					EMAlertService.show(title: EMLocalizable("alert_tip"), message: EMLocalizable("system_allow_photo"), cancelTitle: EMLocalizable("alert_sure"), otherTitles: nil
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
			self.handler!(nil, image)
		} else {
			
			let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
			///将视频文件写入沙盒
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			let  timeInterval  = Date().timeIntervalSince1970
			let  timeStamp =  Int (timeInterval)
			let newURL = tmpVideoPath + "/\(timeStamp).mp4"
			
			DispatchQueue.global().async {
				self.copySourceToCache(sourceURL: videoURL, target: URL(fileURLWithPath: newURL)) {
					success in
					if success {
						EMEventAtMain {
							self.handler!(URL(fileURLWithPath: newURL),self.generateVideoScreenshot(videoURL: URL(fileURLWithPath: newURL)))
							//显示设置的照片
							self.parent?.dismiss(animated: true, completion: nil)
						}
					} else {
						print("视频生成失败！！！")
					}
				}
			}
		}
	}
    
    private func generateVideoScreenshot(videoURL: URL) -> UIImage {
	
		do {
			//生成视频截图
		   let avAsset = AVAsset(url: videoURL)
		   let generator = AVAssetImageGenerator(asset: avAsset)
		   generator.appliesPreferredTrackTransform = true
			let time = CMTimeMakeWithSeconds(0.0,preferredTimescale: 600)
			var actualTime:CMTime = CMTimeMake(value: 0,timescale: 0)
			let imageRef:CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
			let frameImg = UIImage(cgImage: imageRef)
			return frameImg
		} catch (_) {
			print("视频生成截图失败")
			return UIImage()
		}
        
    }
	
	private func copySourceToCache(sourceURL: URL, target: URL,relhandler: @escaping (_ isSuccess:Bool)->Void) {
		
		let videoAsset = AVURLAsset(url:sourceURL)
		let composition:AVMutableComposition = AVMutableComposition()

		let audioTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
		let videoTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)!
		
		let assetAudio:AVAssetTrack =  videoAsset.tracks(withMediaType: .audio).first!
		let assetVideo:AVAssetTrack =  videoAsset.tracks(withMediaType: .video).first!
		
		let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration)
		
		try! audioTrack.insertTimeRange(timeRange, of: assetAudio, at: .zero)
		try! videoTrack.insertTimeRange(timeRange, of: assetVideo, at: .zero)
		
		let exportSession:AVAssetExportSession = AVAssetExportSession(asset: composition, presetName:AVAssetExportPreset1280x720)!
		exportSession.outputURL = target
		exportSession.outputFileType = .mp4
		exportSession.exportAsynchronously(completionHandler: {
			
			print("exportSession...",exportSession)
			relhandler(exportSession.status == .completed)
		})
	}
}


