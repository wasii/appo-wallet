//
//  RegistrationAPIs.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation
import Moya

enum RegistrationAPIs {
    case registration(parameters: Parameters)
    case customer_validation(parameters: Parameters)
}

extension RegistrationAPIs: TargetType {

    var baseURL: URL {
        switch self {
        case .registration:
            let urlString: String = AppEnvironment[.systemURL]
            return URL.init(string: urlString)!
        case .customer_validation:
            return URL.init(string: "http://3.13.197.45:8080/")!
        }
    }

    var path: String {
        switch self {
        case .registration:
            return "mobile_app_cust_register"
        case .customer_validation:
            return "customer/validateRegularAcc"
        }
    }

    var method: Moya.Method {
        switch self {
        case .registration, .customer_validation:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .registration(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .customer_validation(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
