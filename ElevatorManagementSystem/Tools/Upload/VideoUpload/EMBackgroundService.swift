//
//  EMBackgroundService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/11/9.
//

import Foundation
import SwiftyJSON
import MBProgressHUD
import UIKit
import Alamofire
import Moya
import HandyJSON

/// 文件上传地址
let uploadFileUrl = PCDBaseURL + "/upload/public/breakpointUpload"
let uploadUnitSize = 1 * 1024 * 1024
let EMBoundary = "BoundaryForEMSystem"

enum EMUploadResult {
  case success(path: String)
  case error(Error)
}

class EMBackgroundService: NSObject,URLSessionTaskDelegate,URLSessionDataDelegate {
	
	/// 服务器返回数据
	var response: NSMutableData!
	
	var model:EMUploadModel!
	
	var progressHandler:((Float)->())?
	var completeHandler:((EMUploadResult)->())?
		
	func upload() {
		upload { _ in
			
		} completeHandler: { _ in
			
		}
	}
	
	func upload(progressHandler:@escaping ((Float)->()), completeHandler:@escaping ((EMUploadResult)->())) {
		
		if let loadingModel = EMUploadManager.shared.loadingModel {
			self.model = loadingModel
//			self.progressHandler = progressHandler
//			self.completeHandler = completeHandler
			startUploadFile()
		} else {
			NSLog("上传任务为空")
		}
	}
		
	private func startUploadFile() {
	
		model.status = .EMUploading
		
		/// 上传代码
		uploadUnitWith()
	}
	
	@objc func uploadUnitWith() {
		
        var unitData: Data = Data()
        
        do {
            //强制try! 如果文件不存在会导致APP crash
            let handle:FileHandle = try FileHandle.init(forReadingFrom: URL(string: model.resFilePath)!)
            handle.seek(toFileOffset: UInt64(model.uploadCount*uploadUnitSize))
            unitData = handle.readData(ofLength: uploadUnitSize)
            handle.closeFile()
        } catch (let error) {
            NSLog("FileHandle 文件失败  error\(error)")
            model.status = .EMUploadFailed
            return
        }
				
		let params = uploadParams()
		let keys = params.keys;
		var requestPath = uploadFileUrl + "?"
		// 使用query进行参数上传
		for key in keys {
			requestPath = requestPath + "\(key)=\(params[key]!)&"
		}
		//        uploadData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(unitData.MD5().hexString()).tmp\"\r\n".data(using: .utf8)!) //multipartFile
//		let upLoadRequest = Alamofire.AF.upload(unitData, to: requestPath)
		let upLoadRequest = Alamofire.AF.upload(multipartFormData: { formData in
			formData.append(unitData, withName: "file", fileName: "\(unitData.MD5().hexString()).tmp", mimeType: "application/octet-stream")
		}, to: requestPath)
		upLoadRequest.response { [weak self] data in
			guard let self = self else {
				return
			}
			//上传结束后其他操作
			if let error = data.error {
				print("上传error--->\(error)")
				self.completeHandler?(.error(error))
				self.model.status = .EMUploadFailed
			} else {
				
				if self.model.uploadCount + 1 == self.model.totalCount {
					if case let .success(response) = data.result {
						
						if response != nil {
							let json = JSON(response)
							print("response:\(json)")
						}
					}
					// 如何获取data中后台返回的信息
					self.model.status = .EMUploaded
					
					// 此任务完成进行下一个任务
					EMUploadManager.shared.completeTask()
					print("任务\(self.model.name!)完成上传，剩余任务数量 --> \(EMUploadManager.shared.tasks.count)")
					
	                self.completeHandler?(.success(path: "upload_url"))
					
					if EMUploadManager.shared.isActivity {
						EMEventAtMain {
							let rootController = UIApplication.shared.keyWindow?.rootViewController
							guard let parent = rootController else {
								NSLog("rootViewController is nil")
								return
							}
							rootController?.dismiss(animated: false, completion: nil)
	
							let hudMB = MBProgressHUD.showAdded(to: parent.view, animated: true)
							hudMB.mode = .text
							hudMB.label.text = "任务\(self.model.name!)完成上传"
	
							hudMB.hide(animated: true, afterDelay: 2)
						}
					} else {
						creatNotificationContent(identifier: self.model.name!)
					}
					
					EMEventAtMain {
						if let rootVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
							let vc = rootVC.viewControllers.last!
							if (vc.isKind(of: EMPicVideoUploadController.self)) {
								rootVC.popViewController(animated: false)
							}
						}
					}
						
				} else {
					
					NSLog("切片\(self.model.uploadCount)上传已完成")
					//任务数+1
					self.model.uploadCount += 1
					//继续下一片上传
					self.uploadUnitWith()
				}
			}
		}
		upLoadRequest.uploadProgress { [weak self] (progress) in
			guard let self = self else {
				return
			}
			// 上传进度
			var currentProgress:Float = (Float(uploadUnitSize)+Float(self.model.uploadCount*uploadUnitSize)) / Float(self.model.totalSize)
			if currentProgress > 1.0 {
				currentProgress = 1.0
			}
			self.model.progress = currentProgress
			print("当前进度\(currentProgress*100)%")
		}
		NSLog("切片\(model.uploadCount)开始上传 ,总切片 \(model.totalCount)个")
	}
	
	func uploadParams() -> Dictionary<String, Any> {
		var dict = Dictionary<String, Any>.init()
		dict["orderId"] = model.token
		dict["videoName"] = model.videoName
		dict["totalCount"] = model.totalCount
		dict["updaloadCount"] = model.uploadCount + 1
		dict["deviceMac"] = EMDeviceService.deviceUUID
		dict["deviceModel"] = EMDeviceService.deviceModel
		return dict
	}
}



