//
//  EMUploadModel.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/11/9.
//

import Foundation
import SwiftyJSON
import HandyJSON

enum EMUploadStatus {
	/// 未上传
	case EMUnUpload
	/// 上传中
	case EMUploading
	/// 已上传
	case EMUploaded
	/// 上传失败
	case EMUploadFailed
}

func fileSizeAt(_ filePath: String) -> UInt64 {
	let manager:FileManager = FileManager.default
	let path = filePath.replacingOccurrences(of: "file://", with: "")
	if fileExist(path) {
		let attr = try? manager.attributesOfItem(atPath: path)
		let size = attr?[FileAttributeKey.size] as! UInt64
		return size
	}
	return 0
}

func fileExist(_ filePath: String) -> Bool {
	return FileManager.default.fileExists(atPath: filePath)
}

class EMUploadModel: NSObject {
	
	var status:EMUploadStatus = .EMUnUpload
	
	/// 电梯name
	var name:String!
	
	/// token
	var token:String!
	
	/// 本地资源地址
	var resFilePath:String!
	
	// 视频名称
	var videoName:String!
	
	// 上传时间
	var uploadTimer:String!
	
	/// 上传进度
	var progress:Float = 0.0
	
	/// 总大小
	var totalSize:UInt64 = 0
	
	/// 总片数
	var totalCount:Int = 0
	
	/// 已上传片数
	var uploadCount:Int = 0
	
	init(name:String, videoName:String, token:String, timer:String) {
		self.name = name
		self.videoName = videoName
		self.token = token
		self.resFilePath = tmpVideoPath + "/" + videoName
		self.uploadTimer = timer
		
		let totalSize = fileSizeAt(self.resFilePath)
		let totalCount = Int(UInt(totalSize))/uploadUnitSize + (Int(UInt(totalSize))%uploadUnitSize == 0 ? 0 : 1)
		self.totalSize = totalSize
		self.totalCount = totalCount
	}
	
	func toJson() -> [String: Any] {
		
        return ["name":name!, "videoName":videoName!, "token":token!, "uploadTimer":uploadTimer!, "uploadCount":uploadCount,"totalCount":totalCount,"totalSize":totalSize,"progress":progress]
	}
}
