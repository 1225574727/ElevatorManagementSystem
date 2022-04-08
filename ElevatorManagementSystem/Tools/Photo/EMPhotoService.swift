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
import MBProgressHUD
import HEPhotoPicker

typealias PhotoHandler = (_ videoUrl: URL?, _ resource:Any)->Void;

enum EMResourceType {
	case photo
	case media
}

class EMPhotoService: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HEPhotoPickerViewControllerDelegate {
	
	static let shared = EMPhotoService()
	
	var typeAction: String = ""
	
	var backgroudIdentifier:UIBackgroundTaskIdentifier?
	
	var zipTimer: Timer?
	var copySession: AVAssetExportSession?
	var hudMB: MBProgressHUD = MBProgressHUD()
	// Make sure the class has only one instance
	// Should not init or copy outside
	private override init() {
		super.init()
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
						
						self.typeAction = "camera";
						let  cameraPicker = UIImagePickerController()
						cameraPicker.delegate = self
						cameraPicker.sourceType = .camera
						cameraPicker.mediaTypes = self.resourceType == .photo ? [kUTTypeImage as String]: [kUTTypeMovie as String]
						if self.resourceType == .media {
							cameraPicker.videoQuality = .typeHigh
						}
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
					self.typeAction = "photo"
					if self.resourceType == .media {
						let options = HEPickerOptions.init()
						options.singleVideo = true
						options.mediaType = .video
						options.maxCountOfVideo = 1
						let picker = HEPhotoPickerViewController.init(delegate: self, options: options)
						let nav = UINavigationController.init(rootViewController: picker)
						nav.modalPresentationStyle = .fullScreen
						UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
						return
					}
					let photoPicker =  UIImagePickerController()
					photoPicker.delegate = self
					photoPicker.sourceType = .photoLibrary
					photoPicker.mediaTypes = self.resourceType == .photo ? [kUTTypeImage as String]: [kUTTypeMovie as String]
					photoPicker.modalPresentationStyle = .fullScreen
					//在需要的地方present出来
					UIApplication.shared.keyWindow?.rootViewController?.present(photoPicker, animated: true, completion: nil)
					self.backgroudIdentifier = self.beginBackgroundTask()
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
			
			let image : UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//			image = image.compressImage(maxLength: 100*1024)
			if "camera" == typeAction {
				// 图片保存相册
				UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
			}
			self.handler!(nil, image)
			self.parent?.dismiss(animated: true, completion: nil)
		} else {
			
			if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
				///将视频文件写入沙盒
				let formatter = DateFormatter()
				formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
				let  timeInterval  = Date().timeIntervalSince1970
				let  timeStamp =  Int (timeInterval)
				let newURL = tmpVideoPath + "/\(timeStamp).mp4"
				
				let rootController = UIApplication.shared.keyWindow?.rootViewController
				guard let parent = rootController else {
					NSLog("rootViewController is nil")
					return
				}
				rootController?.dismiss(animated: false, completion: nil)

				if (TARGET_IPHONE_SIMULATOR == 1) {
					self.handler!(videoURL, self.generateVideoScreenshot(videoURL: videoURL))
					return
				}
				hudMB = MBProgressHUD.showAdded(to: parent.view, animated: true)
				hudMB.mode = .text
				hudMB.label.text = "\(EMLocalizable("upload_video_zip"))..."
				
				DispatchQueue.global().async {
					self.copySourceToCache(sourceURL: videoURL, target: URL(fileURLWithPath: newURL)) {
						success in
						EMEventAtMain {
							self.hudMB.hide(animated: true)
						}
						if success {
							EMEventAtMain {
								if "camera" == self.typeAction {
									let videoCompatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(newURL)
									//判断是否可以保存
									if videoCompatible {
										UISaveVideoAtPathToSavedPhotosAlbum(newURL, self, #selector(self.didFinishSavingVideo(videoPath:error:contextInfo:)), nil)
									} else {
										print("该视频无法保存至相册")
									}
								}
															
								self.handler!(URL(fileURLWithPath: newURL),self.generateVideoScreenshot(videoURL: URL(fileURLWithPath: newURL)))
								//显示设置的照片
	//							self.parent?.dismiss(animated: true, completion: nil)
							}
						} else {
							print("视频生成失败！！！")
						}
					}
				}

			}
			else {
				
				let rootController = UIApplication.shared.keyWindow?.rootViewController
				guard let parent = rootController else {
					NSLog("rootViewController is nil")
					return
				}
				rootController?.dismiss(animated: false, completion: nil)
				print("视频获取失败")
			}
			
			if let identifer = self.backgroudIdentifier {
				self.endBackgroundTask(taskID: identifer)
			}

//			let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
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
		
		if (sourceURL.absoluteString.contains("/Application/")) {
			if FileOperation.movingFile(sourceUrl: sourceURL.absoluteString.replacingOccurrences(of: "file://", with: ""), targetUrl: target.absoluteString.replacingOccurrences(of: "file://", with: "")) {

				relhandler(true)
			} else {

				relhandler(false)
			}
			return
		}
		
		let videoAsset = AVURLAsset(url:sourceURL)
		let composition:AVMutableComposition = AVMutableComposition()

		let videoTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)!
		let audioTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!

		if let assetAudio:AVAssetTrack =  videoAsset.tracks(withMediaType: .audio).first , let assetVideo:AVAssetTrack =  videoAsset.tracks(withMediaType: .video).first {
			let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration)

			try! audioTrack.insertTimeRange(timeRange, of: assetAudio, at: .zero)
			try! videoTrack.insertTimeRange(timeRange, of: assetVideo, at: .zero)

			
			let exportSession = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)!
			exportSession.outputURL = target
			exportSession.outputFileType = .mp4
			let composition = fixedComposition(asset: videoAsset)
			if !composition.renderSize.equalTo(.zero) {
				exportSession.videoComposition = composition
			}
			
			exportSession.exportAsynchronously(completionHandler: {
				
				print("code:",exportSession.status.rawValue)
				print("exportSessionError...",exportSession.error)
				relhandler(exportSession.status == .completed)
				self.copySession = nil
				self.zipTimer?.fireDate = Date.distantFuture
			})
			self.copySession = exportSession
			EMEventAtMain {
				if self.zipTimer == nil {
					self.zipTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.zipProgress), userInfo: nil, repeats: true)
					RunLoop.main.add(self.zipTimer!, forMode: .common)
	//				self.zipTimer?.fire()
				} else {
					self.zipTimer?.fireDate = Date.distantPast
				}
			}
		} else {
			relhandler(false)
		}
	}
	
	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

		if error == nil
		{
			print("图片存储成功")
		}
		else
		{
			print("图片存储失败")
		}
	}
	
	@objc func didFinishSavingVideo(videoPath: String, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
			if error != nil{
				print("视频存储失败")
			}else{
				print("视频存储成功")
			}
		}
	
	func beginBackgroundTask() -> UIBackgroundTaskIdentifier {
		return UIApplication.shared.beginBackgroundTask(expirationHandler: {})
	}
	 
	func endBackgroundTask(taskID: UIBackgroundTaskIdentifier) {
		UIApplication.shared.endBackgroundTask(taskID)
	}
	
	func fixedComposition(asset:AVURLAsset) -> AVMutableVideoComposition {
		
		let videoComposition = AVMutableVideoComposition()
		let degrees = degressFromVideoFileWithAsset(asset: asset)
		if degrees != 0 {
			let translateToCenter:CGAffineTransform
			let mixedTransform:CGAffineTransform
			videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
			
			let tracks = asset.tracks(withMediaType: .video)
			if (tracks.count > 0) {
				
				if let videoTrack = tracks.first {
					let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)

					let roateInstruction = AVMutableVideoCompositionInstruction()
					roateInstruction.timeRange = timeRange
					
					let roateLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
					if (degrees == 90) {
						// 顺时针旋转90°
						translateToCenter = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: 0.0)
						mixedTransform = translateToCenter.rotated(by: .pi/2)
						videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.width)
						roateLayerInstruction.setTransform(mixedTransform, at: .zero)
					} else if(degrees == 180){
						// 顺时针旋转180°
						translateToCenter = CGAffineTransform(translationX: videoTrack.naturalSize.width, y: videoTrack.naturalSize.height)
						mixedTransform = translateToCenter.rotated(by: .pi)
						videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.width, height: videoTrack.naturalSize.height)
						roateLayerInstruction.setTransform(mixedTransform, at: .zero)
					} else if(degrees == 270){
						// 顺时针旋转270°
						translateToCenter = CGAffineTransform(translationX:0.0, y: videoTrack.naturalSize.width)
						mixedTransform = translateToCenter.rotated(by: .pi / 2 * 3.0)
						videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.width)
						roateLayerInstruction.setTransform(mixedTransform, at: .zero)
					}
					roateInstruction.layerInstructions = [roateLayerInstruction];
					videoComposition.instructions = [roateInstruction];
				}
			}
		}
		return videoComposition
	}
	
	func degressFromVideoFileWithAsset(asset: AVAsset) -> Int {
		var degress:Int = 0
		let tracks = asset.tracks(withMediaType: .video)
		if (tracks.count > 0) {
			let videoTrack = tracks.first
			
			if let t = videoTrack?.preferredTransform {
				if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
					// Portrait
				   degress = 90
			   }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
				   // PortraitUpsideDown
				   degress = 270
			   }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
				   // LandscapeRight
				   degress = 0
			   }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
				   // LandscapeLeft
				   degress = 180
			   }
			}
		}
		return degress
	}
	
	//MARK: HEPhoto Delegate
	func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage],selectedModel:[HEPhotoAsset]) {
		// 实现多次累加选择时，需要把选中的模型保存起来，传给picker
//		self.selectedModel = selectedModel
//		self.visibleImages = selectedImages
		if let asset = selectedModel.first?.asset {
			
			let imageRequestOption = PHVideoRequestOptions()
			imageRequestOption.version = .current
			imageRequestOption.deliveryMode = .highQualityFormat
			
			PHCachingImageManager().requestAVAsset(forVideo: asset, options:nil, resultHandler: { (asset, audioMix, info)in

				EMEventAtMain {
					let rootController = UIApplication.shared.keyWindow?.rootViewController
					guard let parent = rootController else {
						NSLog("rootViewController is nil")
						return
					}
					rootController?.dismiss(animated: false, completion: nil)

					self.hudMB = MBProgressHUD.showAdded(to: parent.view, animated: true)
					self.hudMB.mode = .text
					self.hudMB.label.text = "\(EMLocalizable("upload_video_zip"))..."

					let  avAsset = asset as? AVURLAsset
					if let videoURL = avAsset?.url {
						print(videoURL)
						///将视频文件写入沙盒
						let formatter = DateFormatter()
						formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
						let  timeInterval  = Date().timeIntervalSince1970
						let  timeStamp =  Int (timeInterval)
						let newURL = tmpVideoPath + "/\(timeStamp).mp4"

						DispatchQueue.global().async {
							self.copySourceToCache(sourceURL: videoURL, target: URL(fileURLWithPath: newURL)) {
								success in
								EMEventAtMain {
									self.hudMB.hide(animated: true)

									if success {

										self.handler!(URL(fileURLWithPath: newURL),self.generateVideoScreenshot(videoURL: URL(fileURLWithPath: newURL)))
									} else {
										print("视频生成失败！！！")
									}
								}
							}
						}
					}
				}

			})
		}
	}
	func pickerControllerDidCancel(_ picker: UIViewController) {
		// 取消选择后的一些操作
	}
	
	@objc func zipProgress() {
		
		if let tmpSession = copySession {
//			hudMB.progress = tmpSession.progress
//			print("视频生成中\(tmpSession.progress)...")
//			return
			let progress = tmpSession.progress * 100
			hudMB.label.text = "\(EMLocalizable("upload_video_zip"))\(String(format: "%.0f", Float(progress)))%..."
		}
	}
}


