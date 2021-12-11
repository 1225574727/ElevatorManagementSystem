//
//  EMShadowView.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/11.
//

import Foundation
import UIKit

class EMShadowView: UIView {
	
	lazy var shadowLayer: CALayer = {
		let subLayer = CALayer()
		subLayer.cornerRadius = 6
		subLayer.backgroundColor = UIColor.white.cgColor
		subLayer.masksToBounds = false
		subLayer.shadowColor = UIColor.black.cgColor
		subLayer.shadowOffset = CGSize(width: 0, height: 3)
		subLayer.shadowOpacity = 0.16
		return subLayer
	}()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupShadowLayer()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupShadowLayer()
	}
	
	func setupShadowLayer() {
		self.layer.cornerRadius = 8
		self.layer.insertSublayer(shadowLayer, at: 0)
	}
	
	override func layoutSubviews() {
		
		shadowLayer.frame = self.bounds
	}
}
