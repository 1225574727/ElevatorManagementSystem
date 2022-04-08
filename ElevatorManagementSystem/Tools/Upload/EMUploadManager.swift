//
//  EMUploadManager.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/30.
//

import Foundation

class EMUploadManager : NSObject {
	
	static let shared = EMUploadManager()
	
	var isActivity: Bool = true
	var tasks:[EMUploadModel] = []
	var service:EMBackgroundService = EMBackgroundService()
	var loadingModel:EMUploadModel?
	
	override init() {}
	
	func addTarget(_ model:EMUploadModel) {
		tasks.append(model)
		
		if let cmodel = tasks.first {
			if (cmodel.status == .EMUnUpload) {
				loadingModel = cmodel
				//无上传任务 首个任务进行上传
//				service = resetServcice()
				service.upload()
			}
		}
	}
	
	func completeTask() {
		
		if let cmodel = tasks.first {
			if (cmodel.status == .EMUploaded) {
				print("======移除数据\(cmodel.toJson())")
				tasks.removeFirst()
				if tasks.count >= 1 {
					loadingModel = tasks.first!
					//继续下一个任务
//					service = resetServcice()
					service.upload()
				}
			}
		}
	}
	
	func continueTask () {
		
		if let cmodel = tasks.first {
			if (cmodel.status == .EMUploadFailed || cmodel.status == .EMUnUpload) {
				cmodel.status = .EMUploading
				loadingModel = cmodel
				//无上传任务 首个任务进行上传
				service.upload()
			}
		}
	}
	
	func saveTasks() {
		
		if !tasks.isEmpty {
			
			var rel = [Dictionary<String, Any>]()
			for model in tasks {
			
				rel.append(model.toJson())
			}
			print("======保存数据\(rel)")
			EMUserDefault.set(rel, forKey: "EMVideoUploadTasks")
			EMUserDefault.synchronize()
		} else {
			print("======保存数据为空")
			EMUserDefault.set([], forKey: "EMVideoUploadTasks")
			EMUserDefault.synchronize()
		}
	}
	
	func loadCacheTasks() {
		
		if let cacheData = EMUserDefault.object(forKey: "EMVideoUploadTasks") {
			print("======缓存数据---\(cacheData)")
			for dict in cacheData as! Array<Dictionary<String, Any>> {
				let model = EMUploadModel(name:dict["name"] as! String, videoName: dict["videoName"] as! String, token: dict["token"] as! String, timer: dict["uploadTimer"] as! String)
				model.uploadCount = dict["uploadCount"] as! Int

				self.addTarget(model)
			}
		}
	}
	
//	func resetServcice() -> EMBackgroundService {
//		if service != nil {
//			service = nil
//		}
//		return EMBackgroundService()
//	}
}
