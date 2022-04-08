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
	
	/// 后台会话
	var backgoundSession: URLSession!
	
//    后台任务
	var backgroundTask: URLSessionUploadTask!

	var backgroudIdentifier:UIBackgroundTaskIdentifier?
	
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
		backgroudIdentifier = beginBackgroundTask()

		/// 上传代码
		uploadUnitWith()
	}
	
	@objc func uploadUnitWith() {
		
		EMReachabilityService.netWorkReachability { status in
			print("\(status)")
			if status == .notReachable {
				self.model.status = .EMUploadFailed
			} else {
				var unitData: Data = Data()
				let path = tmpVideoPath + "/" + self.model.videoName
				print("文件-\(path)---\(FileManager.default.fileExists(atPath: path) ? "存在" : "不存在")")
				do {
					//强制try! 如果文件不存在会导致APP crash
					let handle:FileHandle = try FileHandle.init(forReadingFrom: URL(string: path)!)
					handle.seek(toFileOffset: UInt64(self.model.uploadCount*uploadUnitSize))
					unitData = handle.readData(ofLength: uploadUnitSize)
					handle.closeFile()
				} catch (let error) {
					NSLog("FileHandle 文件失败  error\(error)")
					/// 文件已丢失，移除任务
					self.model.status = .EMUploaded
					EMUploadManager.shared.completeTask()
					EMUploadManager.shared.saveTasks()
					return
				}
						
				let params = self.uploadParams()
				let keys = params.keys;
				var requestPath = uploadFileUrl + "?"
				// 使用query进行参数上传
				for key in keys {
					requestPath = requestPath + "\(key)=\(params[key]!)&"
				}
				/// -----Alamofire-------
		//		let upLoadRequest = Alamofire.AF.upload(unitData, to: requestPath)
		//		let upLoadRequest = AF.upload(multipartFormData: { formData in
		//			formData.append(unitData, withName: "file", fileName: "\(unitData.MD5().hexString()).tmp", mimeType: "application/octet-stream")
		//		}, to: requestPath)
		//		upLoadRequest.response { [weak self] data in
		//			guard let self = self else {
		//				return
		//			}
		//			//上传结束后其他操作
		//			self.dealResponse(data)
		//		}
		//		upLoadRequest.uploadProgress { [weak self] (progress) in
		//			guard let self = self else {
		//				return
		//			}
		//			// 上传进度
		//			self.dealProgress()
		//		}
				/// -----URLRequest-------
				var request = URLRequest(url: URL(string: requestPath)!)
				request.httpMethod = "POST"
				/// 请求头设置
				let contentType = "multipart/form-data; boundary=\(EMBoundary)"
				request.setValue(contentType, forHTTPHeaderField: "Content-Type")
				var uploadData: Data = Data.init()
						
				// 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
				uploadData.append("--\(EMBoundary)\r\n".data(using: .utf8)!)
				
				let formatter = DateFormatter()
				formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
				let  timeInterval  = Date().timeIntervalSince1970
				let  timeStamp =  Int (timeInterval)
				uploadData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(timeStamp).tmp\"\r\n".data(using: .utf8)!) //multipartFile
				// 文件类型
				uploadData.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
				// 添加文件主体
				uploadData.append(unitData)
				uploadData.append("\r\n--\(EMBoundary)".data(using: .utf8)!)
				
				request.httpBody = uploadData
				self.backgroundTask = self.backUploadSession.uploadTask(withStreamedRequest: request)
				self.backgroundTask.resume()
				NSLog("切片\(self.model.uploadCount)开始上传 ,总切片 \(self.model.totalCount)个")

			}
		}
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
	
//	func dealResponse(_ data:AFDataResponse<Data?>) {
//		if let error = data.error {
//			print("上传error--->\(error)")
//			self.completeHandler?(.error(error))
//			self.model.status = .EMUploadFailed
//		} else {
//
//			if self.model.uploadCount + 1 == self.model.totalCount {
//				if case let .success(response) = data.result {
//
//					if response != nil {
//						let json = JSON(response!)
//						print("服务端返回数据  response:\(json)")
//					}
//				}
//				// 如何获取data中后台返回的信息
//				self.model.status = .EMUploaded
//
//				// 此任务完成进行下一个任务
//				EMUploadManager.shared.completeTask()
//				print("任务\(self.model.name!)完成上传，剩余任务数量 --> \(EMUploadManager.shared.tasks.count)")
//
//				self.completeHandler?(.success(path: "upload_url"))
//
//				if EMUploadManager.shared.isActivity {
//					EMEventAtMain {
//						let rootController = UIApplication.shared.keyWindow?.rootViewController
//						guard let parent = rootController else {
//							NSLog("rootViewController is nil")
//							return
//						}
//						rootController?.dismiss(animated: false, completion: nil)
//
//						let hudMB = MBProgressHUD.showAdded(to: parent.view, animated: true)
//						hudMB.mode = .text
//						hudMB.label.text = "任务\(self.model.name!)完成上传"
//
//						hudMB.hide(animated: true, afterDelay: 2)
//					}
//				} else {
//					creatNotificationContent(identifier: self.model.name!)
//				}
//
//				EMEventAtMain {
//					if let rootVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
//						let vc = rootVC.viewControllers.last!
//						if (vc.isKind(of: EMPicVideoUploadController.self)) {
//							rootVC.popViewController(animated: false)
//						}
//					}
//				}
//
//			} else {
//
//				NSLog("切片\(self.model.uploadCount)上传已完成")
//				//任务数+1
//				self.model.uploadCount += 1
//				//继续下一片上传
//				self.uploadUnitWith()
//			}
//		}
//	}
	func dealResponse(_ error:Error?) {
		if let error = error {
			if let identifer = self.backgroudIdentifier {
				self.endBackgroundTask(taskID: identifer)
			}
			print("上传error--->\(error)")
			self.completeHandler?(.error(error))
			self.model.status = .EMUploadFailed
		} else {
			
			if self.model.uploadCount + 1 == self.model.totalCount {
				if let identifer = self.backgroudIdentifier {
					self.endBackgroundTask(taskID: identifer)
				}

				// 如何获取data中后台返回的信息
				self.model.status = .EMUploaded
				// 此任务完成进行下一个任务
				EMUploadManager.shared.completeTask()
				FileOperation.removeFile(sourceUrl: self.model.resFilePath)
				print("任务\(self.model.name!)完成上传，剩余任务数量 --> \(EMUploadManager.shared.tasks.count)")
				let model = self.model
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
						hudMB.label.text = EMLocalizable("task_upload_success_task") + self.model.name + EMLocalizable("task_upload_success_done")

						hudMB.hide(animated: true, afterDelay: 5)
					}
				} else {
					creatNotificationContent(identifier: self.model.name!)
				}
				
				EMEventAtMain {
					if let rootVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
						let vc = rootVC.viewControllers.last!
						if (vc.isKind(of: EMPicVideoUploadController.self)) {
							let videoVC = vc as! EMPicVideoUploadController
							if videoVC.videoURL?.absoluteString == model?.resFilePath {
								rootVC.popViewController(animated: false)
							}
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
		EMUploadManager.shared.saveTasks()
	}
	func dealProgress() {
		var currentProgress:Float = (Float(uploadUnitSize)+Float(self.model.uploadCount*uploadUnitSize)) / Float(self.model.totalSize)
		if currentProgress > 1.0 {
			currentProgress = 1.0
		}
		self.progressHandler?(currentProgress)
		self.model.progress = currentProgress
		print("当前进度\(currentProgress*100)%")
	}
	
	lazy var backUploadSession: URLSession = {
			//只执行一次
			let now = Date()
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyyMMddHHMMSS"
			let dateStr = dateFormatter.string(from: now)
			
			let randomIndex = Int(arc4random()%10000)+1
			let configIndentifier = "EM" + dateStr + String(randomIndex)
			
			let configration = URLSessionConfiguration.background(withIdentifier: configIndentifier)
			let currentSession = URLSession(configuration: configration, delegate: self, delegateQueue: OperationQueue.main)
			return currentSession
	}()
	
	//MARK: 接收返回的数据
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		
		if self.response == nil {
			let resposeData = NSMutableData(data: data)
			self.response = resposeData
			let json = JSON(data)
			NSLog("服务端返回结果--> \(json)")

		}else{
			self.response.append(data)
		}
	}
	
	//MARK: - 上传结束操作，不管是否成功都会调用
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		
		//上传结束后其他操作
		self.dealResponse(error)
	}
	
	//MARK: 进度监控
	func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
		
		self.dealProgress()
	}
	
	//MARK: - 后台上传完执行代理方法
//	func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//
//		//上传结束后其他操作
//		self.dealResponse(nil)
//	}
	
	func beginBackgroundTask() -> UIBackgroundTaskIdentifier {
		return UIApplication.shared.beginBackgroundTask(expirationHandler: {})
	}
	 
	func endBackgroundTask(taskID: UIBackgroundTaskIdentifier) {
		UIApplication.shared.endBackgroundTask(taskID)
	}

}



