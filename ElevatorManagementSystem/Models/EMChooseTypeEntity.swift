//
//  EMChooseTypeEntity.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/27.
//

import Foundation
import HandyJSON

struct EMChooseTypeItemEntity : HandyJSON {
	
	var color:String?
	var judgeType:String?
	var number:String?
	var sysCategory:String? //查询类型 1-记录类型 2-零件类型
	var sysId:String? //类型id
	var sysValue:String? //类型名
	var updateDate:String? //更新时间
}

struct EMChooseTypesEntity : HandyJSON {
	
	var code: String?
	var msg: String?
	var data:[EMChooseTypeItemEntity]?
}


