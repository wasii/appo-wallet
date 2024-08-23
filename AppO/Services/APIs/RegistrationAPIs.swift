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
}

extension RegistrationAPIs: TargetType {

    var baseURL: URL {
        let urlString: String = AppEnvironment[.systemURL]
        return URL.init(string: urlString)!
    }

    var path: String {
        switch self {
        case .registration:
            return "mobile_app_cust_register"
        }
    }

    var method: Moya.Method {
        switch self {
        case .registration:
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
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
