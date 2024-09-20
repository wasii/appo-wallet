//
//  OTPAPIs 2.swift
//  AppO
//
//  Created by Abul Jaleel on 20/09/2024.
//


import Foundation
import Moya

enum HomeAPIs {
    case customer_enquiry(parameters: Parameters)
    case show_card_number(parameters: Parameters)
}

extension HomeAPIs: TargetType {
    var baseURL: URL {
        let urlString: String = AppEnvironment[.serverOne]
        return URL.init(string: urlString)!
    }

    var path: String {
        switch self {
        case .customer_enquiry:
            return "mobile_app_cust_enq"
        case .show_card_number:
            return "decrypt_cms_card_num"
        }
    }

    var method: Moya.Method {
        switch self {
        case .customer_enquiry, .show_card_number:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .show_card_number(let parameters), .customer_enquiry(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
