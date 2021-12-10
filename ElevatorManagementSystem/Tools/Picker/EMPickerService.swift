//
//  EMPickerService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/5.
//

import Foundation
import UIKit

typealias EMPickerHandler = (_ index:Int) -> Void

class EMPickerService: NSObject{
	
	static let shared = EMPickerService()
		
	// Make sure the class has only one instance
	// Should not init or copy outside
	private override init() {
		super.init()
	}
	
	override func copy() -> Any {
		return self // SingletonClass.shared
	}
	
	override func mutableCopy() -> Any {
		return self // SingletonClass.shared
	}
	
	// Optional
	func reset() {
		// Reset all properties to default value
	}
	
	private var parent = UIApplication.shared.keyWindow?.rootViewController

	var datas:Array = [String]()
	var complete:EMPickerHandler?
	
	func setup() -> Void {
		parent?.view.addSubview(self.mainView)
		self.mainView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		self.mainView.addSubview(pickerView)
		pickerView.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.equalTo(self.mainView.snp.bottom)
		}

	}
	
	lazy var pickerView : UIPickerView = {
		let pick = UIPickerView(frame: .zero)
		pick.backgroundColor = UIColor.white
		pick.delegate = self
		pick.dataSource = self
		return pick
	}()
	
	lazy var mainView : UIView = {
		let tView = UIView(frame: .zero)
		tView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
		let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
		tView.addGestureRecognizer(tap)
		tView.isHidden = true
		return tView
	}()
	
	func showPikcer(items:Array<String>, clouser:@escaping (_ index:Int)->Void)  {
		complete = clouser
		datas = items
		pickerView.reloadComponent(0)
		self.mainView.isHidden = false
		UIView.animate(withDuration: 0.25) {
			self.pickerView.snp.removeConstraints()
			self.pickerView.snp.remakeConstraints { make in
				make.left.right.equalToSuperview()
				make.bottom.equalTo(self.mainView.snp.bottom)
			}
			self.mainView.layoutIfNeeded()
		}
	}
	
	@objc func dismiss() -> Void {
		
		UIView.animate(withDuration: 0.25) {
			self.pickerView.snp.removeConstraints()
			self.pickerView.snp.remakeConstraints { make in
				make.left.right.equalToSuperview()
				make.top.equalTo(self.mainView.snp.bottom)
			}
			self.mainView.layoutIfNeeded()
		} completion: { _ in
			self.mainView.isHidden = true
		}
	}
}

extension EMPickerService : UIPickerViewDataSource,UIPickerViewDelegate {
	
	//MARK: PickerView dataSource
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return datas.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return datas[row]
	}
	
	//MARK: PickerView delegate
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		complete!(row)
	}
}
