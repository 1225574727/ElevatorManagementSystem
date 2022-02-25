//
//  EMPubRequestService.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/12/26.
//

import Foundation

enum EMPubType {
	case records
	case part
	case status
	
	var typeValue: String {
		switch self {
		case .records:
			return "1"
		case .part:
			return "2"
		case .status:
			return "3"
		}
	}
}

class EMPubRequestService {
	
	/// 获取公共类型 1:记录类型2:零件类别
	static func fetchPubType(_ type:EMPubType,closure:@escaping(EMChooseTypesEntity)->Void) {
		
		EMReqeustWithoutActivityProvider.request(.defaultRequest(url: "/order/getSearchCondition", params: ["sysCategory":type.typeValue,"createPerson":EMDeviceService.deviceUUID]), model: EMChooseTypesEntity.self) { model in
			
			if (model?.code == "200") {
				if let model = model {
					closure(model)
				}
			}
		}
	}
}
