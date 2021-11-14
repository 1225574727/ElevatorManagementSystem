//
//  EMUploadModel.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/11/9.
//

import Foundation
import SwiftyJSON

enum EMUploadStatus {
	/// 未上传
	case EMUnUpload
	/// 上传中
	case EMUploading
	/// 已上传
	case EMUploaded
}

class EMUploadModel: NSObject {
	
	var status:EMUploadStatus = .EMUnUpload
	
	/// token
	var token:String!
	
	/// 本地资源地址
	var resFilePath:String!
	
	/// 上传进度
	var progress:Float = 0.0
	
	/// 总大小
	var totalSize:UInt64 = 0
	
	/// 总片数
	var totalCount:Int = 0
	
	/// 已上传片数
	var uploadCount:Int = 0
}
