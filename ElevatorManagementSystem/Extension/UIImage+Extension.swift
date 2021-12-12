//
//  UIImage+Extension.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/3.
//

import Foundation
import UIKit

extension UIImage {
	// 图片压缩
	func compressImage(maxLength: Int) -> UIImage {
		let tempMaxLength: Int = maxLength / 8
		var compression: CGFloat = 1
		guard var data = self.jpegData(compressionQuality: compression), data.count > tempMaxLength else { return self }
		
		// 压缩大小
		var max: CGFloat = 1
		var min: CGFloat = 0
		for _ in 0..<6 {
			compression = (max + min) / 2
			data = self.jpegData(compressionQuality: compression)!
			if CGFloat(data.count) < CGFloat(tempMaxLength) * 0.9 {
				min = compression
			} else if data.count > tempMaxLength {
				max = compression
			} else {
				break
			}
		}
		var resultImage: UIImage = UIImage(data: data)!
		if data.count < tempMaxLength { return resultImage }
		
		// 压缩大小
		var lastDataLength: Int = 0
		while data.count > tempMaxLength && data.count != lastDataLength {
			lastDataLength = data.count
			let ratio: CGFloat = CGFloat(tempMaxLength) / CGFloat(data.count)
			print("Ratio =", ratio)
			let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
									  height: Int(resultImage.size.height * sqrt(ratio)))
			UIGraphicsBeginImageContext(size)
			resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
			resultImage = UIGraphicsGetImageFromCurrentImageContext()!
			UIGraphicsEndImageContext()
			data = resultImage.jpegData(compressionQuality: compression)!
		}
		return resultImage
	}
	
	static func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage{

			let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
			UIGraphicsBeginImageContext(rect.size)
			let context: CGContext = UIGraphicsGetCurrentContext()!
			context.setFillColor(color.cgColor)
			context.fill(rect)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsGetCurrentContext()
			return image!
		}
}
