//
//  FMHomeAPI.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/9/7.
//

import Foundation
import Moya
import HandyJSON
import UIKit
import SwiftyJSON
import MBProgressHUD

struct EMBaseModel: HandyJSON {
    var code: String?
    var msg: String?
	var data: Any?
}

let EMRequestProvider = MoyaProvider<EMRequestAPI>(plugins:[EMRequestLoadingPlugin(true)])

let EMReqeustWithoutActivityProvider = MoyaProvider<EMRequestAPI>(plugins:[EMRequestLoadingPlugin(false)])

enum EMRequestAPI {
	//通用请求
	case defaultRequest(url: String, params:[String: Any])
}

extension EMRequestAPI: TargetType {
    
    var baseURL: URL {
        switch self {
		case .defaultRequest(_, _):
            return URL(string: PCDBaseURL)!
        }
    }
    
    var path: String {
        switch self {
		case .defaultRequest(let path, _):
			return path
        }
    }
    
    var method: Moya.Method {
        switch self {
		case .defaultRequest(_, _):
			return .post
        }
    }
    
    var task: Task {
        var parameters = [String: Any]()
        
        switch self {
		case .defaultRequest(_, let params):
			parameters = params
        }
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
		return ["Content-Type":"application/json; charset=utf-8"]
    }
}

extension MoyaProvider {
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        
        return request(target, completion: { (result) in
            
            guard let completion = completion else { return }

            if case let .success(response) = result {
                if response.statusCode == 200  {
                    
                    let data = try? response.mapJSON()
                    
                    if data != nil {
                        let json = JSON(data!)
                        let model = JSONDeserializer<T>.deserializeFrom(json: json.description)
                        completion(model)
                        return
                    }
                    
                }
            }
           
            completion(nil)
        })
    }
}

class EMRequestLoadingPlugin: PluginType {
	
	var isShow: Bool
	init(_ show:Bool = true) {
		isShow = show
	}
	
	var hudMB: MBProgressHUD?
	
	func showActivity() {
		EMEventAtMain {
			let rootController = UIApplication.shared.keyWindow?.rootViewController
			guard let parent = rootController else {
				print("rootViewController is nil")
				return
			}
			if self.hudMB == nil {
				self.hudMB = MBProgressHUD.showAdded(to: parent.view, animated: true)
			} else {
				self.hudMB?.show(animated: true)
			}
			self.hudMB?.mode = .indeterminate
			self.hudMB?.label.text = "正在请求数据..."
		}
}
	
	func hideActivity() {
		EMEventAtMain {
			self.hudMB?.hide(animated: true)
		}
	}

	func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
		var tRequest = request
		tRequest.timeoutInterval = 60
//		tRequest.headers.update(.contentType("application/json; charset=utf-8"))
//		tRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
		return tRequest
	}
	
	func willSend(_ request: RequestType, target: TargetType) {

		if isShow {
			showActivity()
		}
	}
	
	func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
		
		if isShow {
			hideActivity()
		}
	}
}


