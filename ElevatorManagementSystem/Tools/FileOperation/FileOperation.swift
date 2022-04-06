//
//  FileOperation.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2022/1/20.
//

import Foundation

let tmpVideoPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! as String + "/tmpVideo"

//文件操作类
class FileOperation {
	
	static func createVideoDirectory() {
		let manager = FileManager.default
		let exist = manager.fileExists(atPath: tmpVideoPath)
		if !exist
		{
			do{
				try manager.createDirectory(atPath: tmpVideoPath, withIntermediateDirectories: true, attributes: nil)
				print("Succes to create folder")
			}
			catch{
				print("Error to create folder")
			}
		}
	}
	
	// 复制一个文件，到目标位置
	static func copyFile(sourceUrl:String, targetUrl:String) {
		let fileManager = FileManager.default
		do{
			try fileManager.copyItem(atPath: sourceUrl, toPath: targetUrl)
			print("Success to copy file.")
		}catch{
			print("Failed to copy file.")
		}
	}
	
	// 移动文件到目标位置
	static func movingFile(sourceUrl:String, targetUrl:String) -> Bool {
		let fileManager = FileManager.default
		let targetUrl = targetUrl
		print("targetUrl = \(targetUrl)")
		do{
			try fileManager.moveItem(atPath: sourceUrl, toPath: targetUrl)
			print("Succsee to move file.")
			return true
		}catch{
			print("Failed to move file.")
			return false
		}
	}
	
	// 删除目标文件
	static func removeFile(sourceUrl:String){
		
		let url = sourceUrl.replacingOccurrences(of: "file://", with: "")
		let fileManger = FileManager.default
		do{
			try fileManger.removeItem(atPath: url)
			print("Success to remove file - \(url)")
		}catch{
			print("Failed to remove file - \(url)")
		}
	}
	
	// 删除目标文件夹下所有的内容
	static func removeFolder(folderUrl:String){
		let fileManger = FileManager.default
		//        然后获得所有该目录下的子文件夹
		let files:[AnyObject]? = fileManger.subpaths(atPath: folderUrl)! as [AnyObject]
		//        创建一个循环语句，用来遍历所有子目录
		for file in files!
		{
			do{
				//删除指定位置的内容
				try fileManger.removeItem(atPath: folderUrl + "/\(file)")
				print("Success to remove folder.")
			}catch{
				print("Failder to remove folder")
			}
		}
		
	}
 
	// 遍历目标文件夹
	static func listFolder(folderUrl:String){
		let manger = FileManager.default
		//        获得文档目录下所有的内容，以及子文件夹下的内容，在控制台打印所有的数组内容
		let contents = manger.enumerator(atPath: folderUrl)
		print("contents:\(String(describing: contents?.allObjects))")
		
	}
}
