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
	var service:EMBackgroundService?
	var loadingModel:EMUploadModel?
	
	override init() {}
	
	func addTarget(_ model:EMUploadModel) {
		tasks.append(model)
		
		if let cmodel = tasks.first {
			if (cmodel.status == .EMUnUpload) {
				loadingModel = cmodel
				//无上传任务 首个任务进行上传
				service = resetServcice()
				service!.upload()
			}
		}
	}
	
	func completeTask() {
		
		if let cmodel = tasks.first {
			if (cmodel.status == .EMUploaded) {
				tasks.removeFirst()
				if tasks.count >= 1 {
					loadingModel = tasks.first!
					//继续下一个任务
					service = resetServcice()
					service!.upload()
				}
			}
		}
	}
	
	func saveTasks() {
		
		if !tasks.isEmpty {
			
			var rel = [Dictionary<String, Any>]()
			for model in tasks {
			
				rel.append(model.toJson())
			}
			
			EMUserDefault.set(rel, forKey: "EMVideoUploadTasks")
		}
	}
	
	func loadCacheTasks() {
		
		if let cacheData = EMUserDefault.object(forKey: "EMVideoUploadTasks") {
			for dict in cacheData as! Array<Dictionary<String, Any>> {
				let model = EMUploadModel(name:dict["name"] as! String, videoName: dict["videoName"] as! String, token: dict["token"] as! String, path: dict["resFilePath"] as! String, timer: dict["uploadTimer"] as! String)
				model.uploadCount = dict["uploadCount"] as! Int
				self.addTarget(model)
			}
		}
	}
	
	func resetServcice() -> EMBackgroundService {
		if service != nil {
			service = nil
		}
		return EMBackgroundService()
	}
}
