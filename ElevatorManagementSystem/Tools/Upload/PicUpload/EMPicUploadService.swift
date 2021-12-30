//
//  EMPicUploadService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/28.
//

import Foundation
import UIKit
import HandyJSON
import SwiftyJSON

let uploadUrl = PCDBaseURL + "/upload/public/uploadImageMuch"

struct EMPicUploadResponse : HandyJSON {
	
	var code: String?
	var msg: String?
	var data:[String]?
}

class EMPicUploadService {
	
	static func uploadUnitWith(_ images:[UIImage], clouser:@escaping (EMPicUploadResponse?)->Void) {
	
		guard images.count > 0 else {
			return
		}
		var request = URLRequest(url: URL(string: uploadUrl)!)
		request.httpMethod = "POST"
		/// 请求头设置
		request.setValue("multipart/form-data; boundary=\(EMBoundary)", forHTTPHeaderField: "Content-Type")
		
		var uploadData = Data()
//		uploadData.append(String(format:"--%@\r\n",EMBoundary).data(using: .utf8)!)
//		uploadData.append("Content-Disposition:form-data;name=\"key\"\r\n\r\n".data(using: .utf8)!)
//		uploadData.append("multipartFile\r\n".data(using: .utf8)!)

		for image in images {
			
			if let data = image.pngData() {
				
				uploadData.append("--\(EMBoundary)\r\n".data(using: .utf8)!)
				//filename必须要有文件后缀，否则后端报错！！！
				uploadData.append("Content-Disposition: form-data; name=\"multipartFile\"; filename=\"\(data.MD5().hexString()).jpeg\"\r\n".data(using: .utf8)!) //multipartFile
				// 文件类型 万能类型 application/octet-stream、image/png
				//添加流前需要使用\r\n\r\n换行并空一行！！！
				uploadData.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
				// 添加文件流
				uploadData.append(data)
				uploadData.append("\r\n".data(using: .utf8)!)
			}
		}
		uploadData.append("\r\n--\(EMBoundary)".data(using: .utf8)!)

		var uploadTask : URLSessionUploadTask!
		let session = URLSession.shared
		uploadTask = session.uploadTask(with: request, from: uploadData) {
			(data:Data?, response:URLResponse?, error:Error?) -> Void in
			//上传完毕后
			if error != nil{
				print(error!)
			}else{
//				let str = String(data: data!, encoding: String.Encoding.utf8)

				if data != nil {
					let json = JSON(data!)
					let model = JSONDeserializer<EMPicUploadResponse>.deserializeFrom(json: json.description)
					clouser(model)
				}
			}
		}
		
		//使用resume方法启动任务
		uploadTask.resume()

	}
	
	
}
