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

/// 文件上传地址
let uploadFileUrl = PCDBaseURL + "/upload/public/breakpointUpload"
let uploadUnitSize = 1 * 1024 * 1024/5
let EMBoundary = "BoundaryForEMSystem"

enum EMUploadResult {
  case success(path: String)
  case error(Error)
}

class EMBackgroundService: NSObject,URLSessionTaskDelegate,URLSessionDataDelegate {
	
	/// 文件路径
//	var filePath: String!
	var isActivity: Bool = true
	/// 后台会话
	var backgoundSession: URLSession!
    
//    后台任务
    var backgroundTask: URLSessionUploadTask!
	
	/// 服务器返回数据
	var response: NSMutableData!
	
	/// 上传进度
	var progress:Float = 0.0
	
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
	
	/// 初始化backgoundSession
	func setupBackgroundSession() {
		let now = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyyMMddHHMMSS"
		let dateStr = dateFormatter.string(from: now)
		
		let randomIndex = Int(arc4random()%10000)+1
		let configIndentifier = "EM" + dateStr + String(randomIndex)
		
		let configration = URLSessionConfiguration.background(withIdentifier: configIndentifier)
		/// 设置超时时间
		configration.timeoutIntervalForResource = 12*60*60
		backgoundSession = URLSession(configuration: configration, delegate: self, delegateQueue: OperationQueue.main)
	}
	
	private func startUploadFile() {
		
//		setupBackgroundSession()

		model.status = .EMUploading
		
		/// 上传代码
		perform(#selector(uploadUnitWith), with: nil, afterDelay: 2)
		
//		uploadUnitWith()
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
            model.status = .EMUploaded
            EMUploadManager.shared.completeTask()
            return
        }
		
//		let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask, true).first
//		let cachePathUrl = URL(fileURLWithPath: cachePath!)
//		try? FileManager.default.createDirectory(at: cachePathUrl, withIntermediateDirectories: true, attributes: nil)
//
//		let tmpUrl = cachePathUrl.appendingPathComponent("\(unitData.MD5().hexString()).tmp")
//		do {
//			try unitData.write(to: tmpUrl)
//		}catch {
//			print("写入失败")
//		}
				
		let params = uploadParams()
		let keys = params.allKeys;
		var requestPath = uploadFileUrl + "?"
		// 使用query进行参数上传
		for key in keys {
			requestPath = requestPath + "\(key)=\(params[key]!)&"
		}
		
		var request = URLRequest(url: URL(string: requestPath)!)
		request.httpMethod = "POST"
		/// 请求头设置
		let contentType = "multipart/form-data; boundary=\(EMBoundary)"
		request.setValue(contentType, forHTTPHeaderField: "Content-Type")
		
		var uploadData: Data = Data.init()
		
		//改用query进行参数上传 此处为body参数上传
//		let params = uploadParams()
//		let keys = params.allKeys;
//		for key in keys {
//			uploadData.append(String(format:"--%@\r\n",EMBoundary).data(using: .utf8)!)
//			uploadData.append(String(format:"Content-Disposition:form-data;name=\"%@\"\r\n\r\n",key as! String).data(using: .utf8)!)
//			uploadData.append("\(params[key]!)\r\n".data(using: .utf8)!)
//		}
		
		// 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
		uploadData.append("--\(EMBoundary)\r\n".data(using: .utf8)!)
		
		uploadData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(unitData.MD5().hexString()).tmp\"\r\n".data(using: .utf8)!) //multipartFile
		// 文件类型
		uploadData.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
		// 添加文件主体
		uploadData.append(unitData)
		uploadData.append("\r\n--\(EMBoundary)".data(using: .utf8)!)
		
		request.httpBody = uploadData
        
		backgroundTask = backUploadSession.uploadTask(withStreamedRequest: request)
//		let backgroundTask = backgoundSession.uploadTask(with: request, fromFile: tmpUrl)
		backgroundTask.resume()
        NSLog("当前上传切片数\(model.uploadCount)个 ,总切片数 \(model.totalCount)个")
	}
	
	func uploadParams() -> NSDictionary {
		let dict: NSMutableDictionary = NSMutableDictionary.init()
		dict["orderId"] = model.token
		dict["videoName"] = model.videoName
		dict["totalCount"] = model.totalCount
		dict["updaloadCount"] = model.uploadCount + 1
		dict["deviceMac"] = EMDeviceService.deviceUUID
		dict["deviceModel"] = EMDeviceService.deviceModel
		return dict
	}
		
	//MARK: 后台上传Delegate
	//MARK: 进度监控
	func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
		
		let currentProgress:Float = (Float(totalBytesSent)+Float(model.uploadCount*uploadUnitSize)) / Float(model.totalSize)
		model.progress = currentProgress
		progressHandler?(currentProgress)
		NSLog("当前上传总进度\(currentProgress*100)%")
        
	}
	
	
	//MARK: - 后台上传完执行代理方法
	func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        //主线程调用
        EMEventAtMain {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,let completionHandler = appDelegate.handler {
                        appDelegate.handler = nil
                        //调用此方法告诉操作系统，现在可以安全的重新suspend你的app
                        NSLog("执行appDelegate --> completionHandler")

                        completionHandler()
//                     self.uploadUnitWith()

                }
        }
	}
	
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
		if error != nil{
			print("上传error--->\(error!)")
			self.completeHandler?(.error(error!))
			model.status = .EMUploadFailed
		}else{
			if model.uploadCount + 1 == model.totalCount {
				model.status = .EMUploaded
				
				// 此任务完成进行下一个任务
				EMUploadManager.shared.completeTask()
                NSLog("此任务完成进行下一个任务 当前剩余任务数量 --> \(EMUploadManager.shared.tasks.count)")

                self.completeHandler?(.success(path: "upload_url"))

				
				if EMUploadManager.shared.service.isActivity {
					
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
					creatNotificationContent(identifier: model.name!)
				}

			} else {
				//任务数+1
				model.uploadCount += 1
				//清空上次后台返回的数据
				self.response = nil
				//继续下一片上传
                if backgroundTask.state != .canceling{
                    backgroundTask.cancel()
                }
				uploadUnitWith()
			}
		}
	}
	
//	class func deleteFiles(filePaths:[String]) {
//		for filePath in filePaths {
//			try? FileManager.default.removeItem(atPath: filePath)
//		}
//	}
	
}



