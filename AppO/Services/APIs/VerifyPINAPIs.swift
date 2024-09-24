//
//  VerifyPINAPIs.swift
//  AppO
//
//  Created by Abul Jaleel on 24/09/2024.
//

//
//  OTP.swift
//  AppO
//
//  Created by Abul Jaleel on 19/09/2024.
//

import Foundation
import Moya

enum VerifyPINAPIs {
    case verifyPIN(parameters: Parameters)
    
}

extension VerifyPINAPIs: TargetType {

    var baseURL: URL {
        let urlString: String = AppEnvironment[.serverOne]
        return URL.init(string: urlString)!
    }

    var path: String {
        switch self {
        case .verifyPIN:
            return "device/verify-pin"
        }
    }

    var method: Moya.Method {
        switch self {
        case .verifyPIN:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .verifyPIN(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
