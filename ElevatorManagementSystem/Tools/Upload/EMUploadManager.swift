//
//  EMUploadManager.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/30.
//

import Foundation

class EMUploadManager : NSObject {
	
	static let shared = EMUploadManager()
	
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
				service?.upload()
			}
		}
	}
	
	func completeTask() {
		
		if let cmodel = tasks.first {
			if (cmodel.status == .EMUploaded) {
				tasks.removeFirst()
				if tasks.count > 1 {
					loadingModel = tasks.first!
					//继续下一个任务
					service?.upload()
				}
			}
		}
	}
}
