//
//  EMHistoryEntity.swift
//  ElevatorManagementSystem
//
//  Created by ylg on 2021/12/26.
//

import Foundation
import HandyJSON

struct EMHistoryItemEntity : HandyJSON {
	
	var createDate: String?
	var orderId: String?
	var status:String? //状态暂未定义
}

struct EMHistoryEntity : HandyJSON {
    
    var code: String?
    var msg: String?
    var data:[EMHistoryItemEntity]?
}
