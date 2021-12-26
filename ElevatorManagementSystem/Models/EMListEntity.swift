//
//  EMListEntity.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/26.
//

import Foundation
import HandyJSON

struct EMListItemEntity : HandyJSON {
	
	var equipmentId: String?
	var name: String?
	var doorDistance: String?
}

struct EMListEntity : HandyJSON {
	
	var code: String?
	var msg: String?
	var data:[EMListItemEntity]?
}
