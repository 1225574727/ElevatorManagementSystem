//
//  EMAlertController.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/10.
//

import Foundation
import UIKit

enum EMAlertType {
	case EMAlertDefault
	case EMAlertUpload
	case EMAlertTipVertical
	case EMAlertProgress
}

typealias EMAlertActionHandler = ((_ index: Int) -> Void)

class EMAlertController: UIViewController {
	
	private let buttonHeight = 44.0
	
	private lazy var contentView:UIView = {
		let alertContainer = UIView()
		alertContainer.backgroundColor = UIColor.white
		alertContainer.layer.cornerRadius = 8
		alertContainer.layer.masksToBounds = true
		alertContainer.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)

		return alertContainer
	}()
	
	private lazy var titleImageView: UIImageView = {
		let iv = UIImageView()
		return iv
	}()
	
	private lazy var titleLabel:UILabel = {
		let label = UILabel.init()
		label.font = UIFont.boldSystemFont(ofSize: 24)
		label.textColor = UIColor.B3
		return label
	}()
	
	private lazy var messageLabel:UILabel = {
		let label = UILabel.init()
		label.numberOfLines = 0
		label.textColor = UIColor.B3
		label.font = UIFont.systemFont(ofSize: 16)
		label.textAlignment = NSTextAlignment.left
		return label
	}()
	
	private lazy var fButton: UIButton = {
		
		let button = UIButton.init(type:.custom)
		button.layer.borderColor = UIColor.Main.cgColor
		button.layer.borderWidth = 1.0
		button.layer.masksToBounds = true
		button.layer.cornerRadius = CGFloat(buttonHeight/2.0)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
		button.setTitleColor(UIColor.Main, for: .normal)
		button.tag = 2017
		button.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
		return button
	}()
	
	private lazy var sButton: UIButton = {
		
		let button = UIButton.init(type:.custom)
		button.backgroundColor = UIColor.Main
		button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
		button.layer.masksToBounds = true
		button.layer.cornerRadius = CGFloat(buttonHeight/2.0)
		button.setTitleColor(UIColor.white, for: .normal)
		button.tag = 2018
		button.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
		return button
	}()
	
	private lazy var progressView: UIProgressView = {
		
		let progress = UIProgressView(progressViewStyle: .default)
		progress.progressTintColor = UIColor.Main
		progress.trackTintColor = UIColor.colorFormHex(0xd4d4d4)
		progress.setProgress(0.0, animated: true)
		for tview in progress.subviews {
			tview.layer.cornerRadius = 10
			tview.clipsToBounds = true
		}
		return progress
	}()
	
	//防止重复弹出视图
	private var firstShow:Bool!

	private var dismissDelay:Double = 0.0
	
	private  var alertImage:UIImage!
	private var alertTitle:String = ""
	private var alertMessage:String = ""
	private var alertButtonsTitle = [String]()
	private var actionHandler:EMAlertActionHandler?
	private var alertType:EMAlertType = .EMAlertDefault
	var imageSize:CGSize = CGSize(width: 94, height: 94)
	
	var progress:Float = 0 {
		didSet {
			progressView.setProgress(progress, animated: true)
		}
	}
	
	convenience init(title : String, message : String, buttons:[String], image:UIImage,type:EMAlertType = .EMAlertDefault, handler:@escaping EMAlertActionHandler){
		
		self.init()
		self.modalPresentationStyle = UIModalPresentationStyle.custom
		self.alertImage = image
		self.alertTitle = title
		self.alertMessage = message
		self.alertButtonsTitle = buttons
		self.alertType = type
		self.actionHandler = handler
		self.firstShow = true
	}
	
	convenience init(progress message:String) {
		
		self.init()
		self.modalPresentationStyle = UIModalPresentationStyle.custom
		self.alertMessage = message
		self.firstShow = true
		self.alertType = .EMAlertProgress
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.addSubview(self.contentView)
		self.contentView.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.left.equalToSuperview().offset(20)
			make.right.equalToSuperview().offset(-20)
		}
		
		if (alertType == .EMAlertProgress) {
			self.contentView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
			contentView.addSubview(progressView)
			progressView.snp.makeConstraints { make in
				make.left.right.top.equalToSuperview().inset(UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 20))
				make.height.equalTo(20)
			}
			
			messageLabel.text = alertMessage
			messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
			contentView.addSubview(self.messageLabel)
			messageLabel.snp.makeConstraints { make in
				make.top.equalTo(progressView.snp.bottom).offset(10)
				make.centerX.equalToSuperview()
				make.bottom.equalToSuperview().offset(-49)
			}
			return
		}
		
		self.contentView.addSubview(self.titleImageView)
		self.titleImageView.image = self.alertImage
		self.titleImageView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(20)
			make.centerX.equalToSuperview()
			make.width.equalTo(imageSize.width)
			make.height.equalTo(imageSize.height)
		}
		
		self.titleLabel.text = self.alertTitle
		self.contentView.addSubview(self.titleLabel)
		self.titleLabel.snp.makeConstraints { make in
			make.top.equalTo(self.titleImageView.snp.bottom)
			make.centerX.equalToSuperview()
		}
		
		//通过富文本来设置行间距
		if alertType != .EMAlertUpload {
			let paraph = NSMutableParagraphStyle()
			//将行间距设置为28
			paraph.lineSpacing = 8
			//样式属性集合
			let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),
							  NSAttributedString.Key.paragraphStyle: paraph]
			self.messageLabel.attributedText = NSAttributedString(string: self.alertMessage, attributes: attributes)
			self.contentView.addSubview(self.messageLabel)
			self.messageLabel.snp.makeConstraints { make in
				make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
				make.left.equalToSuperview().offset(23)
				make.right.equalToSuperview().offset(-23)
			}
		}
		
		self.fButton.setTitle(self.alertButtonsTitle[0], for: .normal)
		self.contentView.addSubview(self.fButton)
		self.fButton.snp.makeConstraints { make in
			if alertType == .EMAlertUpload {
				make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
			} else {
				make.top.equalTo(self.messageLabel.snp.bottom).offset(30)
			}
			make.height.equalTo(buttonHeight)
			if alertType == .EMAlertDefault {
				make.left.equalToSuperview().offset(20)
				make.bottom.equalToSuperview().offset(-30)
			} else {
				make.left.equalToSuperview().offset(40)
				make.right.equalToSuperview().offset(-40)
			}
			
		}
		
		self.sButton.setTitle(self.alertButtonsTitle[1], for: .normal)
		self.contentView.addSubview(self.sButton)
		self.sButton.snp.makeConstraints { make in
			
			make.width.height.equalTo(self.fButton)
			if alertType == .EMAlertDefault {
				make.right.equalToSuperview().offset(-20)
				make.left.equalTo(self.fButton.snp.right).offset(23)
				make.centerY.equalTo(self.fButton)
			} else {
				make.centerX.equalTo(self.fButton)
				make.top.equalTo(self.fButton.snp.bottom).offset(16)
				make.bottom.equalToSuperview().offset(-30)
			}
		}
	}

	override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		
		self.view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
		
		if dismissDelay == 0.0{
			self.showAlert()
		}else{
			self.showAndDismiss(delay: self.dismissDelay)
		}
	}
	
	
	//点击事件
	@objc private func didClickButton(sender:UIButton){
		
		self.dismissAnimation()
		if let handler = actionHandler {
			handler(sender.tag - 2017)
		}
	}
	
	func show(_ target:AnyObject){
		
		target.present(self, animated: false, completion: nil)
	}
	
	func showWith(target:AnyObject, delay:Double) {
		
		target.present(self, animated: false, completion: nil)
		self.dismissDelay = delay
	}
	
	/*出现动画*/
	 func showAlert(){
		
		if (self.firstShow == true){
			
			self.firstShow = false
			UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 5.0, options: .curveEaseInOut, animations: {
				
				self.contentView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
				self.contentView.alpha = 1
				
			}, completion: nil)
			
		}
	}
	
	/*2S自动消失*/
	private func showAndDismiss(delay:Double){
		
		if (self.firstShow == true){
			
			self.firstShow = false
			UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 5.0, options: .curveEaseInOut, animations: {
				
				self.contentView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
				self.contentView.alpha = 1
				
			}, completion: nil)
			
			UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 15.0, options: .curveEaseInOut, animations: {

				self.contentView.alpha = 0
				self.view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
				self.dismiss(animated: false, completion: nil)

			}, completion:{ _ in
				
			})
		}
	}
	
	
	@objc private func dismissAnimation(){
	
		UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 15.0, options: .curveLinear, animations: {
			
			self.contentView.alpha = 0
			self.view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
			self.dismiss(animated: false, completion: nil)
			
		}, completion: { (isFinished) in
			
		})
	}

}
