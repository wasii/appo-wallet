//
//  OTP.swift
//  AppO
//
//  Created by Abul Jaleel on 19/09/2024.
//

import Foundation
import Moya

enum OTPAPIs {
    case sendOTP(parameters: Parameters)
    case validateOTP(number:String, otp:String)
}

extension OTPAPIs: TargetType {

    var baseURL: URL {
        let urlString: String = AppEnvironment[.serverOne]
        return URL.init(string: urlString)!
    }

    var path: String {
        switch self {
        case .sendOTP:
            return "twilio/sendOTP"
        case .validateOTP(let number, let otp):
            return "twilio/validateOTP/\(number)/\(otp)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .sendOTP:
            return .post
        case .validateOTP(_, _):
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .sendOTP(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .validateOTP(_, _):
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
