//
//  SideMenuAPIs.swift
//  AppO
//
//  Created by Abul Jaleel on 26/09/2024.
//



import Foundation
import Moya

enum SideMenuAPIs {
    case balanceEnquiry(parameters: Parameters)
    case updateCardStatus(parameters: Parameters)
    
}

extension SideMenuAPIs: TargetType {

    var baseURL: URL {
        let urlString: String = AppEnvironment[.systemURL]
        return URL.init(string: urlString)!
    }

    var path: String {
        switch self {
        case .balanceEnquiry:
            return "mobile_app_cust_bal_enq"
        case .updateCardStatus:
            return "sem_mapp_set_card_status"
        }
    }

    var method: Moya.Method {
        switch self {
        case .balanceEnquiry, .updateCardStatus:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .balanceEnquiry(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateCardStatus(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
