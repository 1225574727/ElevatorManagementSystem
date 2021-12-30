//
//  EMBackgroundService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/11/9.
//

import Foundation
import SwiftyJSON

/// 文件上传地址
let uploadFileUrl = "---"
let uploadUnitSize = 1 * 1024 * 1024
let EMBoundary = "BoundaryForEMSystem"

enum EMUploadResult {
  case success(path: String)
  case error(Error)
}

class EMBackgroundService: NSObject,URLSessionTaskDelegate,URLSessionDataDelegate {
	
	/// 文件路径
	var filePath: String!
	
	/// 后台会话
	var backgoundSession: URLSession!
	
	/// 服务器返回数据
	var response: NSMutableData!
	
	/// 上传进度
	var progress:Float = 0.0
	
	var model:EMUploadModel!
	
	fileprivate var progressHandler:((CGFloat)->())?
	fileprivate var completeHandler:((EMUploadResult)->())?
	
	func upload() {
		upload { _ in
			
		} completeHandler: { _ in
			
		}
	}
	
	func upload(progressHandler:@escaping ((CGFloat)->()), completeHandler:@escaping ((EMUploadResult)->())) {
		
		if let loadingModel = EMUploadManager.shared.loadingModel {
			self.model = loadingModel
			self.progressHandler = progressHandler
			self.completeHandler = completeHandler
			startUploadFile()
		} else {
			debugPrint("上传任务为空")
		}

	}
	
	/// 初始化backgoundSession
	func setupBackgroundSession() {
		let now = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYYMMddHHMMSS"
		let dateStr = dateFormatter.string(from: now)
		
		let randomIndex = Int(arc4random()%10000)+1
		let configIndentifier = "EM" + dateStr + String(randomIndex)
		
		let configration = URLSessionConfiguration.background(withIdentifier: configIndentifier)
		/// 设置超时时间
		configration.timeoutIntervalForResource = 12*60*60
		backgoundSession = URLSession(configuration: configration, delegate: self, delegateQueue: OperationQueue.main)
	}
	
	private func startUploadFile() {
		
		setupBackgroundSession()

		model.status = .EMUploading
		/// 上传代码
		uploadUnitWith()
	}
	
	func uploadUnitWith() {
		
		let handle:FileHandle = try! FileHandle.init(forReadingFrom: URL(fileURLWithPath: filePath))
		handle.seek(toFileOffset: UInt64(model.uploadCount*uploadUnitSize))
		let unitData = handle.readData(ofLength: uploadUnitSize)
		
		let params = uploadParams()
		var request = URLRequest(url: URL(string: uploadFileUrl)!)
		request.httpMethod = "POST"
		/// 请求头设置
		let contentType = "multipart/form-data; boundary=\(EMBoundary)"
		request.setValue(contentType, forHTTPHeaderField: "Content-Type")
		
		var uploadData: Data = Data.init()
		
		let keys = params.allKeys;
		for key in keys {
			uploadData.append(String(format:"--%@\r\n",EMBoundary).data(using: .utf8)!)
			uploadData.append(String(format:"Content-Disposition:form-data;name=\"%@\"\r\n\r\n",key as! String).data(using: .utf8)!)
			uploadData.append("\(params[key]!)\r\n".data(using: .utf8)!)
		}
		// 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
		uploadData.append("--\(EMBoundary)".data(using: .utf8)!)
		
		uploadData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(unitData.MD5().hexString()).tmp\"\r\n".data(using: .utf8)!)
		// 文件类型
		uploadData.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
		// 添加文件主体
		uploadData.append(unitData)
		// 使用\r\n来表示这个这个值的结束符
		uploadData.append("\r\n".data(using: .utf8)!)
		
		uploadData.append("--\(EMBoundary)--\r\n".data(using: .utf8)!)
		
		let backgroundTask = backgoundSession.uploadTask(with: request, from: uploadData)
		backgroundTask.resume()
	}
	
	func uploadParams() -> NSDictionary {
		let dict: NSMutableDictionary = NSMutableDictionary.init()
//		dict["unitSize"] = uploadUnitSize
		dict["fileSize"] = model.totalSize
//		dict["extension"] = URL(fileURLWithPath: model.resFilePath).pathExtension
		dict["upload_count"] = model.uploadCount
		dict["token"] = model.token
		return dict
	}
		
	//MARK: 后台上传Delegate
	//MARK: 进度监控
	func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
		
		let currentProgress:Float = Float((Int(totalBytesSent)+model.uploadCount*uploadUnitSize) / model.totalCount)
		progress = Float(currentProgress)
		
		progressHandler?(CGFloat(progress))
		print("\(currentProgress)%")
	}
	
	
	//MARK: - 后台上传完执行代理方法
	func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
		
		if model.uploadCount == model.totalCount {
			model.status = .EMUploaded
			// 此任务完成进行下一个任务
			EMUploadManager.shared.completeTask()
			//此处可能返回后台保存视频的地址
			self.completeHandler?(.success(path: "upload_url"))
			
			//所有文件上传完毕后，释放创建的会话（在结束task后）
			backgoundSession.finishTasksAndInvalidate()
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			if((appDelegate.handler) != nil) {
				// 执行上传完成delegate
				let  handelerComp  = appDelegate.handler
				handelerComp!()
			}

		} else {
			//清空上次后台返回的数据
			self.response = nil
			//继续下一片上传
			uploadUnitWith()
		}
	}
	
	//MARK: 接收返回的数据
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		
		if self.response == nil {
			let resposeData = NSMutableData(data: data)
			self.response = resposeData
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
			//任务数+1
			model.uploadCount += 1
		}
	}

	/// 文件相关处理
//	func fileExist(_ filePath: String) -> Bool {
//		return FileManager.default.fileExists(atPath: filePath)
//	}
	
	class func deleteFiles(filePaths:[String]) {
		for filePath in filePaths {
			try? FileManager.default.removeItem(atPath: filePath)
		}
	}
	
//	func fileSizeAt(_ filePath: String) -> UInt64 {
//		let manager:FileManager = FileManager.default
//		if fileExist(filePath) {
//			let attr = try? manager.attributesOfItem(atPath: filePath)
//			let size = attr?[FileAttributeKey.size] as! UInt64
//			return size
//		}
//		return 0
//	}
}



