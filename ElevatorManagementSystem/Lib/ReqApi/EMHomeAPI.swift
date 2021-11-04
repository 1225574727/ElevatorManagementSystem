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

struct ApvModel: HandyJSON {
    var code: String?
    var data: [String: String]?
    var api: String?
    var msg: String?
}


//https://mpcs.suning.com/mpcs/apv/queryAPV.do?appId=1&appVersion=9.5.35&v=v9


let EMHomeProvider = MoyaProvider<EMHomeAPI>()

enum EMHomeAPI {
    //版本请求
    case fmHomeData(appId: String, appVersion: String, version: String)
    
    //搜索热门
    case searchHot

}

extension EMHomeAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .fmHomeData(let appId, let appVersion, let version):
            return URL(string: "https://mpcs.suning.com")!

        case .searchHot:
            return URL(string: "http://app.u17.com/v3/appV3_3/ios/phone")!
        }
    }
    
    var path: String {
        switch self {
        case .fmHomeData(let appId, let appVersion, let version):
            return "/mpcs/apv/queryAPV.do"
        case .searchHot:
            return "search/hotkeywordsnew"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fmHomeData(let appId, let appVersion, let version):
            return .get
        case .searchHot:
            return .get
        }
    }
    
    var task: Task {
        var parameters = [String: String]()
        
        switch self {
        case .fmHomeData(let appId, let appVersion, let version):
            parameters["appId"] = appId
            parameters["appVersion"] = appVersion
            parameters["v"] = version
        default:break
        }
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return nil
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





