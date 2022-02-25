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

struct EMFloorItemEntity: HandyJSON {
    var componentId: String?
    var name: String?
    var result: String?
}

struct EMComponentItemEntity: HandyJSON {
    var componentId: String?
    var name: String?
    var result: String?
    var photoUrls: String?
    var tags: String?
    var status: String?
    var comment: String?
    
    func photoUrlsArray() -> Array<String> {
        if let photoUrls = photoUrls {
            let array = photoUrls.components(separatedBy: ",")
            return array
        }else{
            return []
        }
    }
}

struct EMHistoryEntity : HandyJSON {
    
    var code: String?
    var msg: String?
    var data:[EMHistoryItemEntity]?
}

struct EMFloorEntity : HandyJSON {
    
    var code: String?
    var msg: String?
    var data:[EMFloorItemEntity]?
}

struct EMComponentEntity : HandyJSON {
    
    var code: String?
    var msg: String?
    var data:EMComponentItemEntity?

}
